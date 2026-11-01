# Daftar — Local-only Expense Tracker (Plan)

Working name: **Daftar** (دفتر, "ledger"). Android only, offline, single user.
Design system: [`design-system/daftar/MASTER.md`](../design-system/daftar/MASTER.md).

## 1. Goals

1. Capture income and expenses automatically from bank SMS, with Resalat first and most Iranian banks supported.
2. Make manual review fast: category, tags, note, mark and reminder for each transaction.
3. Scale to years of data (target: 1M transactions with no visible slowdown).
4. Track shared expenses and debts with people (Splitwise-style).
5. Report by Jalali month, category, tag, account and person, and surface spending leaks.
6. English UI by default, full Persian (RTL) translation, Jalali calendar everywhere.
7. Keep data on the device only: encrypted database, encrypted backup file, CSV export, and a desktop CLI that decrypts backups.

Non-goals (v1): cloud sync, iOS, investment/asset tracking, multi-currency, Play Store release.

## 2. Tech stack

| Concern | Choice |
|---|---|
| App | Flutter (stable), Material 3, Riverpod for state, go_router for navigation |
| Database | Drift on SQLCipher (`sqlcipher_flutter_libs`), running in a background isolate (`NativeDatabase.createInBackground`) |
| Search | SQLite FTS5 over note, raw SMS text and counterparty |
| SMS | A Kotlin method-channel plugin (in-repo) that queries `content://sms/inbox` by date range and runs a `SMS_RECEIVED` receiver |
| Background | `workmanager` for a periodic sync (every 15 minutes) and a one-off sync triggered by the SMS receiver |
| Notifications | `flutter_local_notifications` with action buttons and inline text reply, plus exact scheduled reminders that are rescheduled on boot |
| Dates | `shamsi_date` for logic, `persian_datetime_picker` for input |
| i18n | `flutter_localizations` with ARB files (en, fa) and `intl` number formatting |
| Icons | `phosphor_flutter`, with a full-set icon picker |
| Charts | `fl_chart` |
| Security | `local_auth` (fingerprint), a PIN fallback, and `flutter_secure_storage` to hold the DB key in the Android Keystore |
| Crypto | `cryptography` (AES-256-GCM, Argon2id), shared by the app and the CLI |
| Files | `file_picker` (save and open via SAF), `share_plus` |
| CLI | A pure Dart console app using the `sqlite3` package |

### Repo layout

```
app/                     Flutter app
  android/.../sms/       Kotlin SMS plugin (inbox query + receiver)
  lib/
    db/                  Drift schema, DAOs, migrations
    sms/                 importer/sync (calls core parser)
    features/<screen>/   UI per feature
    theme/               tokens, ThemeData light/dark
    l10n/                app_en.arb, app_fa.arb
packages/core/           Pure Dart: SMS normalizer + template engine, Jalali helpers,
                         money formatting, backup format (encrypt/decrypt), CSV writer
cli/                     `daftar` desktop tool: decrypt backup -> .sqlite / .csv
docs/
design-system/
```

Code that the CLI also needs lives in `packages/core`, so the backup format and the parser exist exactly once.

## 3. Money and dates

- Amounts are stored as **integer Rial** (`int`, 64-bit), never as floating point. Expenses are stored negative and income positive. The display setting chooses Rial or Toman (÷10).
- Time is stored as `occurred_at` (UTC epoch ms) plus a denormalized `jalali_ym` integer (e.g. `140508`), indexed, so monthly reports never compute dates per row.
- **Year inference:** bank SMS like Resalat's include `MM/DD` but no year. The year comes from the SMS received timestamp converted to Jalali. If the parsed month is later than the received month (e.g. an Esfand transaction received in Farvardin), the year is the received year minus 1.
- Reporting periods are Jalali months. The month switcher shows Jalali names, and the transaction detail screen also shows the Gregorian date.

## 4. Data model (Drift)

