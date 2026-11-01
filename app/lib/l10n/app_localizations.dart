import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Daftar'**
  String get appName;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get tabTransactions;

  /// No description provided for @tabReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get tabReports;

  /// No description provided for @tabPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get tabPeople;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @rial.
  ///
  /// In en, this message translates to:
  /// **'Rial'**
  String get rial;

  /// No description provided for @toman.
  ///
  /// In en, this message translates to:
  /// **'Toman'**
  String get toman;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @showToman.
  ///
  /// In en, this message translates to:
  /// **'Show amounts in Toman'**
  String get showToman;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @prevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get prevMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @importSms.
  ///
  /// In en, this message translates to:
  /// **'Import SMS'**
  String get importSms;

  /// No description provided for @importSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Import SMS by date'**
  String get importSmsTitle;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @startImport.
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get startImport;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @importProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} SMS'**
  String importProgress(int done, int total);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {added} transactions, {unmatched} unmatched SMS'**
  String importDone(int added, int unmatched);

  /// No description provided for @smsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'SMS permission is needed to read bank messages.'**
  String get smsPermissionDenied;

  /// No description provided for @importHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the dates to scan. Already imported messages are skipped, so you can safely repeat this.'**
  String get importHint;

  /// No description provided for @importFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring in your bank SMS'**
  String get importFirstTitle;

  /// No description provided for @importFirstHint.
  ///
  /// In en, this message translates to:
  /// **'Daftar reads your bank messages on this phone and turns them into transactions. Nothing leaves your device.'**
  String get importFirstHint;

  /// No description provided for @unmatchedSms.
  ///
  /// In en, this message translates to:
  /// **'Unmatched SMS'**
  String get unmatchedSms;

  /// No description provided for @netThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Net this month'**
  String get netThisMonth;

  /// No description provided for @savingsRate.
  ///
  /// In en, this message translates to:
  /// **'Saved {pct}%'**
  String savingsRate(String pct);

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get toReview;

  /// No description provided for @toReviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to review} =1{1 transaction needs a category} other{{count} transactions need a category}}'**
  String toReviewCount(int count);

  /// No description provided for @reviewNow.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewNow;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions here'**
  String get noTransactions;

  /// No description provided for @noTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Import your bank SMS or add one by hand.'**
  String get noTransactionsHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches'**
  String get noResults;

  /// No description provided for @noResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try different words or clear the filters.'**
  String get noResultsHint;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search notes and SMS'**
  String get search;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get filterExpense;

  /// No description provided for @filterIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get filterIncome;

  /// No description provided for @filterToReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get filterToReview;

  /// No description provided for @filterMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked'**
  String get filterMarked;

  /// No description provided for @filterGap.
  ///
  /// In en, this message translates to:
  /// **'Balance gaps'**
  String get filterGap;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More filters'**
  String get moreFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @allMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get allMonths;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get applyFilters;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @expenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseCategories;

  /// No description provided for @incomeCategories.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeCategories;

  /// No description provided for @allOf.
  ///
  /// In en, this message translates to:
  /// **'All {name}'**
  String allOf(String name);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @editTag.
  ///
  /// In en, this message translates to:
  /// **'Edit tag'**
  String get editTag;

  /// No description provided for @parentCategory.
  ///
  /// In en, this message translates to:
  /// **'Parent category'**
  String get parentCategory;

  /// No description provided for @noParent.
  ///
  /// In en, this message translates to:
  /// **'None (top level)'**
  String get noParent;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get nameRequired;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose icon'**
  String get chooseIcon;

  /// No description provided for @searchIcons.
  ///
  /// In en, this message translates to:
  /// **'Search icons (e.g. food, car)'**
  String get searchIcons;

  /// No description provided for @iconWeight.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get iconWeight;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Restore from archive'**
  String get unarchive;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @mergeInto.
  ///
  /// In en, this message translates to:
  /// **'Merge into…'**
  String get mergeInto;

  /// No description provided for @mergeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Move all transactions to “{name}” and archive this category?'**
  String mergeConfirm(String name);

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @deleteTagConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this tag from all transactions?'**
  String get deleteTagConfirm;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @typeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get typeExpense;

  /// No description provided for @typeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get typeIncome;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get amountRequired;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addNote;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @movedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get movedToTrash;

  /// No description provided for @mark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get mark;

  /// No description provided for @unmark.
  ///
  /// In en, this message translates to:
  /// **'Remove mark'**
  String get unmark;

  /// No description provided for @excludeFromReports.
  ///
  /// In en, this message translates to:
  /// **'Exclude from reports'**
  String get excludeFromReports;

  /// No description provided for @excludeHint.
  ///
  /// In en, this message translates to:
  /// **'Use for transfers or money that is not really yours.'**
  String get excludeHint;

  /// No description provided for @originalSms.
  ///
  /// In en, this message translates to:
  /// **'Original SMS'**
  String get originalSms;

  /// No description provided for @balanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after'**
  String get balanceAfter;

  /// No description provided for @sourceSms.
  ///
  /// In en, this message translates to:
  /// **'From SMS'**
  String get sourceSms;

  /// No description provided for @sourceManual.
  ///
  /// In en, this message translates to:
  /// **'Added by hand'**
  String get sourceManual;

  /// No description provided for @sourceImport.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get sourceImport;

  /// No description provided for @gapTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance does not add up'**
  String get gapTitle;

  /// No description provided for @gapExplain.
  ///
  /// In en, this message translates to:
  /// **'{amount} is unaccounted for since the previous SMS. A message may be missing, or money moved in another way.'**
  String gapExplain(String amount);

  /// No description provided for @needsReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Read by a generic rule. Check the amount.'**
  String get needsReviewHint;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty'**
  String get trashEmpty;

  /// No description provided for @trashHint.
  ///
  /// In en, this message translates to:
  /// **'Items are removed for good after 30 days.'**
  String get trashHint;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @reviewProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String reviewProgress(int done, int total);

  /// No description provided for @reviewDone.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get reviewDone;

  /// No description provided for @reviewDoneHint.
  ///
  /// In en, this message translates to:
  /// **'Every transaction has a category.'**
  String get reviewDoneHint;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @sameAsLast.
  ///
  /// In en, this message translates to:
  /// **'Same as last time'**
  String get sameAsLast;

  /// No description provided for @pickCategory.
  ///
  /// In en, this message translates to:
  /// **'Pick a category'**
  String get pickCategory;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsOrganize.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get settingsOrganize;

  /// No description provided for @manageAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get manageAccounts;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @heroIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get heroIncome;

  /// No description provided for @heroSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get heroSpent;

  /// No description provided for @accountTransactions.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String accountTransactions(String name);

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @balanceNote.
  ///
  /// In en, this message translates to:
  /// **'Bank balances come from your latest SMS.'**
  String get balanceNote;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get manageCategories;

  /// No description provided for @manageTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get manageTags;

  /// No description provided for @noArchived.
  ///
  /// In en, this message translates to:
  /// **'No archived categories'**
  String get noArchived;

  /// No description provided for @subcategories.
  ///
  /// In en, this message translates to:
  /// **'Subcategories'**
  String get subcategories;

  /// No description provided for @addSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add subcategory'**
  String get addSubcategory;

  /// No description provided for @inUse.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String inUse(int count);

  /// No description provided for @delete_.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_;

  /// No description provided for @unmatchedHint.
  ///
  /// In en, this message translates to:
  /// **'These messages look financial but no pattern fits. Teach Daftar the format, or ignore them.'**
  String get unmatchedHint;

  /// No description provided for @unmatchedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing unmatched'**
  String get unmatchedEmpty;

  /// No description provided for @ignoreSender.
  ///
  /// In en, this message translates to:
  /// **'Ignore this sender'**
  String get ignoreSender;

  /// No description provided for @ignoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get ignoreMessage;

  /// No description provided for @teachFormat.
  ///
  /// In en, this message translates to:
  /// **'Teach format'**
  String get teachFormat;

  /// No description provided for @senderIgnored.
  ///
  /// In en, this message translates to:
  /// **'Sender ignored'**
  String get senderIgnored;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Daftar keeps everything on this phone. No account, no cloud.'**
  String get aboutText;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get periodRange;

  /// No description provided for @groupCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get groupCategory;

  /// No description provided for @groupTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get groupTag;

  /// No description provided for @groupAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get groupAccount;

  /// No description provided for @spentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get spentTotal;

  /// No description provided for @earnedTotal.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get earnedTotal;

  /// No description provided for @otherSlice.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherSlice;

  /// No description provided for @trend12.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get trend12;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{pct}% vs last month'**
  String vsLastMonth(String pct);

  /// No description provided for @tagsOverlap.
  ///
  /// In en, this message translates to:
  /// **'A transaction with several tags counts under each of them.'**
  String get tagsOverlap;

  /// No description provided for @noDataPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data in this period'**
  String get noDataPeriod;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @leaks.
  ///
  /// In en, this message translates to:
  /// **'Leaks'**
  String get leaks;

  /// No description provided for @budgetsHint.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly limit per category.'**
  String get budgetsHint;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get newBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @monthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get monthlyLimit;

  /// No description provided for @budgetSpent.
  ///
  /// In en, this message translates to:
  /// **'{spent} of {limit}'**
  String budgetSpent(String spent, String limit);

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(String amount);

  /// No description provided for @budgetOver.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String budgetOver(String amount);

  /// No description provided for @noBudgets.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get noBudgets;

  /// No description provided for @removeBudget.
  ///
  /// In en, this message translates to:
  /// **'Remove budget'**
  String get removeBudget;

  /// No description provided for @pickCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get pickCategoryFirst;

  /// No description provided for @leaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Where money leaks'**
  String get leaksTitle;

  /// No description provided for @leaksHint.
  ///
  /// In en, this message translates to:
  /// **'Patterns worth a second look this month.'**
  String get leaksHint;

  /// No description provided for @leakSpike.
  ///
  /// In en, this message translates to:
  /// **'{name} is {pct}% above your usual'**
  String leakSpike(String name, String pct);

  /// No description provided for @leakSpikeDetail.
  ///
  /// In en, this message translates to:
  /// **'{now} this month, usually about {avg}.'**
  String leakSpikeDetail(String now, String avg);

  /// No description provided for @leakSmall.
  ///
  /// In en, this message translates to:
  /// **'{count} small purchases added up to {total}'**
  String leakSmall(int count, String total);

  /// No description provided for @leakSmallDetail.
  ///
  /// In en, this message translates to:
  /// **'Each one under {limit}. Small amounts hide in the noise.'**
  String leakSmallDetail(String limit);

  /// No description provided for @leakUncategorized.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions have no category ({total})'**
  String leakUncategorized(int count, String total);

  /// No description provided for @leakUncategorizedDetail.
  ///
  /// In en, this message translates to:
  /// **'Reports are incomplete until they are categorized.'**
  String get leakUncategorizedDetail;

  /// No description provided for @leakGaps.
  ///
  /// In en, this message translates to:
  /// **'{count} places where the balance does not add up'**
  String leakGaps(int count);

  /// No description provided for @leakGapsDetail.
  ///
  /// In en, this message translates to:
  /// **'{total} moved without a matching SMS.'**
  String leakGapsDetail(String total);

  /// No description provided for @leakRecurring.
  ///
  /// In en, this message translates to:
  /// **'{count} repeating charges not confirmed'**
  String leakRecurring(int count);

  /// No description provided for @leakRecurringDetail.
  ///
  /// In en, this message translates to:
  /// **'Confirm them to track upcoming bills.'**
  String get leakRecurringDetail;

  /// No description provided for @leaksNone.
  ///
  /// In en, this message translates to:
  /// **'No leaks found'**
  String get leaksNone;

  /// No description provided for @leaksNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Nothing unusual this month.'**
  String get leaksNoneHint;

  /// No description provided for @viewTransactions.
  ///
  /// In en, this message translates to:
  /// **'View transactions'**
  String get viewTransactions;

  /// No description provided for @smallLimit.
  ///
  /// In en, this message translates to:
  /// **'Small purchase limit'**
  String get smallLimit;

  /// No description provided for @newPerson.
  ///
  /// In en, this message translates to:
  /// **'New person'**
  String get newPerson;

  /// No description provided for @editPerson.
  ///
  /// In en, this message translates to:
  /// **'Edit person'**
  String get editPerson;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phone;

  /// No description provided for @noPeople.
  ///
  /// In en, this message translates to:
  /// **'No one yet'**
  String get noPeople;

  /// No description provided for @noPeopleHint.
  ///
  /// In en, this message translates to:
  /// **'Add people to split costs and track who owes whom.'**
  String get noPeopleHint;

  /// No description provided for @owesYou.
  ///
  /// In en, this message translates to:
  /// **'owes you'**
  String get owesYou;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'you owe'**
  String get youOwe;

  /// No description provided for @allSettled.
  ///
  /// In en, this message translates to:
  /// **'All settled'**
  String get allSettled;

  /// No description provided for @owedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to you'**
  String get owedToYou;

  /// No description provided for @owedByYou.
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get owedByYou;

  /// No description provided for @settleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get settleUp;

  /// No description provided for @theyOweMe.
  ///
  /// In en, this message translates to:
  /// **'They owe me'**
  String get theyOweMe;

  /// No description provided for @iOweThem.
  ///
  /// In en, this message translates to:
  /// **'I owe them'**
  String get iOweThem;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get ledger;

  /// No description provided for @noLedger.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noLedger;

  /// No description provided for @sharedExpense.
  ///
  /// In en, this message translates to:
  /// **'Shared expense'**
  String get sharedExpense;

  /// No description provided for @settlementEntry.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get settlementEntry;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// No description provided for @deletePerson.
  ///
  /// In en, this message translates to:
  /// **'Delete person'**
  String get deletePerson;

  /// No description provided for @personHasHistory.
  ///
  /// In en, this message translates to:
  /// **'This person has history, so they cannot be deleted. Settle up instead.'**
  String get personHasHistory;

  /// No description provided for @splitWith.
  ///
  /// In en, this message translates to:
  /// **'Split with people'**
  String get splitWith;

  /// No description provided for @editSplit.
  ///
  /// In en, this message translates to:
  /// **'Edit split'**
  String get editSplit;

  /// No description provided for @splitEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get splitEqual;

  /// No description provided for @splitPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get splitPercent;

  /// No description provided for @splitExact.
  ///
  /// In en, this message translates to:
  /// **'Amounts'**
  String get splitExact;

  /// No description provided for @myShare.
  ///
  /// In en, this message translates to:
  /// **'My share'**
  String get myShare;

  /// No description provided for @splitInvalid.
  ///
  /// In en, this message translates to:
  /// **'The shares add up to more than the total.'**
  String get splitInvalid;

  /// No description provided for @pickPeople.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one person'**
  String get pickPeople;

  /// No description provided for @removeSplit.
  ///
  /// In en, this message translates to:
  /// **'Remove split'**
  String get removeSplit;

  /// No description provided for @linkDeposit.
  ///
  /// In en, this message translates to:
  /// **'Link to the deposit you received'**
  String get linkDeposit;

  /// No description provided for @noLink.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get noLink;

  /// No description provided for @linkedHint.
  ///
  /// In en, this message translates to:
  /// **'A linked deposit is left out of income.'**
  String get linkedHint;

  /// No description provided for @owesAmount.
  ///
  /// In en, this message translates to:
  /// **'{name} owes {amount}'**
  String owesAmount(String name, String amount);

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneHint;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get reminder;

  /// No description provided for @notifCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'{amount} · {account}'**
  String notifCaptureTitle(String amount, String account);

  /// No description provided for @notifCaptureBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to categorize'**
  String get notifCaptureBody;

  /// No description provided for @notifActionCategorize.
  ///
  /// In en, this message translates to:
  /// **'Categorize'**
  String get notifActionCategorize;

  /// No description provided for @notifActionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get notifActionNote;

  /// No description provided for @notifActionMark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get notifActionMark;

  /// No description provided for @notifNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Your note'**
  String get notifNoteLabel;

  /// No description provided for @notifBudgetWarn.
  ///
  /// In en, this message translates to:
  /// **'{name} budget is at {pct}%'**
  String notifBudgetWarn(String name, String pct);

  /// No description provided for @notifBudgetOver.
  ///
  /// In en, this message translates to:
  /// **'{name} budget exceeded'**
  String notifBudgetOver(String name);

  /// No description provided for @notifBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'{spent} of {limit} spent this month.'**
  String notifBudgetBody(String spent, String limit);

  /// No description provided for @notifSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} summary'**
  String notifSummaryTitle(String month);

  /// No description provided for @notifSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'Income {income} · Spent {spent} · Net {net}'**
  String notifSummaryBody(String income, String spent, String net);

  /// No description provided for @notifSummaryTop.
  ///
  /// In en, this message translates to:
  /// **'Top: {list}'**
  String notifSummaryTop(String list);

  /// No description provided for @notifSummaryReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String notifSummaryReview(int count);

  /// No description provided for @notifTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible transfer'**
  String get notifTransferTitle;

  /// No description provided for @notifTransferBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} from {from} to {to}'**
  String notifTransferBody(String amount, String from, String to);

  /// No description provided for @notifRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'{amount} due soon'**
  String notifRecurringTitle(String amount);

  /// No description provided for @notifLeakTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is spiking'**
  String notifLeakTitle(String name);

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get inbox;

  /// No description provided for @inboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get inboxEmpty;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @notifSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifSettings;

  /// No description provided for @notifTypeCapture.
  ///
  /// In en, this message translates to:
  /// **'New transaction from SMS'**
  String get notifTypeCapture;

  /// No description provided for @notifTypeBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget alerts'**
  String get notifTypeBudget;

  /// No description provided for @notifTypeLeak.
  ///
  /// In en, this message translates to:
  /// **'Leak alerts'**
  String get notifTypeLeak;

  /// No description provided for @notifTypeSummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get notifTypeSummary;

  /// No description provided for @notifTypeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Possible transfers'**
  String get notifTypeTransfer;

  /// No description provided for @notifPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notifPermission;

  /// No description provided for @notifPermissionHint.
  ///
  /// In en, this message translates to:
  /// **'Needed to show new transactions and reminders.'**
  String get notifPermissionHint;

  /// No description provided for @exactAlarmHint.
  ///
  /// In en, this message translates to:
  /// **'Allow exact alarms so reminders arrive on time.'**
  String get exactAlarmHint;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Live SMS capture'**
  String get autoSync;

  /// No description provided for @autoSyncHint.
  ///
  /// In en, this message translates to:
  /// **'New bank SMS become transactions within a minute, even when the app is closed.'**
  String get autoSyncHint;

  /// No description provided for @batteryHint.
  ///
  /// In en, this message translates to:
  /// **'If captures stop, exclude Daftar from battery optimization.'**
  String get batteryHint;

  /// No description provided for @openBatterySettings.
  ///
  /// In en, this message translates to:
  /// **'Battery settings'**
  String get openBatterySettings;

  /// No description provided for @transferTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer between your accounts?'**
  String get transferTitle;

  /// No description provided for @transferBody.
  ///
  /// In en, this message translates to:
  /// **'{amount}: {from} → {to}'**
  String transferBody(String amount, String from, String to);

  /// No description provided for @yesTransfer.
  ///
  /// In en, this message translates to:
  /// **'Yes, transfer'**
  String get yesTransfer;

  /// No description provided for @notTransfer.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get notTransfer;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeating charges'**
  String get recurringTitle;

  /// No description provided for @recurringEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing repeating yet'**
  String get recurringEmpty;

  /// No description provided for @recurringEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Daftar spots charges that come back every month.'**
  String get recurringEmptyHint;

  /// No description provided for @recurringEvery.
  ///
  /// In en, this message translates to:
  /// **'about every {days} days'**
  String recurringEvery(int days);

  /// No description provided for @recurringNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String recurringNext(String date);

  /// No description provided for @confirmRecurring.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmRecurring;

  /// No description provided for @dismissRecurring.
  ///
  /// In en, this message translates to:
  /// **'Not repeating'**
  String get dismissRecurring;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @remindBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind 1 day before'**
  String get remindBefore;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSet;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderTitle;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @pickReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Pick date and time'**
  String get pickReminderTime;

  /// No description provided for @reminderText.
  ///
  /// In en, this message translates to:
  /// **'What to remember'**
  String get reminderText;

  /// No description provided for @reminderInPast.
  ///
  /// In en, this message translates to:
  /// **'Pick a time in the future'**
  String get reminderInPast;

  /// No description provided for @removeReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeReminder;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & export'**
  String get backupTitle;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create encrypted backup'**
  String get backupCreate;

  /// No description provided for @backupCreateHint.
  ///
  /// In en, this message translates to:
  /// **'One file with everything, locked with a password. Only you can open it.'**
  String get backupCreateHint;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything on this phone with the backup.'**
  String get backupRestoreHint;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPassword;

  /// No description provided for @backupPasswordAgain.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get backupPasswordAgain;

  /// No description provided for @backupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Write it down. Without it the backup cannot be opened.'**
  String get backupPasswordHint;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get passwordShort;

  /// No description provided for @backupWorking.
  ///
  /// In en, this message translates to:
  /// **'Encrypting… this can take a minute for big data.'**
  String get backupWorking;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupSaved;

  /// No description provided for @backupSave.
  ///
  /// In en, this message translates to:
  /// **'Save to files'**
  String get backupSave;

  /// No description provided for @backupShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get backupShare;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String backupLast(String date);

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get backupNever;

  /// No description provided for @backupNudge.
  ///
  /// In en, this message translates to:
  /// **'Back up your data'**
  String get backupNudge;

  /// No description provided for @backupNudgeHint.
  ///
  /// In en, this message translates to:
  /// **'It has been a while since your last backup.'**
  String get backupNudgeHint;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace all data on this phone with this backup? A safety copy of the current data is kept.'**
  String get restoreConfirm;

  /// No description provided for @restoreDone.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get restoreDone;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the backup: {error}'**
  String restoreFailed(String error);

  /// No description provided for @restoreWrongFile.
  ///
  /// In en, this message translates to:
  /// **'That file is not a Daftar backup.'**
  String get restoreWrongFile;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV'**
  String get exportCsv;

  /// No description provided for @exportCsvHint.
  ///
  /// In en, this message translates to:
  /// **'Opens in Excel or Google Sheets, Persian text included.'**
  String get exportCsvHint;

  /// No description provided for @exportRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get exportRange;

  /// No description provided for @exportAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get exportAll;

  /// No description provided for @exportThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get exportThisMonth;

  /// No description provided for @exportCustom.
  ///
  /// In en, this message translates to:
  /// **'Pick dates…'**
  String get exportCustom;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'{count} rows exported'**
  String exportDone(int count);

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV'**
  String get importCsv;

  /// No description provided for @importCsvHint.
  ///
  /// In en, this message translates to:
  /// **'Daftar exports, or a bank statement you mapped yourself.'**
  String get importCsvHint;

  /// No description provided for @csvMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Match columns'**
  String get csvMapTitle;

  /// No description provided for @csvColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get csvColDate;

  /// No description provided for @csvColTime.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get csvColTime;

  /// No description provided for @csvColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get csvColAmount;

  /// No description provided for @csvColNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get csvColNote;

  /// No description provided for @csvColCategory.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get csvColCategory;

  /// No description provided for @csvColAccount.
  ///
  /// In en, this message translates to:
  /// **'Account (optional)'**
  String get csvColAccount;

  /// No description provided for @csvColTags.
  ///
  /// In en, this message translates to:
  /// **'Tags (optional)'**
  String get csvColTags;

  /// No description provided for @csvNone.
  ///
  /// In en, this message translates to:
  /// **'— none —'**
  String get csvNone;

  /// No description provided for @csvAccountDefault.
  ///
  /// In en, this message translates to:
  /// **'Account for rows without one'**
  String get csvAccountDefault;

  /// No description provided for @csvAmountUnit.
  ///
  /// In en, this message translates to:
  /// **'Amounts are in'**
  String get csvAmountUnit;

  /// No description provided for @csvInvertSign.
  ///
  /// In en, this message translates to:
  /// **'Positive numbers are expenses'**
  String get csvInvertSign;

  /// No description provided for @csvPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get csvPreview;

  /// No description provided for @csvImportRows.
  ///
  /// In en, this message translates to:
  /// **'Import {count} rows'**
  String csvImportRows(int count);

  /// No description provided for @csvImported.
  ///
  /// In en, this message translates to:
  /// **'{added} added, {skipped} skipped (duplicates or unreadable)'**
  String csvImported(int added, int skipped);

  /// No description provided for @csvNeedDate.
  ///
  /// In en, this message translates to:
  /// **'Choose the date and amount columns'**
  String get csvNeedDate;

  /// No description provided for @cliHint.
  ///
  /// In en, this message translates to:
  /// **'On a computer, the daftar command-line tool can open a backup without the phone.'**
  String get cliHint;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @lockEnable.
  ///
  /// In en, this message translates to:
  /// **'Lock the app'**
  String get lockEnable;

  /// No description provided for @lockEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN when you open Daftar.'**
  String get lockEnableHint;

  /// No description provided for @lockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face'**
  String get lockBiometric;

  /// No description provided for @lockTimeout.
  ///
  /// In en, this message translates to:
  /// **'Lock after leaving the app'**
  String get lockTimeout;

  /// No description provided for @lockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// No description provided for @lockAfter1.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get lockAfter1;

  /// No description provided for @lockAfter5.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get lockAfter5;

  /// No description provided for @lockChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get lockChangePin;

  /// No description provided for @lockSetPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get lockSetPin;

  /// No description provided for @lockRepeatPin.
  ///
  /// In en, this message translates to:
  /// **'Repeat the PIN'**
  String get lockRepeatPin;

  /// No description provided for @lockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockEnterPin;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get lockWrongPin;

  /// No description provided for @lockMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs did not match. Try again.'**
  String get lockMismatch;

  /// No description provided for @lockTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait {seconds} seconds.'**
  String lockTooMany(int seconds);

  /// No description provided for @lockBioReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Daftar'**
  String get lockBioReason;

  /// No description provided for @lockUseBio.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint'**
  String get lockUseBio;

  /// No description provided for @lockHideScreen.
  ///
  /// In en, this message translates to:
  /// **'Hide in app switcher, block screenshots'**
  String get lockHideScreen;

  /// No description provided for @lockDisable.
  ///
  /// In en, this message translates to:
  /// **'Turn off lock'**
  String get lockDisable;

  /// No description provided for @lockForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN? Restore a backup after reinstalling.'**
  String get lockForgot;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Daftar'**
  String get welcomeTitle;

  /// No description provided for @welcomeHint.
  ///
  /// In en, this message translates to:
  /// **'Your money, on your phone only. Let us set up three things.'**
  String get welcomeHint;

  /// No description provided for @welcomeSms.
  ///
  /// In en, this message translates to:
  /// **'Read bank SMS'**
  String get welcomeSms;

  /// No description provided for @welcomeSmsHint.
  ///
  /// In en, this message translates to:
  /// **'So transactions appear by themselves.'**
  String get welcomeSmsHint;

  /// No description provided for @welcomeNotif.
  ///
  /// In en, this message translates to:
  /// **'Show notifications'**
  String get welcomeNotif;

  /// No description provided for @welcomeNotifHint.
  ///
  /// In en, this message translates to:
  /// **'For new transactions, budgets and reminders.'**
  String get welcomeNotifHint;

  /// No description provided for @welcomeLock.
  ///
  /// In en, this message translates to:
  /// **'Protect with a PIN'**
  String get welcomeLock;

  /// No description provided for @welcomeLockHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, you can do it later in Settings.'**
  String get welcomeLockHint;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Continue to import'**
  String get welcomeStart;

  /// No description provided for @welcomeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get welcomeDone;

  /// No description provided for @builderTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach Daftar this SMS'**
  String get builderTitle;

  /// No description provided for @builderHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the parts of the message: the amount, the balance, the date, the account. Daftar will learn the format for this sender.'**
  String get builderHint;

  /// No description provided for @roleAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get roleAmount;

  /// No description provided for @roleBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get roleBalance;

  /// No description provided for @roleDate.
  ///
  /// In en, this message translates to:
  /// **'Date / time'**
  String get roleDate;

  /// No description provided for @roleAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get roleAccount;

  /// No description provided for @roleWord.
  ///
  /// In en, this message translates to:
  /// **'Direction word'**
  String get roleWord;

  /// No description provided for @roleClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get roleClear;

  /// No description provided for @builderExpenseWord.
  ///
  /// In en, this message translates to:
  /// **'Word that means money out (e.g. برداشت)'**
  String get builderExpenseWord;

  /// No description provided for @builderPreview.
  ///
  /// In en, this message translates to:
  /// **'What Daftar reads'**
  String get builderPreview;

  /// No description provided for @builderNoMatch.
  ///
  /// In en, this message translates to:
  /// **'The pattern does not match this message yet.'**
  String get builderNoMatch;

  /// No description provided for @builderNeedAmount.
  ///
  /// In en, this message translates to:
  /// **'Tap the amount, and a +/− sign or a direction word.'**
  String get builderNeedAmount;

  /// No description provided for @builderMatches.
  ///
  /// In en, this message translates to:
  /// **'Also fits {count} other unmatched messages from this sender.'**
  String builderMatches(int count);

  /// No description provided for @builderSave.
  ///
  /// In en, this message translates to:
  /// **'Save and import these'**
  String get builderSave;

  /// No description provided for @builderSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. {added} transactions added.'**
  String builderSaved(int added);

  /// No description provided for @builderAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Edit pattern (advanced)'**
  String get builderAdvanced;

  /// No description provided for @builderBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get builderBank;

  /// No description provided for @builderOtherBank.
  ///
  /// In en, this message translates to:
  /// **'Other / unknown'**
  String get builderOtherBank;

  /// No description provided for @dataSafety.
  ///
  /// In en, this message translates to:
  /// **'Data safety'**
  String get dataSafety;

  /// No description provided for @presetThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get presetThisMonth;

  /// No description provided for @presetLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get presetLastMonth;

  /// No description provided for @preset3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get preset3Months;

  /// No description provided for @presetYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get presetYear;

  /// No description provided for @importResultHint.
  ///
  /// In en, this message translates to:
  /// **'Open Transactions to review what was found.'**
  String get importResultHint;

  /// No description provided for @accountKindBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get accountKindBank;

  /// No description provided for @accountKindCash.
  ///
  /// In en, this message translates to:
  /// **'Cash / wallet'**
  String get accountKindCash;

  /// No description provided for @accountBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountBank;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account or card number'**
  String get accountNumber;

  /// No description provided for @accountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Exactly as it appears in the bank SMS, so new messages land here.'**
  String get accountNumberHint;

  /// No description provided for @accountNumberTaken.
  ///
  /// In en, this message translates to:
  /// **'Another account already uses this number'**
  String get accountNumberTaken;

  /// No description provided for @archiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Archive account'**
  String get archiveAccount;

  /// No description provided for @archivedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Archived accounts'**
  String get archivedAccounts;

  /// No description provided for @typeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get typeTransfer;

  /// No description provided for @transferFrom.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get transferFrom;

  /// No description provided for @transferTo.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get transferTo;

  /// No description provided for @transferPick.
  ///
  /// In en, this message translates to:
  /// **'Pick two different accounts'**
  String get transferPick;

  /// No description provided for @transferManualHint.
  ///
  /// In en, this message translates to:
  /// **'Bank-to-bank moves are paired from SMS automatically. Use this for cash and accounts without SMS.'**
  String get transferManualHint;

  /// No description provided for @accountBalanceNow.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get accountBalanceNow;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @kpiDailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily average'**
  String get kpiDailyAvg;

  /// No description provided for @kpiTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get kpiTransactions;

  /// No description provided for @kpiLargest.
  ///
  /// In en, this message translates to:
  /// **'Largest expense'**
  String get kpiLargest;

  /// No description provided for @paceTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending pace'**
  String get paceTitle;

  /// No description provided for @paceHint.
  ///
  /// In en, this message translates to:
  /// **'Running total of spending, day by day'**
  String get paceHint;

  /// No description provided for @paceThis.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get paceThis;

  /// No description provided for @paceLast.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get paceLast;

  /// No description provided for @paceDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String paceDay(String day);

  /// No description provided for @weekdayTitle.
  ///
  /// In en, this message translates to:
  /// **'By day of the week'**
  String get weekdayTitle;

  /// No description provided for @topExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Biggest expenses'**
  String get topExpensesTitle;

  /// No description provided for @uncatNudge.
  ///
  /// In en, this message translates to:
  /// **'Most of this is uncategorized. Categorize it to see where the money goes.'**
  String get uncatNudge;

  /// No description provided for @trendNet.
  ///
  /// In en, this message translates to:
  /// **'Net per month'**
  String get trendNet;

  /// No description provided for @noExpensesPeriod.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this period'**
  String get noExpensesPeriod;

  /// No description provided for @balanceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update balance'**
  String get balanceUpdate;

  /// No description provided for @balanceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Set current balance'**
  String get balanceUpdateTitle;

  /// No description provided for @balanceSetHint.
  ///
  /// In en, this message translates to:
  /// **'Daftar starts from this amount and adds later transactions that have no balance of their own. A newer SMS balance replaces it automatically.'**
  String get balanceSetHint;

  /// No description provided for @balanceAsOf.
  ///
  /// In en, this message translates to:
  /// **'Balance as of'**
  String get balanceAsOf;

  /// No description provided for @balanceFromSms.
  ///
  /// In en, this message translates to:
  /// **'From SMS · {when}'**
  String balanceFromSms(String when);

  /// No description provided for @balanceSetByYou.
  ///
  /// In en, this message translates to:
  /// **'Set by you · {when}'**
  String balanceSetByYou(String when);

  /// No description provided for @balanceComputed.
  ///
  /// In en, this message translates to:
  /// **'Calculated from transactions'**
  String get balanceComputed;

  /// No description provided for @balanceClear.
  ///
  /// In en, this message translates to:
  /// **'Use automatic balance again'**
  String get balanceClear;

  /// No description provided for @balanceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get balanceTotal;

  /// No description provided for @balanceNegative.
  ///
  /// In en, this message translates to:
  /// **'Balance is negative (overdraft)'**
  String get balanceNegative;

  /// No description provided for @catSplit.
  ///
  /// In en, this message translates to:
  /// **'Split by category'**
  String get catSplit;

  /// No description provided for @editCatSplit.
  ///
  /// In en, this message translates to:
  /// **'Edit category split'**
  String get editCatSplit;

  /// No description provided for @removeCatSplit.
  ///
  /// In en, this message translates to:
  /// **'Remove category split'**
  String get removeCatSplit;

  /// No description provided for @catSplitCount.
  ///
  /// In en, this message translates to:
  /// **'Split into {n} categories'**
  String catSplitCount(int n);

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addPart;

  /// No description provided for @partsLeft.
  ///
  /// In en, this message translates to:
  /// **'Left to assign'**
  String get partsLeft;

  /// No description provided for @catSplitInvalid.
  ///
  /// In en, this message translates to:
  /// **'Need at least two categories, and the parts must add up to the total.'**
  String get catSplitInvalid;

  /// No description provided for @catSplitStale.
  ///
  /// In en, this message translates to:
  /// **'The amount changed. Redo the category split.'**
  String get catSplitStale;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
