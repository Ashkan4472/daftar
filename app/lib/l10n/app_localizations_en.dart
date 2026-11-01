// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Daftar';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTransactions => 'Transactions';

  @override
  String get tabReports => 'Reports';

  @override
  String get tabPeople => 'People';

  @override
  String get add => 'Add';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get net => 'Net';

  @override
  String get balance => 'Balance';

  @override
  String get accounts => 'Accounts';

  @override
  String get rial => 'Rial';

  @override
  String get toman => 'Toman';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get showToman => 'Show amounts in Toman';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get prevMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get back => 'Back';

  @override
  String get importSms => 'Import SMS';

  @override
  String get importSmsTitle => 'Import SMS by date';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get startImport => 'Start import';

  @override
  String get cancel => 'Cancel';

  @override
  String importProgress(int done, int total) {
    return '$done / $total SMS';
  }

  @override
  String importDone(int added, int unmatched) {
    return 'Imported $added transactions, $unmatched unmatched SMS';
  }

  @override
  String get smsPermissionDenied =>
      'SMS permission is needed to read bank messages.';

  @override
  String get importHint =>
      'Pick the dates to scan. Already imported messages are skipped, so you can safely repeat this.';

  @override
  String get importFirstTitle => 'Bring in your bank SMS';

  @override
  String get importFirstHint =>
      'Daftar reads your bank messages on this phone and turns them into transactions. Nothing leaves your device.';

  @override
  String get unmatchedSms => 'Unmatched SMS';

  @override
  String get netThisMonth => 'Net this month';

  @override
  String savingsRate(String pct) {
    return 'Saved $pct%';
  }

  @override
  String get toReview => 'To review';

  @override
  String toReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions need a category',
      one: '1 transaction needs a category',
      zero: 'Nothing to review',
    );
    return '$_temp0';
  }

  @override
  String get reviewNow => 'Review';

  @override
  String get recent => 'Recent';

  @override
  String get seeAll => 'See all';

  @override
  String get noTransactions => 'No transactions here';

  @override
  String get noTransactionsHint => 'Import your bank SMS or add one by hand.';

  @override
  String get noResults => 'Nothing matches';

  @override
  String get noResultsHint => 'Try different words or clear the filters.';

  @override
  String get search => 'Search notes and SMS';

  @override
  String get filterAll => 'All';

  @override
  String get filterExpense => 'Expenses';

  @override
  String get filterIncome => 'Income';

  @override
  String get filterToReview => 'To review';

  @override
  String get filterMarked => 'Marked';

  @override
  String get filterGap => 'Balance gaps';

  @override
  String get moreFilters => 'More filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get allMonths => 'All months';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get applyFilters => 'Show results';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get category => 'Category';

  @override
  String get categories => 'Categories';

  @override
  String get tags => 'Tags';

  @override
  String get tag => 'Tag';

  @override
  String get expenseCategories => 'Expense';

  @override
  String get incomeCategories => 'Income';

  @override
  String allOf(String name) {
    return 'All $name';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get newTag => 'New tag';

  @override
  String get editTag => 'Edit tag';

  @override
  String get parentCategory => 'Parent category';

  @override
  String get noParent => 'None (top level)';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Enter a name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get chooseIcon => 'Choose icon';

  @override
  String get searchIcons => 'Search icons (e.g. food, car)';

  @override
  String get iconWeight => 'Style';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Restore from archive';

  @override
  String get archived => 'Archived';

  @override
  String get mergeInto => 'Merge into…';

  @override
  String mergeConfirm(String name) {
    return 'Move all transactions to “$name” and archive this category?';
  }

  @override
  String get merge => 'Merge';

  @override
  String get deleteTagConfirm => 'Delete this tag from all transactions?';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get typeExpense => 'Expense';

  @override
  String get typeIncome => 'Income';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Enter an amount';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get account => 'Account';

  @override
  String get note => 'Note';

  @override
  String get addNote => 'Add a note';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get movedToTrash => 'Moved to trash';

  @override
  String get mark => 'Mark';

  @override
  String get unmark => 'Remove mark';

  @override
  String get excludeFromReports => 'Exclude from reports';

  @override
  String get excludeHint =>
      'Use for transfers or money that is not really yours.';

  @override
  String get originalSms => 'Original SMS';

  @override
  String get balanceAfter => 'Balance after';

  @override
  String get sourceSms => 'From SMS';

  @override
  String get sourceManual => 'Added by hand';

  @override
  String get sourceImport => 'Imported';

  @override
  String get gapTitle => 'Balance does not add up';

  @override
  String gapExplain(String amount) {
    return '$amount is unaccounted for since the previous SMS. A message may be missing, or money moved in another way.';
  }

  @override
  String get needsReviewHint => 'Read by a generic rule. Check the amount.';

  @override
  String get trash => 'Trash';

  @override
  String get trashEmpty => 'Trash is empty';

  @override
  String get trashHint => 'Items are removed for good after 30 days.';

  @override
  String get restore => 'Restore';

  @override
  String get transfer => 'Transfer';

  @override
  String get reviewTitle => 'Review';

  @override
  String reviewProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String get reviewDone => 'All caught up';

  @override
  String get reviewDoneHint => 'Every transaction has a category.';

  @override
  String get skip => 'Skip';

  @override
  String get previous => 'Previous';

  @override
  String get sameAsLast => 'Same as last time';

  @override
  String get pickCategory => 'Pick a category';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsOrganize => 'Organize';

  @override
  String get manageAccounts => 'Accounts';

  @override
  String get newAccount => 'New account';

  @override
  String get editAccount => 'Edit account';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get heroIncome => 'Income';

  @override
  String get heroSpent => 'Spent';

  @override
  String accountTransactions(String name) {
    return '$name';
  }

  @override
  String get totalBalance => 'Total balance';

  @override
  String get balanceNote => 'Bank balances come from your latest SMS.';

  @override
  String get manageCategories => 'Categories';

  @override
  String get manageTags => 'Tags';

  @override
  String get noArchived => 'No archived categories';

  @override
  String get subcategories => 'Subcategories';

  @override
  String get addSubcategory => 'Add subcategory';

  @override
  String inUse(int count) {
    return '$count transactions';
  }

  @override
  String get delete_ => 'Delete';

  @override
  String get unmatchedHint =>
      'These messages look financial but no pattern fits. Teach Daftar the format, or ignore them.';

  @override
  String get unmatchedEmpty => 'Nothing unmatched';

  @override
  String get ignoreSender => 'Ignore this sender';

  @override
  String get ignoreMessage => 'Dismiss';

  @override
  String get teachFormat => 'Teach format';

  @override
  String get senderIgnored => 'Sender ignored';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutText =>
      'Daftar keeps everything on this phone. No account, no cloud.';

  @override
  String get restored => 'Restored';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodRange => 'Date range';

  @override
  String get groupCategory => 'Category';

  @override
  String get groupTag => 'Tag';

  @override
  String get groupAccount => 'Account';

  @override
  String get spentTotal => 'Total spent';

  @override
  String get earnedTotal => 'Total income';

  @override
  String get otherSlice => 'Other';

  @override
  String get trend12 => 'Last 12 months';

  @override
  String vsLastMonth(String pct) {
    return '$pct% vs last month';
  }

  @override
  String get tagsOverlap =>
      'A transaction with several tags counts under each of them.';

  @override
  String get noDataPeriod => 'No data in this period';

  @override
  String get budgets => 'Budgets';

  @override
  String get leaks => 'Leaks';

  @override
  String get budgetsHint => 'Set a monthly limit per category.';

  @override
  String get newBudget => 'New budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get monthlyLimit => 'Monthly limit';

  @override
  String budgetSpent(String spent, String limit) {
    return '$spent of $limit';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String budgetOver(String amount) {
    return '$amount over';
  }

  @override
  String get noBudgets => 'No budgets yet';

  @override
  String get removeBudget => 'Remove budget';

  @override
  String get pickCategoryFirst => 'Choose a category';

  @override
  String get leaksTitle => 'Where money leaks';

  @override
  String get leaksHint => 'Patterns worth a second look this month.';

  @override
  String leakSpike(String name, String pct) {
    return '$name is $pct% above your usual';
  }

  @override
  String leakSpikeDetail(String now, String avg) {
    return '$now this month, usually about $avg.';
  }

  @override
  String leakSmall(int count, String total) {
    return '$count small purchases added up to $total';
  }

  @override
  String leakSmallDetail(String limit) {
    return 'Each one under $limit. Small amounts hide in the noise.';
  }

  @override
  String leakUncategorized(int count, String total) {
    return '$count transactions have no category ($total)';
  }

  @override
  String get leakUncategorizedDetail =>
      'Reports are incomplete until they are categorized.';

  @override
  String leakGaps(int count) {
    return '$count places where the balance does not add up';
  }

  @override
  String leakGapsDetail(String total) {
    return '$total moved without a matching SMS.';
  }

  @override
  String leakRecurring(int count) {
    return '$count repeating charges not confirmed';
  }

  @override
  String get leakRecurringDetail => 'Confirm them to track upcoming bills.';

  @override
  String get leaksNone => 'No leaks found';

  @override
  String get leaksNoneHint => 'Nothing unusual this month.';

  @override
  String get viewTransactions => 'View transactions';

  @override
  String get smallLimit => 'Small purchase limit';

  @override
  String get newPerson => 'New person';

  @override
  String get editPerson => 'Edit person';

  @override
  String get phone => 'Phone (optional)';

  @override
  String get noPeople => 'No one yet';

  @override
  String get noPeopleHint =>
      'Add people to split costs and track who owes whom.';

  @override
  String get owesYou => 'owes you';

  @override
  String get youOwe => 'you owe';

  @override
  String get allSettled => 'All settled';

  @override
  String get owedToYou => 'Owed to you';

  @override
  String get owedByYou => 'You owe';

  @override
  String get settleUp => 'Settle up';

  @override
  String get theyOweMe => 'They owe me';

  @override
  String get iOweThem => 'I owe them';

  @override
  String get ledger => 'History';

  @override
  String get noLedger => 'No history yet';

  @override
  String get sharedExpense => 'Shared expense';

  @override
  String get settlementEntry => 'Settlement';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deletePerson => 'Delete person';

  @override
  String get personHasHistory =>
      'This person has history, so they cannot be deleted. Settle up instead.';

  @override
  String get splitWith => 'Split with people';

  @override
  String get editSplit => 'Edit split';

  @override
  String get splitEqual => 'Equal';

  @override
  String get splitPercent => 'Percent';

  @override
  String get splitExact => 'Amounts';

  @override
  String get myShare => 'My share';

  @override
  String get splitInvalid => 'The shares add up to more than the total.';

  @override
  String get pickPeople => 'Choose at least one person';

  @override
  String get removeSplit => 'Remove split';

  @override
  String get linkDeposit => 'Link to the deposit you received';

  @override
  String get noLink => 'Not linked';

  @override
  String get linkedHint => 'A linked deposit is left out of income.';

  @override
  String owesAmount(String name, String amount) {
    return '$name owes $amount';
  }

  @override
  String get phoneHint => 'Phone';

  @override
  String get reminder => 'Remind me';

  @override
  String notifCaptureTitle(String amount, String account) {
    return '$amount · $account';
  }

  @override
  String get notifCaptureBody => 'Tap to categorize';

  @override
  String get notifActionCategorize => 'Categorize';

  @override
  String get notifActionNote => 'Note';

  @override
  String get notifActionMark => 'Mark';

  @override
  String get notifNoteLabel => 'Your note';

  @override
  String notifBudgetWarn(String name, String pct) {
    return '$name budget is at $pct%';
  }

  @override
  String notifBudgetOver(String name) {
    return '$name budget exceeded';
  }

  @override
  String notifBudgetBody(String spent, String limit) {
    return '$spent of $limit spent this month.';
  }

  @override
  String notifSummaryTitle(String month) {
    return '$month summary';
  }

  @override
  String notifSummaryBody(String income, String spent, String net) {
    return 'Income $income · Spent $spent · Net $net';
  }

  @override
  String notifSummaryTop(String list) {
    return 'Top: $list';
  }

  @override
  String notifSummaryReview(int count) {
    return '$count to review';
  }

  @override
  String get notifTransferTitle => 'Possible transfer';

  @override
  String notifTransferBody(String amount, String from, String to) {
    return '$amount from $from to $to';
  }

  @override
  String notifRecurringTitle(String amount) {
    return '$amount due soon';
  }

  @override
  String notifLeakTitle(String name) {
    return '$name is spiking';
  }

  @override
  String get inbox => 'Notifications';

  @override
  String get inboxEmpty => 'No notifications yet';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notifSettings => 'Notifications';

  @override
  String get notifTypeCapture => 'New transaction from SMS';

  @override
  String get notifTypeBudget => 'Budget alerts';

  @override
  String get notifTypeLeak => 'Leak alerts';

  @override
  String get notifTypeSummary => 'Monthly summary';

  @override
  String get notifTypeTransfer => 'Possible transfers';

  @override
  String get notifPermission => 'Allow notifications';

  @override
  String get notifPermissionHint =>
      'Needed to show new transactions and reminders.';

  @override
  String get exactAlarmHint =>
      'Allow exact alarms so reminders arrive on time.';

  @override
  String get autoSync => 'Live SMS capture';

  @override
  String get autoSyncHint =>
      'New bank SMS become transactions within a minute, even when the app is closed.';

  @override
  String get batteryHint =>
      'If captures stop, exclude Daftar from battery optimization.';

  @override
  String get openBatterySettings => 'Battery settings';

  @override
  String get transferTitle => 'Transfer between your accounts?';

  @override
  String transferBody(String amount, String from, String to) {
    return '$amount: $from → $to';
  }

  @override
  String get yesTransfer => 'Yes, transfer';

  @override
  String get notTransfer => 'No';

  @override
  String get recurringTitle => 'Repeating charges';

  @override
  String get recurringEmpty => 'Nothing repeating yet';

  @override
  String get recurringEmptyHint =>
      'Daftar spots charges that come back every month.';

  @override
  String recurringEvery(int days) {
    return 'about every $days days';
  }

  @override
  String recurringNext(String date) {
    return 'Next: $date';
  }

  @override
  String get confirmRecurring => 'Confirm';

  @override
  String get dismissRecurring => 'Not repeating';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get remindBefore => 'Remind 1 day before';

  @override
  String get reminderSet => 'Reminder set';

  @override
  String get reminderTitle => 'Reminder';

  @override
  String get remindMe => 'Remind me';

  @override
  String get reminders => 'Reminders';

  @override
  String get pickReminderTime => 'Pick date and time';

  @override
  String get reminderText => 'What to remember';

  @override
  String get reminderInPast => 'Pick a time in the future';

  @override
  String get removeReminder => 'Remove';

  @override
  String get backupTitle => 'Backup & export';

  @override
  String get backupCreate => 'Create encrypted backup';

  @override
  String get backupCreateHint =>
      'One file with everything, locked with a password. Only you can open it.';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupRestoreHint =>
      'Replaces everything on this phone with the backup.';

  @override
  String get backupPassword => 'Backup password';

  @override
  String get backupPasswordAgain => 'Repeat password';

  @override
  String get backupPasswordHint =>
      'Write it down. Without it the backup cannot be opened.';

  @override
  String get passwordMismatch => 'The passwords do not match';

  @override
  String get passwordShort => 'Use at least 6 characters';

  @override
  String get backupWorking =>
      'Encrypting… this can take a minute for big data.';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get backupSave => 'Save to files';

  @override
  String get backupShare => 'Share';

  @override
  String backupLast(String date) {
    return 'Last backup: $date';
  }

  @override
  String get backupNever => 'No backup yet';

  @override
  String get backupNudge => 'Back up your data';

  @override
  String get backupNudgeHint => 'It has been a while since your last backup.';

  @override
  String get restoreConfirm =>
      'Replace all data on this phone with this backup? A safety copy of the current data is kept.';

  @override
  String get restoreDone => 'Backup restored';

  @override
  String restoreFailed(String error) {
    return 'Could not open the backup: $error';
  }

  @override
  String get restoreWrongFile => 'That file is not a Daftar backup.';

  @override
  String get exportCsv => 'Export to CSV';

  @override
  String get exportCsvHint =>
      'Opens in Excel or Google Sheets, Persian text included.';

  @override
  String get exportRange => 'Date range';

  @override
  String get exportAll => 'All time';

  @override
  String get exportThisMonth => 'This month';

  @override
  String get exportCustom => 'Pick dates…';

  @override
  String exportDone(int count) {
    return '$count rows exported';
  }

  @override
  String get importCsv => 'Import from CSV';

  @override
  String get importCsvHint =>
      'Daftar exports, or a bank statement you mapped yourself.';

  @override
  String get csvMapTitle => 'Match columns';

  @override
  String get csvColDate => 'Date';

  @override
  String get csvColTime => 'Time (optional)';

  @override
  String get csvColAmount => 'Amount';

  @override
  String get csvColNote => 'Note (optional)';

  @override
  String get csvColCategory => 'Category (optional)';

  @override
  String get csvColAccount => 'Account (optional)';

  @override
  String get csvColTags => 'Tags (optional)';

  @override
  String get csvNone => '— none —';

  @override
  String get csvAccountDefault => 'Account for rows without one';

  @override
  String get csvAmountUnit => 'Amounts are in';

  @override
  String get csvInvertSign => 'Positive numbers are expenses';

  @override
  String get csvPreview => 'Preview';

  @override
  String csvImportRows(int count) {
    return 'Import $count rows';
  }

  @override
  String csvImported(int added, int skipped) {
    return '$added added, $skipped skipped (duplicates or unreadable)';
  }

  @override
  String get csvNeedDate => 'Choose the date and amount columns';

  @override
  String get cliHint =>
      'On a computer, the daftar command-line tool can open a backup without the phone.';

  @override
  String get securityTitle => 'Security';

  @override
  String get lockEnable => 'Lock the app';

  @override
  String get lockEnableHint => 'Ask for a PIN when you open Daftar.';

  @override
  String get lockBiometric => 'Use fingerprint or face';

  @override
  String get lockTimeout => 'Lock after leaving the app';

  @override
  String get lockImmediately => 'Immediately';

  @override
  String get lockAfter1 => 'After 1 minute';

  @override
  String get lockAfter5 => 'After 5 minutes';

  @override
  String get lockChangePin => 'Change PIN';

  @override
  String get lockSetPin => 'Choose a PIN';

  @override
  String get lockRepeatPin => 'Repeat the PIN';

  @override
  String get lockEnterPin => 'Enter your PIN';

  @override
  String get lockWrongPin => 'Wrong PIN';

  @override
  String get lockMismatch => 'PINs did not match. Try again.';

  @override
  String lockTooMany(int seconds) {
    return 'Too many attempts. Wait $seconds seconds.';
  }

  @override
  String get lockBioReason => 'Unlock Daftar';

  @override
  String get lockUseBio => 'Use fingerprint';

  @override
  String get lockHideScreen => 'Hide in app switcher, block screenshots';

  @override
  String get lockDisable => 'Turn off lock';

  @override
  String get lockForgot =>
      'Forgot your PIN? Restore a backup after reinstalling.';

  @override
  String get welcomeTitle => 'Welcome to Daftar';

  @override
  String get welcomeHint =>
      'Your money, on your phone only. Let us set up three things.';

  @override
  String get welcomeSms => 'Read bank SMS';

  @override
  String get welcomeSmsHint => 'So transactions appear by themselves.';

  @override
  String get welcomeNotif => 'Show notifications';

  @override
  String get welcomeNotifHint => 'For new transactions, budgets and reminders.';

  @override
  String get welcomeLock => 'Protect with a PIN';

  @override
  String get welcomeLockHint => 'Optional, you can do it later in Settings.';

  @override
  String get welcomeStart => 'Continue to import';

  @override
  String get welcomeDone => 'Done';

  @override
  String get builderTitle => 'Teach Daftar this SMS';

  @override
  String get builderHint =>
      'Tap the parts of the message: the amount, the balance, the date, the account. Daftar will learn the format for this sender.';

  @override
  String get roleAmount => 'Amount';

  @override
  String get roleBalance => 'Balance';

  @override
  String get roleDate => 'Date / time';

  @override
  String get roleAccount => 'Account';

  @override
  String get roleWord => 'Direction word';

  @override
  String get roleClear => 'Clear';

  @override
  String get builderExpenseWord => 'Word that means money out (e.g. برداشت)';

  @override
  String get builderPreview => 'What Daftar reads';

  @override
  String get builderNoMatch => 'The pattern does not match this message yet.';

  @override
  String get builderNeedAmount =>
      'Tap the amount, and a +/− sign or a direction word.';

  @override
  String builderMatches(int count) {
    return 'Also fits $count other unmatched messages from this sender.';
  }

  @override
  String get builderSave => 'Save and import these';

  @override
  String builderSaved(int added) {
    return 'Saved. $added transactions added.';
  }

  @override
  String get builderAdvanced => 'Edit pattern (advanced)';

  @override
  String get builderBank => 'Bank';

  @override
  String get builderOtherBank => 'Other / unknown';

  @override
  String get dataSafety => 'Data safety';

  @override
  String get presetThisMonth => 'This month';

  @override
  String get presetLastMonth => 'Last month';

  @override
  String get preset3Months => 'Last 3 months';

  @override
  String get presetYear => 'This year';

  @override
  String get importResultHint => 'Open Transactions to review what was found.';

  @override
  String get accountKindBank => 'Bank account';

  @override
  String get accountKindCash => 'Cash / wallet';

  @override
  String get accountBank => 'Bank';

  @override
  String get accountNumber => 'Account or card number';

  @override
  String get accountNumberHint =>
      'Exactly as it appears in the bank SMS, so new messages land here.';

  @override
  String get accountNumberTaken => 'Another account already uses this number';

  @override
  String get archiveAccount => 'Archive account';

  @override
  String get archivedAccounts => 'Archived accounts';

  @override
  String get typeTransfer => 'Transfer';

  @override
  String get transferFrom => 'From account';

  @override
  String get transferTo => 'To account';

  @override
  String get transferPick => 'Pick two different accounts';

  @override
  String get transferManualHint =>
      'Bank-to-bank moves are paired from SMS automatically. Use this for cash and accounts without SMS.';

  @override
  String get accountBalanceNow => 'Balance';

  @override
  String get themeTitle => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get kpiDailyAvg => 'Daily average';

  @override
  String get kpiTransactions => 'Transactions';

  @override
  String get kpiLargest => 'Largest expense';

  @override
  String get paceTitle => 'Spending pace';

  @override
  String get paceHint => 'Running total of spending, day by day';

  @override
  String get paceThis => 'This month';

  @override
  String get paceLast => 'Last month';

  @override
  String paceDay(String day) {
    return 'Day $day';
  }

  @override
  String get weekdayTitle => 'By day of the week';

  @override
  String get topExpensesTitle => 'Biggest expenses';

  @override
  String get uncatNudge =>
      'Most of this is uncategorized. Categorize it to see where the money goes.';

  @override
  String get trendNet => 'Net per month';

  @override
  String get noExpensesPeriod => 'No expenses in this period';

  @override
  String get balanceUpdate => 'Update balance';

  @override
  String get balanceUpdateTitle => 'Set current balance';

  @override
  String get balanceSetHint =>
      'Daftar starts from this amount and adds later transactions that have no balance of their own. A newer SMS balance replaces it automatically.';

  @override
  String get balanceAsOf => 'Balance as of';

  @override
  String balanceFromSms(String when) {
    return 'From SMS · $when';
  }

  @override
  String balanceSetByYou(String when) {
    return 'Set by you · $when';
  }

  @override
  String get balanceComputed => 'Calculated from transactions';

  @override
  String get balanceClear => 'Use automatic balance again';

  @override
  String get balanceTotal => 'Total';

  @override
  String get balanceNegative => 'Balance is negative (overdraft)';
}