```
accounts        id, name, bank_id?, number (as in SMS, e.g. 10.11228735.1), kind(bank|cash),
                icon, color, opening_balance, archived, sort
banks           id, code (resalat, mellat, ...), name_en, name_fa, icon
sms_senders     id, address (e.g. +98..., "Resalat"), bank_id, ignored
sms_templates   id, bank_id?, sender_address?, pattern (regex, named groups), sample,
                builtin, enabled, priority, version
raw_sms         id, address, body, received_at, hash UNIQUE, status(parsed|unmatched|ignored|error),
                template_id?
transactions    id, account_id, amount (signed rial), occurred_at, jalali_ym, balance_after?,
                kind(expense|income|transfer), category_id?, note, marked, source(sms|manual|import),
                raw_sms_id?, transfer_group_id?, recurring_id?, balance_gap (bool),
                created_at, updated_at, deleted_at
categories      id, parent_id?, kind(expense|income), name, name_key? (for built-ins), icon, color,
                builtin, archived, sort
tags            id, name, icon, color, builtin
transaction_tags  transaction_id, tag_id  (PK both)
people          id, name, phone?, icon/avatar, color, note
splits          id, transaction_id, person_id, share (rial; positive = they owe me)
settlements     id, person_id, amount (positive = they paid me), occurred_at, note,
                transaction_id? (link to the SMS deposit that settled it)
budgets         id, category_id, monthly_limit, from_ym, to_ym?
recurring       id, account_id, signature (amount bucket + kind), period_days, expected_amount,
                next_due, category_id?, confirmed, dismissed
reminders       id, target_type(transaction|person|recurring), target_id, at, text, done
settings        key, value
```

Indexes: `transactions(occurred_at, id)`, `(account_id, occurred_at)`, `(jalali_ym, category_id)`, `(category_id)`, `(deleted_at)`. FTS5 table `tx_search(note, sms_body)`.

Deletes are soft (`deleted_at`), so undo works and restoring a backup never loses history. The trash is purged after 30 days.

## 5. SMS pipeline

Sync and range import share one code path: **the inbox is the source of truth**.

```
Kotlin: query inbox WHERE date BETWEEN a AND b (paged, 500 at a time)
  -> Dart: normalize -> dedupe (hash) -> store raw_sms
  -> match template (sender-specific first, then bank, then generic heuristic)
  -> build transaction -> reconcile balance -> pair transfers -> notify
```

- **Live capture:** the `SMS_RECEIVED` receiver only enqueues a one-off WorkManager sync, which then runs `sync(since: last_synced_at)`. A periodic 15-minute sync and a sync on app open cover anything the receiver misses (killed process, battery optimization). Nothing is lost, because the inbox is re-read.
- **Range import:** pick a start and end date on the Jalali picker and optionally choose senders. Progress is determinate and the import can be cancelled. Inserts are batched in transactions of 500.
- **Normalize:** convert Persian and Arabic digits to ASCII, `ي`→`ی`, `ك`→`ک`, the Arabic thousands separator `٬` and `،` to `,`, strip `U+200E`/`U+200F`/`U+202A–E`, trim each line, and collapse spaces.
- **Dedupe:** `hash = sha1(address + body + received_at)`. Re-importing the same range is a no-op.
- **Senders:** banks use several numbers. When a sender appears for the first time and an SMS from it matches a template, it is linked to that template's bank automatically. Otherwise the sender appears under "Unmatched SMS". The account is resolved from the account number in the SMS body, and a new account is created on first sight (the user confirms the name and icon).

### Template engine

A template is a regex with **named groups**. Recognised group names are `amount`, `sign`, `kind_word`, `balance`, `year`, `month`, `day`, `hour`, `minute`, `account`, `card` and `desc`. Only `amount` and some direction signal (`sign` or `kind_word`) are required.

Resalat, verified against your 3 samples:

```
^\s*(?<account>\d+(?:\.\d+)+)\s*\n
\s*(?<sign>[+-])(?<amount>[\d,]+)\s*\n
\s*(?<month>\d{1,2})/(?<day>\d{1,2})_(?<hour>\d{1,2}):(?<minute>\d{2})\s*\n
\s*مانده\s*:\s*(?<balance>-?[\d,]+)\s*$
```

`kind_word` maps keywords to a direction: `برداشت|خرید|انتقال از|کسر` → expense, `واریز|انتقال به|سود` → income.

