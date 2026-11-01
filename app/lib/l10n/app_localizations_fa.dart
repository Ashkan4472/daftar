// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'دفتر';

  @override
  String get tabHome => 'خانه';

  @override
  String get tabTransactions => 'تراکنش‌ها';

  @override
  String get tabReports => 'گزارش‌ها';

  @override
  String get tabPeople => 'افراد';

  @override
  String get add => 'افزودن';

  @override
  String get income => 'درآمد';

  @override
  String get expense => 'هزینه';

  @override
  String get net => 'خالص';

  @override
  String get balance => 'موجودی';

  @override
  String get accounts => 'حساب‌ها';

  @override
  String get rial => 'ریال';

  @override
  String get toman => 'تومان';

  @override
  String get settings => 'تنظیمات';

  @override
  String get language => 'زبان';

  @override
  String get showToman => 'نمایش مبالغ به تومان';

  @override
  String get comingSoon => 'به‌زودی';

  @override
  String get prevMonth => 'ماه قبل';

  @override
  String get nextMonth => 'ماه بعد';

  @override
  String get back => 'بازگشت';

  @override
  String get importSms => 'ورود پیامک';

  @override
  String get importSmsTitle => 'ورود پیامک بر اساس تاریخ';

  @override
  String get from => 'از';

  @override
  String get to => 'تا';

  @override
  String get startImport => 'شروع ورود';

  @override
  String get cancel => 'لغو';

  @override
  String importProgress(int done, int total) {
    return '$done / $total پیامک';
  }

  @override
  String importDone(int added, int unmatched) {
    return '$added تراکنش وارد شد، $unmatched پیامک ناشناخته';
  }

  @override
  String get smsPermissionDenied =>
      'برای خواندن پیامک‌های بانکی، دسترسی پیامک لازم است.';

  @override
  String get importHint =>
      'بازهٔ تاریخ را انتخاب کنید. پیامک‌های قبلاً واردشده نادیده گرفته می‌شوند، پس تکرار آن بی‌خطر است.';

  @override
  String get importFirstTitle => 'پیامک‌های بانکی را وارد کنید';

  @override
  String get importFirstHint =>
      'دفتر پیامک‌های بانکی همین گوشی را می‌خواند و به تراکنش تبدیل می‌کند. هیچ چیز از گوشی شما خارج نمی‌شود.';

  @override
  String get unmatchedSms => 'پیامک‌های ناشناخته';

  @override
  String get netThisMonth => 'خالص این ماه';

  @override
  String savingsRate(String pct) {
    return '$pct٪ پس‌انداز';
  }

  @override
  String get toReview => 'برای بررسی';

  @override
  String toReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش بدون دسته',
      zero: 'موردی برای بررسی نیست',
    );
    return '$_temp0';
  }

  @override
  String get reviewNow => 'بررسی';

  @override
  String get recent => 'اخیر';

  @override
  String get seeAll => 'همه';

  @override
  String get noTransactions => 'تراکنشی نیست';

  @override
  String get noTransactionsHint =>
      'پیامک‌های بانکی را وارد کنید یا دستی اضافه کنید.';

  @override
  String get noResults => 'موردی پیدا نشد';

  @override
  String get noResultsHint =>
      'کلمات دیگری را امتحان کنید یا فیلترها را پاک کنید.';

  @override
  String get search => 'جستجو در یادداشت و پیامک';

  @override
  String get filterAll => 'همه';

  @override
  String get filterExpense => 'هزینه‌ها';

  @override
  String get filterIncome => 'درآمدها';

  @override
  String get filterToReview => 'برای بررسی';

  @override
  String get filterMarked => 'نشان‌دار';

  @override
  String get filterGap => 'اختلاف موجودی';

  @override
  String get moreFilters => 'فیلترهای بیشتر';

  @override
  String get clearFilters => 'پاک‌کردن فیلترها';

  @override
  String get allMonths => 'همهٔ ماه‌ها';

  @override
  String selectedCount(int count) {
    return '$count انتخاب';
  }

  @override
  String get applyFilters => 'نمایش نتایج';

  @override
  String get uncategorized => 'بدون دسته';

  @override
  String get category => 'دسته';

  @override
  String get categories => 'دسته‌ها';

  @override
  String get tags => 'برچسب‌ها';

  @override
  String get tag => 'برچسب';

  @override
  String get expenseCategories => 'هزینه';

  @override
  String get incomeCategories => 'درآمد';

  @override
  String allOf(String name) {
    return 'کل $name';
  }

  @override
  String get newCategory => 'دستهٔ جدید';

  @override
  String get editCategory => 'ویرایش دسته';

  @override
  String get newTag => 'برچسب جدید';

  @override
  String get editTag => 'ویرایش برچسب';

  @override
  String get parentCategory => 'دستهٔ والد';

  @override
  String get noParent => 'هیچ (سطح اول)';

  @override
  String get name => 'نام';

  @override
  String get nameRequired => 'نام را وارد کنید';

  @override
  String get icon => 'آیکون';

  @override
  String get color => 'رنگ';

  @override
  String get chooseIcon => 'انتخاب آیکون';

  @override
  String get searchIcons => 'جستجوی آیکون (مثلاً غذا، ماشین)';

  @override
  String get iconWeight => 'سبک';

  @override
  String get archive => 'بایگانی';

  @override
  String get unarchive => 'خروج از بایگانی';

  @override
  String get archived => 'بایگانی‌شده';

  @override
  String get mergeInto => 'ادغام در…';

  @override
  String mergeConfirm(String name) {
    return 'همهٔ تراکنش‌ها به «$name» منتقل و این دسته بایگانی شود؟';
  }

  @override
  String get merge => 'ادغام';

  @override
  String get deleteTagConfirm => 'این برچسب از همهٔ تراکنش‌ها حذف شود؟';

  @override
  String get addTransaction => 'افزودن تراکنش';

  @override
  String get typeExpense => 'هزینه';

  @override
  String get typeIncome => 'درآمد';

  @override
  String get amount => 'مبلغ';

  @override
  String get amountRequired => 'مبلغ را وارد کنید';

  @override
  String get date => 'تاریخ';

  @override
  String get time => 'ساعت';

  @override
  String get account => 'حساب';

  @override
  String get note => 'یادداشت';

  @override
  String get addNote => 'یادداشت بگذارید';

  @override
  String get save => 'ذخیره';

  @override
  String get done => 'تمام';

  @override
  String get edit => 'ویرایش';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'بازگردانی';

  @override
  String get movedToTrash => 'به سطل زباله رفت';

  @override
  String get mark => 'نشان‌دار کردن';

  @override
  String get unmark => 'برداشتن نشان';

  @override
  String get excludeFromReports => 'حذف از گزارش‌ها';

  @override
  String get excludeHint =>
      'برای جابه‌جایی پول یا مبلغی که واقعاً مال شما نیست.';

  @override
  String get originalSms => 'پیامک اصلی';

  @override
  String get balanceAfter => 'موجودی پس از آن';

  @override
  String get sourceSms => 'از پیامک';

  @override
  String get sourceManual => 'دستی';

  @override
  String get sourceImport => 'واردشده';

  @override
  String get gapTitle => 'موجودی با پیامک قبلی نمی‌خواند';

  @override
  String gapExplain(String amount) {
    return '$amount از پیامک قبلی بی‌حساب است. شاید پیامکی گم شده یا پول از راه دیگری جابه‌جا شده.';
  }

  @override
  String get needsReviewHint =>
      'با قاعدهٔ عمومی خوانده شد. مبلغ را بررسی کنید.';

  @override
  String get trash => 'سطل زباله';

  @override
  String get trashEmpty => 'سطل زباله خالی است';

  @override
  String get trashHint => 'موارد پس از ۳۰ روز برای همیشه پاک می‌شوند.';

  @override
  String get restore => 'بازیابی';

  @override
  String get transfer => 'انتقال';

  @override
  String get reviewTitle => 'بررسی';

  @override
  String reviewProgress(int done, int total) {
    return '$done از $total';
  }

  @override
  String get reviewDone => 'همه‌چیز بررسی شد';

  @override
  String get reviewDoneHint => 'همهٔ تراکنش‌ها دسته دارند.';

  @override
  String get skip => 'رد کردن';

  @override
  String get previous => 'قبلی';

  @override
  String get sameAsLast => 'مثل دفعهٔ قبل';

  @override
  String get pickCategory => 'یک دسته انتخاب کنید';

  @override
  String get settingsGeneral => 'عمومی';

  @override
  String get settingsData => 'داده‌ها';

  @override
  String get settingsOrganize => 'سازمان‌دهی';

  @override
  String get manageAccounts => 'حساب‌ها';

  @override
  String get newAccount => 'حساب جدید';

  @override
  String get editAccount => 'ویرایش حساب';

  @override
  String get openingBalance => 'موجودی اولیه';

  @override
  String get heroIncome => 'درآمد';

  @override
  String get heroSpent => 'خرج';

  @override
  String accountTransactions(String name) {
    return '$name';
  }

  @override
  String get totalBalance => 'مجموع موجودی';

  @override
  String get balanceNote => 'موجودی بانک‌ها از آخرین پیامک گرفته می‌شود.';

  @override
  String get manageCategories => 'دسته‌ها';

  @override
  String get manageTags => 'برچسب‌ها';

  @override
  String get noArchived => 'دستهٔ بایگانی‌شده‌ای نیست';

  @override
  String get subcategories => 'زیردسته‌ها';

  @override
  String get addSubcategory => 'افزودن زیردسته';

  @override
  String inUse(int count) {
    return '$count تراکنش';
  }

  @override
  String get delete_ => 'حذف';

  @override
  String get unmatchedHint =>
      'این پیامک‌ها مالی به نظر می‌رسند اما الگویی برایشان نیست. قالب را به دفتر یاد بدهید یا نادیده بگیرید.';

  @override
  String get unmatchedEmpty => 'پیامک ناشناخته‌ای نیست';

  @override
  String get ignoreSender => 'نادیده‌گرفتن این فرستنده';

  @override
  String get ignoreMessage => 'رد کردن';

  @override
  String get teachFormat => 'یاد دادن قالب';

  @override
  String get senderIgnored => 'فرستنده نادیده گرفته شد';

  @override
  String get settingsAbout => 'دربارهٔ برنامه';

  @override
  String get aboutText =>
      'دفتر همه‌چیز را فقط روی همین گوشی نگه می‌دارد. بدون حساب کاربری و بدون فضای ابری.';

  @override
  String get restored => 'بازیابی شد';

  @override
  String get reportsTitle => 'گزارش‌ها';

  @override
  String get periodMonth => 'ماه';

  @override
  String get periodRange => 'بازهٔ تاریخ';

  @override
  String get groupCategory => 'دسته';

  @override
  String get groupTag => 'برچسب';

  @override
  String get groupAccount => 'حساب';

  @override
  String get spentTotal => 'مجموع هزینه';

  @override
  String get earnedTotal => 'مجموع درآمد';

  @override
  String get otherSlice => 'سایر';

  @override
  String get trend12 => '۱۲ ماه اخیر';

  @override
  String vsLastMonth(String pct) {
    return '$pct٪ نسبت به ماه قبل';
  }

  @override
  String get tagsOverlap =>
      'تراکنشی که چند برچسب دارد برای هر کدام شمرده می‌شود.';

  @override
  String get noDataPeriod => 'در این بازه داده‌ای نیست';

  @override
  String get budgets => 'بودجه‌ها';

  @override
  String get leaks => 'نشتی‌ها';

  @override
  String get budgetsHint => 'برای هر دسته سقف ماهانه تعیین کنید.';

  @override
  String get newBudget => 'بودجهٔ جدید';

  @override
  String get editBudget => 'ویرایش بودجه';

  @override
  String get monthlyLimit => 'سقف ماهانه';

  @override
  String budgetSpent(String spent, String limit) {
    return '$spent از $limit';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount مانده';
  }

  @override
  String budgetOver(String amount) {
    return '$amount بیش از سقف';
  }

  @override
  String get noBudgets => 'هنوز بودجه‌ای نیست';

  @override
  String get removeBudget => 'حذف بودجه';

  @override
  String get pickCategoryFirst => 'یک دسته انتخاب کنید';

  @override
  String get leaksTitle => 'پول از کجا نشت می‌کند';

  @override
  String get leaksHint => 'الگوهایی که این ماه ارزش نگاه دوباره دارند.';

  @override
  String leakSpike(String name, String pct) {
    return '$name $pct٪ بیشتر از معمول است';
  }

  @override
  String leakSpikeDetail(String now, String avg) {
    return 'این ماه $now، معمولاً حدود $avg.';
  }

  @override
  String leakSmall(int count, String total) {
    return '$count خرید کوچک روی هم $total شد';
  }

  @override
  String leakSmallDetail(String limit) {
    return 'هر کدام کمتر از $limit. مبلغ‌های کوچک در شلوغی گم می‌شوند.';
  }

  @override
  String leakUncategorized(int count, String total) {
    return '$count تراکنش دسته ندارد ($total)';
  }

  @override
  String get leakUncategorizedDetail =>
      'تا دسته‌بندی نشوند، گزارش‌ها ناقص‌اند.';

  @override
  String leakGaps(int count) {
    return '$count جا که موجودی نمی‌خواند';
  }

  @override
  String leakGapsDetail(String total) {
    return '$total بدون پیامک متناظر جابه‌جا شده.';
  }

  @override
  String leakRecurring(int count) {
    return '$count پرداخت تکراری تأییدنشده';
  }

  @override
  String get leakRecurringDetail =>
      'برای پیگیری قبض‌های پیش‌رو آن‌ها را تأیید کنید.';

  @override
  String get leaksNone => 'نشتی‌ای پیدا نشد';

  @override
  String get leaksNoneHint => 'این ماه چیز غیرعادی نیست.';

  @override
  String get viewTransactions => 'دیدن تراکنش‌ها';

  @override
  String get smallLimit => 'سقف خرید کوچک';

  @override
  String get newPerson => 'فرد جدید';

  @override
  String get editPerson => 'ویرایش فرد';

  @override
  String get phone => 'تلفن (اختیاری)';

  @override
  String get noPeople => 'هنوز کسی نیست';

  @override
  String get noPeopleHint =>
      'افراد را اضافه کنید تا هزینه‌ها را تقسیم کنید و بدهی‌ها را ببینید.';

  @override
  String get owesYou => 'به شما بدهکار است';

  @override
  String get youOwe => 'شما بدهکارید';

  @override
  String get allSettled => 'تسویه است';

  @override
  String get owedToYou => 'طلب شما';

  @override
  String get owedByYou => 'بدهی شما';

  @override
  String get settleUp => 'تسویه';

  @override
  String get theyOweMe => 'بدهکار به من';

  @override
  String get iOweThem => 'من بدهکارم';

  @override
  String get ledger => 'تاریخچه';

  @override
  String get noLedger => 'هنوز سابقه‌ای نیست';

  @override
  String get sharedExpense => 'هزینهٔ مشترک';

  @override
  String get settlementEntry => 'تسویه';

  @override
  String get deleteEntry => 'حذف مورد';

  @override
  String get deletePerson => 'حذف فرد';

  @override
  String get personHasHistory =>
      'این فرد سابقه دارد و حذف نمی‌شود. به‌جای آن تسویه کنید.';

  @override
  String get splitWith => 'تقسیم با دیگران';

  @override
  String get editSplit => 'ویرایش تقسیم';

  @override
  String get splitEqual => 'مساوی';

  @override
  String get splitPercent => 'درصد';

  @override
  String get splitExact => 'مبلغ';

  @override
  String get myShare => 'سهم من';

  @override
  String get splitInvalid => 'جمع سهم‌ها از مبلغ کل بیشتر است.';

  @override
  String get pickPeople => 'حداقل یک نفر را انتخاب کنید';

  @override
  String get removeSplit => 'حذف تقسیم';

  @override
  String get linkDeposit => 'اتصال به واریزی دریافتی';

  @override
  String get noLink => 'بدون اتصال';

  @override
  String get linkedHint => 'واریزی متصل‌شده جزو درآمد حساب نمی‌شود.';

  @override
  String owesAmount(String name, String amount) {
    return '$name $amount بدهکار است';
  }

  @override
  String get phoneHint => 'تلفن';

  @override
  String get reminder => 'یادآوری';

  @override
  String notifCaptureTitle(String amount, String account) {
    return '$amount · $account';
  }

  @override
  String get notifCaptureBody => 'برای دسته‌بندی لمس کنید';

  @override
  String get notifActionCategorize => 'دسته‌بندی';

  @override
  String get notifActionNote => 'یادداشت';

  @override
  String get notifActionMark => 'نشان';

  @override
  String get notifNoteLabel => 'یادداشت شما';

  @override
  String notifBudgetWarn(String name, String pct) {
    return 'بودجهٔ $name به $pct٪ رسید';
  }

  @override
  String notifBudgetOver(String name) {
    return 'بودجهٔ $name تمام شد';
  }

  @override
  String notifBudgetBody(String spent, String limit) {
    return 'این ماه $spent از $limit خرج شده.';
  }

  @override
  String notifSummaryTitle(String month) {
    return 'خلاصهٔ $month';
  }

  @override
  String notifSummaryBody(String income, String spent, String net) {
    return 'درآمد $income · خرج $spent · خالص $net';
  }

  @override
  String notifSummaryTop(String list) {
    return 'بیشترین: $list';
  }

  @override
  String notifSummaryReview(int count) {
    return '$count مورد برای بررسی';
  }

  @override
  String get notifTransferTitle => 'احتمال انتقال بین حساب‌ها';

  @override
  String notifTransferBody(String amount, String from, String to) {
    return '$amount از $from به $to';
  }

  @override
  String notifRecurringTitle(String amount) {
    return '$amount به‌زودی سررسید است';
  }

  @override
  String notifLeakTitle(String name) {
    return '$name بالا رفته است';
  }

  @override
  String get inbox => 'اعلان‌ها';

  @override
  String get inboxEmpty => 'هنوز اعلانی نیست';

  @override
  String get markAllRead => 'همه خوانده شد';

  @override
  String get notifSettings => 'اعلان‌ها';

  @override
  String get notifTypeCapture => 'تراکنش جدید از پیامک';

  @override
  String get notifTypeBudget => 'هشدار بودجه';

  @override
  String get notifTypeLeak => 'هشدار نشتی';

  @override
  String get notifTypeSummary => 'خلاصهٔ ماهانه';

  @override
  String get notifTypeTransfer => 'انتقال‌های احتمالی';

  @override
  String get notifPermission => 'اجازهٔ اعلان';

  @override
  String get notifPermissionHint =>
      'برای نمایش تراکنش‌های جدید و یادآورها لازم است.';

  @override
  String get exactAlarmHint =>
      'برای رسیدن به‌موقع یادآورها، آلارم دقیق را مجاز کنید.';

  @override
  String get autoSync => 'ثبت زندهٔ پیامک';

  @override
  String get autoSyncHint =>
      'پیامک‌های بانکی جدید تا یک دقیقه بعد حتی با بستهٔ برنامه ثبت می‌شوند.';

  @override
  String get batteryHint =>
      'اگر ثبت متوقف شد، دفتر را از بهینه‌سازی باتری مستثنا کنید.';

  @override
  String get openBatterySettings => 'تنظیمات باتری';

  @override
  String get transferTitle => 'انتقال بین حساب‌های خودتان؟';

  @override
  String transferBody(String amount, String from, String to) {
    return '$amount: $from ← $to';
  }

  @override
  String get yesTransfer => 'بله، انتقال است';

  @override
  String get notTransfer => 'خیر';

  @override
  String get recurringTitle => 'پرداخت‌های تکراری';

  @override
  String get recurringEmpty => 'هنوز مورد تکراری‌ای نیست';

  @override
  String get recurringEmptyHint =>
      'دفتر پرداخت‌هایی را که هر ماه برمی‌گردند پیدا می‌کند.';

  @override
  String recurringEvery(int days) {
    return 'حدود هر $days روز';
  }

  @override
  String recurringNext(String date) {
    return 'بعدی: $date';
  }

  @override
  String get confirmRecurring => 'تأیید';

  @override
  String get dismissRecurring => 'تکراری نیست';

  @override
  String get upcoming => 'پیش‌رو';

  @override
  String get remindBefore => 'یادآوری یک روز قبل';

  @override
  String get reminderSet => 'یادآور تنظیم شد';

  @override
  String get reminderTitle => 'یادآوری';

  @override
  String get remindMe => 'یادآوری کن';

  @override
  String get reminders => 'یادآورها';

  @override
  String get pickReminderTime => 'تاریخ و ساعت را انتخاب کنید';

  @override
  String get reminderText => 'چه چیزی یادآوری شود';

  @override
  String get reminderInPast => 'زمانی در آینده انتخاب کنید';

  @override
  String get removeReminder => 'حذف';

  @override
  String get backupTitle => 'پشتیبان‌گیری و خروجی';

  @override
  String get backupCreate => 'ساخت پشتیبان رمزگذاری‌شده';

  @override
  String get backupCreateHint =>
      'یک فایل شامل همه‌چیز که با رمز قفل می‌شود. فقط خودتان می‌توانید بازش کنید.';

  @override
  String get backupRestore => 'بازیابی از پشتیبان';

  @override
  String get backupRestoreHint =>
      'همهٔ داده‌های این گوشی را با پشتیبان جایگزین می‌کند.';

  @override
  String get backupPassword => 'رمز پشتیبان';

  @override
  String get backupPasswordAgain => 'تکرار رمز';

  @override
  String get backupPasswordHint =>
      'آن را یادداشت کنید. بدون آن پشتیبان باز نمی‌شود.';

  @override
  String get passwordMismatch => 'رمزها یکسان نیستند';

  @override
  String get passwordShort => 'حداقل ۶ نویسه';

  @override
  String get backupWorking =>
      'در حال رمزگذاری… برای داده‌های حجیم ممکن است یک دقیقه طول بکشد.';

  @override
  String get backupSaved => 'پشتیبان ذخیره شد';

  @override
  String get backupSave => 'ذخیره در فایل‌ها';

  @override
  String get backupShare => 'اشتراک‌گذاری';

  @override
  String backupLast(String date) {
    return 'آخرین پشتیبان: $date';
  }

  @override
  String get backupNever => 'هنوز پشتیبانی گرفته نشده';

  @override
  String get backupNudge => 'از داده‌هایتان پشتیبان بگیرید';

  @override
  String get backupNudgeHint => 'مدتی از آخرین پشتیبان می‌گذرد.';

  @override
  String get restoreConfirm =>
      'همهٔ داده‌های این گوشی با این پشتیبان جایگزین شود؟ از داده‌های فعلی یک نسخهٔ ایمنی نگه داشته می‌شود.';

  @override
  String get restoreDone => 'پشتیبان بازیابی شد';

  @override
  String restoreFailed(String error) {
    return 'پشتیبان باز نشد: $error';
  }

  @override
  String get restoreWrongFile => 'این فایل پشتیبان دفتر نیست.';

  @override
  String get exportCsv => 'خروجی CSV';

  @override
  String get exportCsvHint => 'در اکسل یا گوگل‌شیت با متن فارسی باز می‌شود.';

  @override
  String get exportRange => 'بازهٔ تاریخ';

  @override
  String get exportAll => 'همهٔ زمان‌ها';

  @override
  String get exportThisMonth => 'این ماه';

  @override
  String get exportCustom => 'انتخاب تاریخ…';

  @override
  String exportDone(int count) {
    return '$count ردیف خروجی گرفته شد';
  }

  @override
  String get importCsv => 'ورود از CSV';

  @override
  String get importCsvHint =>
      'خروجی‌های دفتر، یا صورتحساب بانکی که خودتان ستون‌هایش را معرفی می‌کنید.';

  @override
  String get csvMapTitle => 'تطبیق ستون‌ها';

  @override
  String get csvColDate => 'تاریخ';

  @override
  String get csvColTime => 'ساعت (اختیاری)';

  @override
  String get csvColAmount => 'مبلغ';

  @override
  String get csvColNote => 'یادداشت (اختیاری)';

  @override
  String get csvColCategory => 'دسته (اختیاری)';

  @override
  String get csvColAccount => 'حساب (اختیاری)';

  @override
  String get csvColTags => 'برچسب‌ها (اختیاری)';

  @override
  String get csvNone => '— ندارد —';

  @override
  String get csvAccountDefault => 'حساب برای ردیف‌های بدون حساب';

  @override
  String get csvAmountUnit => 'مبالغ به';

  @override
  String get csvInvertSign => 'اعداد مثبت هزینه هستند';

  @override
  String get csvPreview => 'پیش‌نمایش';

  @override
  String csvImportRows(int count) {
    return 'ورود $count ردیف';
  }

  @override
  String csvImported(int added, int skipped) {
    return '$added اضافه شد، $skipped رد شد (تکراری یا ناخوانا)';
  }

  @override
  String get csvNeedDate => 'ستون تاریخ و مبلغ را انتخاب کنید';

  @override
  String get cliHint =>
      'روی کامپیوتر، ابزار خط فرمان daftar می‌تواند پشتیبان را بدون گوشی باز کند.';

  @override
  String get securityTitle => 'امنیت';

  @override
  String get lockEnable => 'قفل برنامه';

  @override
  String get lockEnableHint => 'هنگام باز کردن دفتر رمز می‌خواهد.';

  @override
  String get lockBiometric => 'استفاده از اثر انگشت یا چهره';

  @override
  String get lockTimeout => 'قفل پس از ترک برنامه';

  @override
  String get lockImmediately => 'بلافاصله';

  @override
  String get lockAfter1 => 'پس از ۱ دقیقه';

  @override
  String get lockAfter5 => 'پس از ۵ دقیقه';

  @override
  String get lockChangePin => 'تغییر رمز';

  @override
  String get lockSetPin => 'یک رمز انتخاب کنید';

  @override
  String get lockRepeatPin => 'رمز را تکرار کنید';

  @override
  String get lockEnterPin => 'رمز را وارد کنید';

  @override
  String get lockWrongPin => 'رمز اشتباه است';

  @override
  String get lockMismatch => 'رمزها یکسان نبود. دوباره امتحان کنید.';

  @override
  String lockTooMany(int seconds) {
    return 'تلاش‌های زیاد. $seconds ثانیه صبر کنید.';
  }

  @override
  String get lockBioReason => 'باز کردن دفتر';

  @override
  String get lockUseBio => 'استفاده از اثر انگشت';

  @override
  String get lockHideScreen =>
      'پنهان‌سازی در لیست برنامه‌ها و جلوگیری از اسکرین‌شات';

  @override
  String get lockDisable => 'خاموش کردن قفل';

  @override
  String get lockForgot =>
      'رمز را فراموش کردید؟ پس از نصب دوباره، پشتیبان را بازیابی کنید.';

  @override
  String get welcomeTitle => 'به دفتر خوش آمدید';

  @override
  String get welcomeHint =>
      'پول شما، فقط روی گوشی خودتان. چند کار کوتاه را انجام می‌دهیم.';

  @override
  String get welcomeSms => 'خواندن پیامک بانکی';

  @override
  String get welcomeSmsHint => 'تا تراکنش‌ها خودکار ثبت شوند.';

  @override
  String get welcomeNotif => 'نمایش اعلان‌ها';

  @override
  String get welcomeNotifHint => 'برای تراکنش جدید، بودجه و یادآورها.';

  @override
  String get welcomeLock => 'محافظت با رمز';

  @override
  String get welcomeLockHint => 'اختیاری است، بعداً هم از تنظیمات ممکن است.';

  @override
  String get welcomeStart => 'ادامه و ورود پیامک‌ها';

  @override
  String get welcomeDone => 'انجام شد';

  @override
  String get builderTitle => 'یاد دادن این پیامک به دفتر';

  @override
  String get builderHint =>
      'روی بخش‌های پیام لمس کنید: مبلغ، مانده، تاریخ، حساب. دفتر قالب این فرستنده را یاد می‌گیرد.';

  @override
  String get roleAmount => 'مبلغ';

  @override
  String get roleBalance => 'مانده';

  @override
  String get roleDate => 'تاریخ / ساعت';

  @override
  String get roleAccount => 'حساب';

  @override
  String get roleWord => 'کلمهٔ جهت';

  @override
  String get roleClear => 'پاک کردن';

  @override
  String get builderExpenseWord => 'کلمه‌ای که یعنی خروج پول (مثل برداشت)';

  @override
  String get builderPreview => 'آنچه دفتر می‌خواند';

  @override
  String get builderNoMatch => 'الگو هنوز با این پیام نمی‌خواند.';

  @override
  String get builderNeedAmount => 'مبلغ و علامت +/− یا کلمهٔ جهت را لمس کنید.';

  @override
  String builderMatches(int count) {
    return 'با $count پیام ناشناختهٔ دیگر از همین فرستنده هم می‌خواند.';
  }

  @override
  String get builderSave => 'ذخیره و ورود این پیام‌ها';

  @override
  String builderSaved(int added) {
    return 'ذخیره شد. $added تراکنش اضافه شد.';
  }

  @override
  String get builderAdvanced => 'ویرایش الگو (پیشرفته)';

  @override
  String get builderBank => 'بانک';

  @override
  String get builderOtherBank => 'دیگر / نامشخص';

  @override
  String get dataSafety => 'ایمنی داده‌ها';

  @override
  String get presetThisMonth => 'این ماه';

  @override
  String get presetLastMonth => 'ماه قبل';

  @override
  String get preset3Months => '۳ ماه اخیر';

  @override
  String get presetYear => 'امسال';

  @override
  String get importResultHint =>
      'برای بررسی تراکنش‌های پیداشده به فهرست تراکنش‌ها بروید.';

  @override
  String get accountKindBank => 'حساب بانکی';

  @override
  String get accountKindCash => 'نقد / کیف پول';

  @override
  String get accountBank => 'بانک';

  @override
  String get accountNumber => 'شمارهٔ حساب یا کارت';

  @override
  String get accountNumberHint =>
      'دقیقاً مثل پیامک بانک، تا پیامک‌های جدید به همین حساب بروند.';

  @override
  String get accountNumberTaken => 'حساب دیگری این شماره را دارد';

  @override
  String get archiveAccount => 'بایگانی حساب';

  @override
  String get archivedAccounts => 'حساب‌های بایگانی‌شده';

  @override
  String get typeTransfer => 'انتقال';

  @override
  String get transferFrom => 'از حساب';

  @override
  String get transferTo => 'به حساب';

  @override
  String get transferPick => 'دو حساب متفاوت انتخاب کنید';

  @override
  String get transferManualHint =>
      'انتقال بین دو حساب بانکی از روی پیامک‌ها خودکار تشخیص داده می‌شود. این گزینه برای نقد و حساب‌های بدون پیامک است.';

  @override
  String get accountBalanceNow => 'موجودی';

  @override
  String get themeTitle => 'نمای برنامه';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get kpiDailyAvg => 'میانگین روزانه';

  @override
  String get kpiTransactions => 'تراکنش‌ها';

  @override
  String get kpiLargest => 'بزرگ‌ترین هزینه';

  @override
  String get paceTitle => 'روند خرج در ماه';

  @override
  String get paceHint => 'جمع تجمعی خرج، روز به روز';

  @override
  String get paceThis => 'این ماه';

  @override
  String get paceLast => 'ماه قبل';

  @override
  String paceDay(String day) {
    return 'روز $day';
  }

  @override
  String get weekdayTitle => 'بر اساس روز هفته';

  @override
  String get topExpensesTitle => 'بزرگ‌ترین هزینه‌ها';

  @override
  String get uncatNudge =>
      'بیشتر این مبلغ دسته ندارد. دسته‌بندی کنید تا ببینید پول کجا می‌رود.';

  @override
  String get trendNet => 'خالص هر ماه';

  @override
  String get noExpensesPeriod => 'در این بازه هزینه‌ای نیست';

  @override
  String get balanceUpdate => 'اصلاح موجودی';

  @override
  String get balanceUpdateTitle => 'تنظیم موجودی فعلی';

  @override
  String get balanceSetHint =>
      'دفتر از همین مبلغ شروع می‌کند و تراکنش‌های بعدیِ بدون مانده را به آن اضافه می‌کند. مانده‌ٔ پیامک جدیدتر خودکار جایگزین آن می‌شود.';

  @override
  String get balanceAsOf => 'موجودی در تاریخ';

  @override
  String balanceFromSms(String when) {
    return 'از پیامک · $when';
  }

  @override
  String balanceSetByYou(String when) {
    return 'تنظیم‌شده توسط شما · $when';
  }

  @override
  String get balanceComputed => 'محاسبه از روی تراکنش‌ها';

  @override
  String get balanceClear => 'بازگشت به موجودی خودکار';

  @override
  String get balanceTotal => 'مجموع';

  @override
  String get balanceNegative => 'موجودی منفی است (اضافه‌برداشت)';

  @override
  String get catSplit => 'تقسیم بین دسته‌ها';

  @override
  String get editCatSplit => 'ویرایش تقسیم دسته‌ها';

  @override
  String get removeCatSplit => 'حذف تقسیم دسته‌ها';

  @override
  String catSplitCount(int n) {
    return 'تقسیم بین $n دسته';
  }

  @override
  String get addPart => 'افزودن دسته';

  @override
  String get partsLeft => 'مانده برای تخصیص';

  @override
  String get catSplitInvalid =>
      'حداقل دو دسته لازم است و جمع بخش‌ها باید برابر مبلغ کل باشد.';

  @override
  String get catSplitStale =>
      'مبلغ تغییر کرد. تقسیم دسته‌ها را دوباره انجام دهید.';
}
