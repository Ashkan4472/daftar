import 'package:core/core.dart';
import 'package:drift/drift.dart';

import '../theme/palette.dart';
import 'database.dart';

/// Banks we know by name. Only banks with a verified template parse reliably.
const seedBanks = [
  ('resalat', 'Resalat', 'رسالت'),
  ('melli', 'Melli', 'ملی'),
  ('mellat', 'Mellat', 'ملت'),
  ('saderat', 'Saderat', 'صادرات'),
  ('tejarat', 'Tejarat', 'تجارت'),
  ('sepah', 'Sepah', 'سپه'),
  ('pasargad', 'Pasargad', 'پاسارگاد'),
  ('saman', 'Saman', 'سامان'),
  ('parsian', 'Parsian', 'پارسیان'),
  ('keshavarzi', 'Keshavarzi', 'کشاورزی'),
  ('maskan', 'Maskan', 'مسکن'),
  ('refah', 'Refah', 'رفاه'),
  ('ayandeh', 'Ayandeh', 'آینده'),
  ('eghtesad_novin', 'Eghtesad Novin', 'اقتصاد نوین'),
  ('shahr', 'Shahr', 'شهر'),
  ('sina', 'Sina', 'سینا'),
  ('post', 'Post Bank', 'پست بانک'),
  ('blu', 'Blu', 'بلو'),
];

/// (key, icon, children[(key, icon)])
const seedExpenseCategories = [
  ('groceries', 'shopping-cart', <(String, String)>[]),
  ('restaurants', 'fork-knife', <(String, String)>[]),
  ('transport', 'car', [('taxi', 'taxi'), ('fuel', 'gas-pump'), ('public_transport', 'bus')]),
  ('housing', 'house', [('rent', 'key'), ('repairs', 'wrench')]),
  ('bills', 'receipt', [
    ('electricity', 'lightning'), ('water', 'drop'), ('gas', 'flame'),
    ('internet', 'wifi-high'), ('mobile', 'device-mobile'),
  ]),
  ('health', 'first-aid-kit', <(String, String)>[]),
  ('shopping', 'shopping-bag', <(String, String)>[]),
  ('clothing', 't-shirt', <(String, String)>[]),
  ('education', 'graduation-cap', <(String, String)>[]),
  ('entertainment', 'film-slate', <(String, String)>[]),
  ('subscriptions', 'repeat', <(String, String)>[]),
  ('travel', 'airplane', <(String, String)>[]),
  ('gifts', 'gift', <(String, String)>[]),
  ('family', 'users-three', <(String, String)>[]),
  ('personal_care', 'sparkle', <(String, String)>[]),
  ('fees_taxes', 'bank', <(String, String)>[]),
  ('installments', 'calendar-check', <(String, String)>[]),
  ('charity', 'hand-heart', <(String, String)>[]),
  ('other_expense', 'dots-three-circle', <(String, String)>[]),
];

const seedIncomeCategories = [
  ('salary', 'briefcase'),
  ('freelance', 'laptop'),
  ('gift_income', 'gift'),
  ('refund', 'arrow-u-up-left'),
  ('profit', 'chart-line-up'),
  ('other_income', 'dots-three-circle'),
];

const seedTags = [
  ('essential', 'check-circle'),
  ('impulse', 'lightning'),
  ('work', 'briefcase'),
  ('reimbursable', 'arrow-counter-clockwise'),
  ('online', 'globe'),
  ('recurring', 'repeat'),
  ('cash', 'money'),
];

const _englishNames = {
  'fees_taxes': 'Fees & Taxes',
  'restaurants': 'Restaurants & Cafe',
  'taxi': 'Taxi / Snapp',
  'gift_income': 'Gift',
  'profit': 'Profit / Interest',
  'other_expense': 'Other',
  'other_income': 'Other',
};

String _title(String key) => _englishNames[key] ?? key
    .split('_')
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');