- **Built-in set:** Resalat is shipped and verified. Templates for the other major banks (Melli, Mellat, Saderat, Tejarat, Sepah, Pasargad, Saman, Parsian, Keshavarzi, Maskan, Refah, Ayandeh, Eghtesad Novin, Shahr, Sina, Post Bank, Blu) ship as **"unverified"** until a real sample confirms them. Templates are data rows, so they can be updated without migrations.
- **Generic heuristic fallback:** this runs when no template matches. It looks for a signed amount or an amount next to a keyword (`مبلغ`, `برداشت`, `واریز`), a `مانده` balance and a date/time. Any result it produces is flagged *needs review*.
- **Template builder (in-app):** open an unmatched SMS, tap the tokens for amount, direction, balance, date, time and account, and the app generates the regex. You test it live against every unmatched SMS from that sender, then save. Advanced users can edit the regex directly.
- **Balance reconciliation:** for each account, `prev.balance_after + amount` should equal `balance_after`. If it doesn't, the transaction gets `balance_gap = true` and shows *"≈ X Rial unaccounted between these two SMS"*. This flags missed SMS, cash-free fees, or transactions on another channel, and it counts as a leak signal.
  - Your samples already show this: after 22,975,232, a +20,000,000 deposit should leave 42,975,232, but the SMS says 39,375,232 (3.6M unaccounted). The next SMS shows 825,063,832 where 36,875,232 was expected.
- **Transfer pairing:** opposite signs, equal amounts, two of your own accounts, within 10 minutes. The pair is proposed, you confirm, and confirmed pairs get `kind = transfer` and are excluded from income/expense totals.

## 6. Features

### Transactions
- A month-grouped list with sticky Jalali day headers and a fixed 64dp row. Rows show icon, category or "Uncategorized", tags, note preview, signed amount and balance.
- Filters: account, kind, category, tag, person, marked, has note, uncategorized, balance gap, amount range, date range. Full-text search covers notes and SMS text.
- Multi-select for bulk category, tag, mark or delete.
- Detail sheet: edit everything, view the raw SMS, split with people, add a reminder, and an "Exclude from reports" switch.
- Manual entry: amount keypad first, then category grid, account (Cash is the default for manual entries), date and note. It also includes a **Cash wallet** account.

### Review queue (core flow)
Your salary and other transactions don't land on fixed days, so categorization is manual, and it has to be fast:
- Cards show one uncategorized transaction at a time. Tap a category to apply it and the next card appears. You can add tags and a note inline, swipe to skip, and undo.
- "Same as last time" suggestion: if this account has seen the same amount before, that transaction's category is offered first. No auto-apply rules in v1.

### Categories, tags and icons
- Defaults, all editable, with one level of subcategories:
  - **Expense:** Groceries, Restaurants & Cafe, Transport (Taxi/Snapp, Fuel, Public), Housing (Rent, Repairs), Bills (Electricity, Water, Gas, Internet, Mobile), Health, Shopping, Clothing, Education, Entertainment, Subscriptions, Travel, Gifts, Family, Personal Care, Fees & Taxes, Installments (اقساط), Charity, Other.
  - **Income:** Salary, Freelance, Gift, Refund, Profit/Interest, Other.
- Default tags: essential, impulse, work, reimbursable, online, recurring, cash.
- Every category, tag, account and person gets a **custom Phosphor icon** (searchable picker covering the whole set, with weight) and a color from the palette.
- Archive instead of delete when something is in use. Merging two categories is supported.

### Notes, marks, reminders, notifications
- Any transaction can have a note (searchable) and a mark (star). There's a "Marked" filter and a Home card for marked items.
- Reminders on a transaction, person or recurring item use exact local alarms that work offline and survive reboots.
- Notifications:
  1. **New transaction captured:** "−1,900,000 · Resalat · 09:57". Actions: *Categorize* (opens the quick sheet), *Note* (inline reply), *Mark*.
  2. **Reminder** at its scheduled time.
  3. **Budget alert** at 80% and 100% of a category's monthly limit.
  4. **Leak alert** when a category is more than 50% above its 3-month average by mid-month, or a balance gap is detected.
  5. **Monthly summary** on the 1st of each Jalali month: income, expense, net, top 3 categories, and how many transactions are uncategorized.
- An in-app notification center lists all of the above with read/unread state.

### Shared money (Splitwise-style)
- Split any transaction among people equally, by percentage or by exact amounts. Your own share stays as the expense, and the rest becomes "owed to me".
- You can also record "I owe" (someone paid for you) without any bank SMS.
- People tab: net balance per person, a ledger of splits and settlements, and a *Settle up* button. A settlement can be linked to the incoming SMS deposit, so that deposit isn't counted as income.
- Reports count only **your share** as an expense.

### Budgets, recurring, leaks
- Monthly limit per category, with a progress bar on Home and in Reports. Leftover budget doesn't roll over (v1).
- **Recurring detection** runs nightly: same account, amount within ±5%, and 3 or more occurrences 25–35 days apart. These are proposed to you and, once confirmed, show as "Upcoming" with a reminder.
- **Leaks screen:** a category spiking against its average; many small expenses (count and total under a threshold you set); total uncategorized; balance gaps; and recurring charges you haven't confirmed.

### Reports
- Month overview: income, expense, net, savings rate, and comparison with the previous month and the 3-month average.
- Category donut plus a ranked list, with drill-down into subcategories and then transactions.
- A 12-month trend bar chart. Also by tag, account and person.
- Any date range can be selected, with a Jalali range picker.
- All aggregation runs in SQL (`GROUP BY jalali_ym, category_id`) over indexes. A summary cache table will be added only if measurements show it's needed.

### Security, backup, import/export
- The database is encrypted with SQLCipher, using a random key stored in the Android Keystore.
- App lock: a PIN plus optional fingerprint, with auto-lock after N minutes in the background. Screenshots are blocked (`FLAG_SECURE`) and can be allowed in settings.
- **Encrypted backup** (`.daftar`): the database is copied with `VACUUM INTO`, then encrypted with AES-256-GCM using a key derived from a backup password with Argon2id.
  - File layout: `magic "DAFTAR\x01" | kdf params | salt | nonce | ciphertext`.
  - Restoring replaces the database after confirmation and takes an automatic safety backup first.
  - Optional automatic weekly backup to a folder you choose.
- **CSV export:** any date range or filter, written as UTF-8 with a BOM so Excel shows Persian correctly. Columns: date_jalali, date_gregorian, time, account, kind, amount_rial, category, subcategory, tags, note, people, balance_after.
- **CSV import:** our own export format (round-trip) plus a simple column-mapping screen for other CSVs.
- **SMS import:** by Jalali date range (§5).
- **CLI** (`cli/`):
  - `daftar decrypt backup.daftar -o out.sqlite`
  - `daftar export backup.daftar --from 1405/01/01 --to 1405/06/31 -o out.csv`
  - The CLI prompts for the password and uses the same code as the app (`packages/core`).

### Languages
- English is the default, with full Persian translation and RTL. The language can be switched without restarting.
- Persian digits in fa, ASCII in en. Number and Jalali formatting go through `packages/core` formatters only.

## 7. Performance plan

- Lists use keyset pagination (`WHERE (occurred_at, id) < (?, ?) LIMIT 100`) with `ListView.builder` and a fixed `itemExtent`. The app never loads a whole month.
- All database work runs in the background isolate, and parsing during a large import runs in a separate isolate.
- A seed script generates 1M transactions spread over 10 years. Targets on a mid-range phone:
  - Month list first paint: under 150ms
  - Month report: under 300ms
  - 12-month trend: under 500ms
  - Importing 10k SMS: under 20s
- `EXPLAIN QUERY PLAN` is checked for every report query, and none of them may scan the whole table.

## 8. Screens