Future<void> seedDefaults(AppDb db) async {
  await db.batch((b) {
    b.insertAll(db.banks, [
      for (final (code, en, fa) in seedBanks)
        BanksCompanion.insert(code: code, nameEn: en, nameFa: fa),
    ]);
    b.insertAll(db.tags, [
      for (final (i, (key, icon)) in seedTags.indexed)
        TagsCompanion.insert(
          name: _title(key), nameKey: Value(key), icon: '$icon:regular',
          color: pickerPalette[(i * 3) % pickerPalette.length], builtin: const Value(true),
        ),
    ]);
  });

  var sort = 0;
  for (final (i, (key, icon, children)) in seedExpenseCategories.indexed) {
    final color = pickerPalette[i % pickerPalette.length];
    final parent = await db.into(db.categories).insert(CategoriesCompanion.insert(
          kind: CategoryKind.expense, name: _title(key), nameKey: Value(key),
          icon: '$icon:regular', color: color, builtin: const Value(true), sort: Value(sort++),
        ));
    for (final (ck, ci) in children) {
      await db.into(db.categories).insert(CategoriesCompanion.insert(
            parentId: Value(parent), kind: CategoryKind.expense, name: _title(ck),
            nameKey: Value(ck), icon: '$ci:regular', color: color,
            builtin: const Value(true), sort: Value(sort++),
          ));
    }
  }
  for (final (i, (key, icon)) in seedIncomeCategories.indexed) {
    await db.into(db.categories).insert(CategoriesCompanion.insert(
          kind: CategoryKind.income, name: _title(key), nameKey: Value(key),
          icon: '$icon:regular', color: pickerPalette[(i * 2 + 3) % pickerPalette.length],
          builtin: const Value(true), sort: Value(sort++),
        ));
  }

  final banks = {for (final b in await db.select(db.banks).get()) b.code: b.id};
  for (final t in builtinTemplates) {
    await db.into(db.smsTemplates).insert(SmsTemplatesCompanion.insert(
          code: t.id, bankId: Value(banks[t.bankCode]), sender: Value(t.sender),
          pattern: t.pattern, builtin: const Value(true), verified: Value(t.verified),
        ));
  }

  await db.into(db.accounts).insert(AccountsCompanion.insert(
        name: 'Cash', kind: AccountKind.cash, icon: 'wallet:regular', color: pickerPalette[3],
      ));
}

/// Persian names for built-in categories and tags, keyed by `nameKey`.
const seedNamesFa = {
  'groceries': 'خواربار', 'restaurants': 'رستوران و کافه', 'transport': 'حمل‌ونقل',
  'taxi': 'تاکسی / اسنپ', 'fuel': 'سوخت', 'public_transport': 'حمل‌ونقل عمومی',
  'housing': 'مسکن', 'rent': 'اجاره', 'repairs': 'تعمیرات', 'bills': 'قبوض',
  'electricity': 'برق', 'water': 'آب', 'gas': 'گاز', 'internet': 'اینترنت',
  'mobile': 'موبایل', 'health': 'سلامت', 'shopping': 'خرید', 'clothing': 'پوشاک',
  'education': 'آموزش', 'entertainment': 'سرگرمی', 'subscriptions': 'اشتراک‌ها',
  'travel': 'سفر', 'gifts': 'هدیه', 'family': 'خانواده', 'personal_care': 'مراقبت شخصی',
  'fees_taxes': 'کارمزد و مالیات', 'installments': 'اقساط', 'charity': 'خیریه',
  'other_expense': 'سایر هزینه‌ها', 'salary': 'حقوق', 'freelance': 'فریلنس',
  'gift_income': 'هدیه دریافتی', 'refund': 'بازپرداخت', 'profit': 'سود',
  'other_income': 'سایر درآمدها', 'essential': 'ضروری', 'impulse': 'هیجانی',
  'work': 'کاری', 'reimbursable': 'قابل برگشت', 'online': 'آنلاین',
  'recurring': 'تکراری', 'cash': 'نقدی', 'Cash': 'نقد',
};

/// Display name: translated built-in name unless the user renamed it.
String displayName(String name, String? nameKey, String lang) =>
    lang == 'fa' && nameKey != null ? (seedNamesFa[nameKey] ?? name) : name;