1. **Onboarding:** language, then permissions (SMS, notifications, exact alarms, ignore battery optimization, each with an explanation), set a PIN, choose the initial import range (default: the current Jalali month), import with progress, and confirm detected accounts.
2. **Home:** month switcher; total balance and per-account balances; income, expense and net; a "To review (N)" card; budgets; leaks; upcoming recurring items; marked items.
3. **Transactions:** list, filters, search and bulk actions.
4. **Transaction detail / edit sheet.**
5. **Review queue.**
6. **Add transaction** (from the FAB).
7. **Reports:** overview, categories, trend, tags, accounts and people.
8. **People** list and person detail ledger with settle up.
9. **Budgets.**
10. **Recurring.**
11. **Leaks.**
12. **Notification center.**
13. **Settings:**
    - Accounts
    - Banks & SMS senders
    - Templates and template builder
    - Unmatched SMS
    - Categories and tags
    - SMS import by range
    - Backup, restore, CSV export and CSV import
    - Security
    - Language
    - Currency display (Rial/Toman)
    - Theme
    - Notifications
    - Trash

## 9. Milestones

| # | Milestone | Done when |
|---|---|---|
| M0 | Skeleton: monorepo, Flutter app, theme tokens light/dark, Vazirmatn, Phosphor, ARB en/fa, RTL switch, Drift schema + migrations, `core` package | App boots in en/fa with an empty Home |
| M1 | SMS core: Kotlin plugin, normalizer, template engine, Resalat template, heuristic fallback, year inference, dedupe, balance reconciliation, range import with progress, accounts from SMS | Importing the current month's real Resalat SMS gives correct transactions, and the parser tests pass |
| M2 | Transactions: list with pagination, filters and search, detail sheet, manual entry, Cash wallet, categories and tags with defaults, icon picker, notes, marks, review queue, soft delete and undo | You can categorize a month in under 2 minutes |
| M3 | Reports and budgets: overview, categories, trend, tags, accounts, budgets, leaks screen | Monthly report is correct against a hand-checked month |
| M4 | People: splits, I-owe, balances, settle up linked to a deposit | Shared dinner and settle-up flow works end to end |
| M5 | Live and notifications: receiver plus WorkManager sync, capture notification with actions, reminders, budget and leak alerts, monthly summary, transfer pairing, recurring detection, notification center | A new bank SMS shows a notification within 1 minute while the app is killed |
| M6 | Security and data: SQLCipher, PIN and fingerprint lock, encrypted backup and restore, auto backup, CSV export and import, CLI | Backup → CLI decrypt → CSV matches in-app export |
| M7 | Polish: full fa translation pass, template builder, more bank templates from samples, 1M-row performance pass, release-signed APK | Performance targets in §7 are met |

## 10. Tests (minimal, where logic can break)

- `core`: parser tests against every real sample (Resalat now, other banks as samples arrive). Also normalizer cases (Persian digits, RTL marks), year inference across the Esfand→Farvardin boundary, balance-gap detection, transfer pairing, and split math (shares sum to the total, remainder goes to me).
- `core`: a backup encrypt/decrypt round-trip, plus a wrong password failing cleanly.
- App: a DAO test for keyset pagination and the monthly aggregates on a seeded database.

## 11. Decisions (2026-10-24)

1. **Other banks:** no samples for now. Their templates ship as "unverified" and get verified as real samples arrive.
2. **Icons:** Phosphor only. No custom SVG/PNG import.
3. **Name:** Daftar.
4. **Distribution:** personal use only, installed as a sideloaded APK, never published to Play.

Task breakdown: [`docs/TASKS.md`](TASKS.md).


## 12. What changed while building

- **Database encryption (SQLCipher) is not in v1.** The database lives in the app's private storage, the app can be PIN/fingerprint locked, and backups are AES-256 encrypted. SQLCipher would add a key that, if lost, loses all data, and it complicates backups. Add it only if you want protection on a rooted or stolen unlocked phone.
- **Weekly auto-backup became a reminder.** Android does not let an app write silently to a folder you pick, so Home nudges you after 14 days without a backup.
- **List paging** grows 100 rows at a time over the `(occurred_at, id)` index instead of true keyset paging. Measured with 1,000,000 rows: first page 5 ms, month totals 11 ms, 12-month trend 74 ms, full-text search over everything 260 ms (on a laptop; expect a few times slower on a phone).
- **Other banks** ship with the Resalat pattern verified and a generic keyword parser as fallback. Unknown formats go to Settings → Unmatched SMS → Teach format.
- **Release build** is signed with `app/android/daftar-release.jks` (password in `app/android/key.properties`, both git-ignored). Keep a copy: a different key cannot update an installed app.
