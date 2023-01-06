import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_locale_en.dart';

/// Callers can lookup localized strings with an instance of AppLocale
/// returned by `AppLocale.of(context)`.
///
/// Applications need to include `AppLocale.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_locale.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocale.localizationsDelegates,
///   supportedLocales: AppLocale.supportedLocales,
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
/// be consistent with the languages listed in the AppLocale.supportedLocales
/// property.
abstract class AppLocale {
  AppLocale(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale)!;
  }

  static const LocalizationsDelegate<AppLocale> delegate = _AppLocaleDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @aboutUs_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs_ScreenTitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Files Tools is an application on which I worked during my spare time. It provides tools to perform various operations on files (documents and media), which helps everyone in their everyday life.'**
  String get appDescription;

  /// No description provided for @button_Cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_Cancel;

  /// No description provided for @button_ClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get button_ClearAll;

  /// No description provided for @button_Done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get button_Done;

  /// No description provided for @button_ExtractFileWithPageRange.
  ///
  /// In en, this message translates to:
  /// **'Extract {fileType} pages by page range'**
  String button_ExtractFileWithPageRange(Object fileType);

  /// No description provided for @button_ExtractFileWithSelection.
  ///
  /// In en, this message translates to:
  /// **'Extract {fileType} pages by selecting pages'**
  String button_ExtractFileWithSelection(Object fileType);

  /// No description provided for @button_GoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get button_GoBack;

  /// No description provided for @button_PickFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Pick {fileOrFilesType}'**
  String button_PickFileOrFiles(Object fileOrFilesType);

  /// No description provided for @button_PickMore.
  ///
  /// In en, this message translates to:
  /// **'Pick More'**
  String get button_PickMore;

  /// No description provided for @button_PrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get button_PrivacyPolicy;

  /// No description provided for @button_Process.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get button_Process;

  /// No description provided for @button_ReportError.
  ///
  /// In en, this message translates to:
  /// **'Report Error'**
  String get button_ReportError;

  /// No description provided for @button_ResetTheme.
  ///
  /// In en, this message translates to:
  /// **'Reset Theme'**
  String get button_ResetTheme;

  /// No description provided for @button_SaveFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Save {fileOrFilesType}'**
  String button_SaveFileOrFiles(Object fileOrFilesType);

  /// No description provided for @button_ShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get button_ShowAll;

  /// No description provided for @button_ShowSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Show Source Code'**
  String get button_ShowSourceCode;

  /// No description provided for @button_Skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get button_Skip;

  /// No description provided for @button_SplitFileWithPageInterval.
  ///
  /// In en, this message translates to:
  /// **'Split at a specific interval in {fileType}'**
  String button_SplitFileWithPageInterval(Object fileType);

  /// No description provided for @button_SplitFileWithPageNumbers.
  ///
  /// In en, this message translates to:
  /// **'Split at specific page numbers in {fileType}'**
  String button_SplitFileWithPageNumbers(Object fileType);

  /// No description provided for @button_SplitFileWithSize.
  ///
  /// In en, this message translates to:
  /// **'Split {fileType} in specific size'**
  String button_SplitFileWithSize(Object fileType);

  /// No description provided for @button_TermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get button_TermsAndConditions;

  /// No description provided for @colorPicker_Heading.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get colorPicker_Heading;

  /// No description provided for @colorPicker_Subheading.
  ///
  /// In en, this message translates to:
  /// **'Select color shade'**
  String get colorPicker_Subheading;

  /// No description provided for @colorPicker_WheelSubheading.
  ///
  /// In en, this message translates to:
  /// **'Selected color and its shades'**
  String get colorPicker_WheelSubheading;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @contributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 Document} one{Document} other{Documents}}'**
  String document(num count);

  /// No description provided for @documentTools.
  ///
  /// In en, this message translates to:
  /// **'Document Tools'**
  String get documentTools;

  /// No description provided for @errorReportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Error reported successfully'**
  String get errorReportSuccess;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 File} one{File} other{Files}}'**
  String file(num count);

  /// No description provided for @flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get flip;

  /// No description provided for @home_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Files Tools'**
  String get home_ScreenTitle;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 Image} one{Image} other{Images}}'**
  String image(num count);

  /// No description provided for @imageTools.
  ///
  /// In en, this message translates to:
  /// **'Image Tools'**
  String get imageTools;

  /// No description provided for @loadingPage.
  ///
  /// In en, this message translates to:
  /// **'Loading Page! Please wait...'**
  String get loadingPage;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 Media} one{Media} other{Media}}'**
  String media(num count);

  /// No description provided for @mediaTools.
  ///
  /// In en, this message translates to:
  /// **'Media Tools'**
  String get mediaTools;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get noAds;

  /// No description provided for @noOfPagesInFile.
  ///
  /// In en, this message translates to:
  /// **'No. of pages in {fileType} = {noOfPages}'**
  String noOfPagesInFile(Object fileType, Object noOfPages);

  /// No description provided for @noToolsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tools available'**
  String get noToolsAvailable;

  /// No description provided for @notSupportedFile_Opening.
  ///
  /// In en, this message translates to:
  /// **'Sorry! We don\'t support opening this type of file.'**
  String get notSupportedFile_Opening;

  /// No description provided for @onBoarding_CustomizeAppTheme.
  ///
  /// In en, this message translates to:
  /// **'Customize App Theme'**
  String get onBoarding_CustomizeAppTheme;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 Page} one{Page} other{Pages}}'**
  String page(num count);

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 PDF} one{PDF} other{PDFs}}'**
  String pdf(num count);

  /// No description provided for @pdfTools.
  ///
  /// In en, this message translates to:
  /// **'PDF Tools'**
  String get pdfTools;

  /// No description provided for @pickOneFile.
  ///
  /// In en, this message translates to:
  /// **'Please pick a {fileType}'**
  String pickOneFile(Object fileType);

  /// No description provided for @pickOneMoreFile.
  ///
  /// In en, this message translates to:
  /// **'Please pick at least one more file'**
  String get pickOneMoreFile;

  /// No description provided for @pickSomeFiles.
  ///
  /// In en, this message translates to:
  /// **'Please pick some {filesType}'**
  String pickSomeFiles(Object filesType);

  /// No description provided for @pickedFiles_Fetching.
  ///
  /// In en, this message translates to:
  /// **'Picking files! Please wait ...'**
  String get pickedFiles_Fetching;

  /// No description provided for @pickedFiles_Rearrange.
  ///
  /// In en, this message translates to:
  /// **'Long press and drag to rearrange {filesType}'**
  String pickedFiles_Rearrange(Object filesType);

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @savingFileOrFilesPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Saving {fileOrFilesType}. Please wait...'**
  String savingFileOrFilesPleaseWait(Object fileOrFilesType);

  /// No description provided for @savingFileOrFiles_PleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Saving {fileOrFilesType}! Please wait...'**
  String savingFileOrFiles_PleaseWait(Object fileOrFilesType);

  /// No description provided for @settings_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_ScreenTitle;

  /// No description provided for @settings_Theming_ChooseThemeColor_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme Color'**
  String get settings_Theming_ChooseThemeColor_ListTileTitle;

  /// No description provided for @settings_Theming_DynamicTheme_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use wallpaper for theme colors'**
  String get settings_Theming_DynamicTheme_ListTileSubtitle;

  /// No description provided for @settings_Theming_DynamicTheme_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Theme'**
  String get settings_Theming_DynamicTheme_ListTileTitle;

  /// No description provided for @settings_Theming_ThemeMode_Dark_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme Mode'**
  String get settings_Theming_ThemeMode_Dark_ListTileSubtitle;

  /// No description provided for @settings_Theming_ThemeMode_Light_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light Theme Mode'**
  String get settings_Theming_ThemeMode_Light_ListTileSubtitle;

  /// No description provided for @settings_Theming_ThemeMode_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settings_Theming_ThemeMode_ListTileTitle;

  /// No description provided for @settings_Theming_ThemeMode_System_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto/System Theme Mode'**
  String get settings_Theming_ThemeMode_System_ListTileSubtitle;

  /// No description provided for @settings_Theming_Title.
  ///
  /// In en, this message translates to:
  /// **'Theming'**
  String get settings_Theming_Title;

  /// No description provided for @settings_UsageAndDiagnostics_About.
  ///
  /// In en, this message translates to:
  /// **'Note: For a free & small app user reports are the only way to keep track of bugs.\n\nThe information collected is secure, does not contain any sensitive user information, and is only used for app development purposes.\n\nStill, if you don\'t want to share, we understand.'**
  String get settings_UsageAndDiagnostics_About;

  /// No description provided for @settings_UsageAndDiagnostics_Analytics_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share app usage for app improvement'**
  String get settings_UsageAndDiagnostics_Analytics_ListTileSubtitle;

  /// No description provided for @settings_UsageAndDiagnostics_Analytics_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get settings_UsageAndDiagnostics_Analytics_ListTileTitle;

  /// No description provided for @settings_UsageAndDiagnostics_Crashlytics_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share crash-reports for bugs fixing'**
  String get settings_UsageAndDiagnostics_Crashlytics_ListTileSubtitle;

  /// No description provided for @settings_UsageAndDiagnostics_Crashlytics_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Crashlytics'**
  String get settings_UsageAndDiagnostics_Crashlytics_ListTileTitle;

  /// No description provided for @settings_UsageAndDiagnostics_Title.
  ///
  /// In en, this message translates to:
  /// **'Usage & Diagnostics'**
  String get settings_UsageAndDiagnostics_Title;

  /// No description provided for @textField_ErrorText_EnterNumberGreaterThanXNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter number greater than {no}.'**
  String textField_ErrorText_EnterNumberGreaterThanXNumber(Object no);

  /// No description provided for @textField_ErrorText_EnterNumberInRange.
  ///
  /// In en, this message translates to:
  /// **'Enter number from {beginNo} to {endNo}.'**
  String textField_ErrorText_EnterNumberInRange(Object beginNo, Object endNo);

  /// No description provided for @textField_ErrorText_EnterNumberInRangeExcludingBegin.
  ///
  /// In en, this message translates to:
  /// **'Enter number from {beginNo} (excluded) to {endNo}.'**
  String textField_ErrorText_EnterNumberInRangeExcludingBegin(
      Object beginNo, Object endNo);

  /// No description provided for @textField_ErrorText_EnterNumberInRangeExcludingLimits.
  ///
  /// In en, this message translates to:
  /// **'Enter a number btwn. {beginNo} and {endNo} excluding ends.'**
  String textField_ErrorText_EnterNumberInRangeExcludingLimits(
      Object beginNo, Object endNo);

  /// No description provided for @textField_ErrorText_EnterNumbersAndRangeInRange.
  ///
  /// In en, this message translates to:
  /// **'Enter numbers and range from {beginNo} to {endNo}.'**
  String textField_ErrorText_EnterNumbersAndRangeInRange(
      Object beginNo, Object endNo);

  /// No description provided for @textField_ErrorText_EnterNumbersInRangeSeparatedByComma.
  ///
  /// In en, this message translates to:
  /// **'Enter numbers separated by \',\' from {beginNo} to {endNo}.'**
  String textField_ErrorText_EnterNumbersInRangeSeparatedByComma(
      Object beginNo, Object endNo);

  /// No description provided for @textField_ErrorText_EnterOwnerPwIfUserPwEmpty.
  ///
  /// In en, this message translates to:
  /// **'Must enter owner PW if user PW is empty.'**
  String get textField_ErrorText_EnterOwnerPwIfUserPwEmpty;

  /// No description provided for @textField_ErrorText_EnterUserPwIfOwnerPwEmpty.
  ///
  /// In en, this message translates to:
  /// **'Must enter user PW if owner PW is empty.'**
  String get textField_ErrorText_EnterUserPwIfOwnerPwEmpty;

  /// No description provided for @textField_ErrorText_FldMustBeFilled.
  ///
  /// In en, this message translates to:
  /// **'This field can\'t be left empty.'**
  String get textField_ErrorText_FldMustBeFilled;

  /// No description provided for @textField_HelperText_HigherScalingHigherQuality.
  ///
  /// In en, this message translates to:
  /// **'High scaling gives quality but slows processing'**
  String get textField_HelperText_HigherScalingHigherQuality;

  /// No description provided for @textField_HelperText_LeaveFldEmptyIfNoOwnerPwSet.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if only owner password is set'**
  String get textField_HelperText_LeaveFldEmptyIfNoOwnerPwSet;

  /// No description provided for @textField_LabelText_EnterImageQuality.
  ///
  /// In en, this message translates to:
  /// **'Enter Image Quality'**
  String get textField_LabelText_EnterImageQuality;

  /// No description provided for @textField_LabelText_EnterImageScaling.
  ///
  /// In en, this message translates to:
  /// **'Enter Image Scaling'**
  String get textField_LabelText_EnterImageScaling;

  /// No description provided for @textField_LabelText_EnterOwnerOrUserPw.
  ///
  /// In en, this message translates to:
  /// **'Enter Owner/User Password'**
  String get textField_LabelText_EnterOwnerOrUserPw;

  /// No description provided for @textField_LabelText_EnterOwnerPw.
  ///
  /// In en, this message translates to:
  /// **'Enter Owner Password'**
  String get textField_LabelText_EnterOwnerPw;

  /// No description provided for @textField_LabelText_EnterPageInterval.
  ///
  /// In en, this message translates to:
  /// **'Enter Page Interval'**
  String get textField_LabelText_EnterPageInterval;

  /// No description provided for @textField_LabelText_EnterPageNumbers.
  ///
  /// In en, this message translates to:
  /// **'Enter Page Numbers'**
  String get textField_LabelText_EnterPageNumbers;

  /// No description provided for @textField_LabelText_EnterPageRange.
  ///
  /// In en, this message translates to:
  /// **'Enter Page Range'**
  String get textField_LabelText_EnterPageRange;

  /// No description provided for @textField_LabelText_EnterSize.
  ///
  /// In en, this message translates to:
  /// **'Enter Size'**
  String get textField_LabelText_EnterSize;

  /// No description provided for @textField_LabelText_EnterUserPw.
  ///
  /// In en, this message translates to:
  /// **'Enter User Password'**
  String get textField_LabelText_EnterUserPw;

  /// No description provided for @textField_LabelText_EnterWatermarkFontSize.
  ///
  /// In en, this message translates to:
  /// **'Enter Watermark Font Size'**
  String get textField_LabelText_EnterWatermarkFontSize;

  /// No description provided for @textField_LabelText_EnterWatermarkOpacity.
  ///
  /// In en, this message translates to:
  /// **'Enter Watermark Opacity'**
  String get textField_LabelText_EnterWatermarkOpacity;

  /// No description provided for @textField_LabelText_EnterWatermarkRotationAngle.
  ///
  /// In en, this message translates to:
  /// **'Enter Watermark Rotation Angle'**
  String get textField_LabelText_EnterWatermarkRotationAngle;

  /// No description provided for @textField_LabelText_EnterWatermarkText.
  ///
  /// In en, this message translates to:
  /// **'Enter Watermark Text'**
  String get textField_LabelText_EnterWatermarkText;

  /// No description provided for @tool.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{0 Tool} one{Tool} other{Tools}}'**
  String tool(num count);

  /// No description provided for @tool_Action_CreateMultipleFile.
  ///
  /// In en, this message translates to:
  /// **'Create Multiple {fileType}'**
  String tool_Action_CreateMultipleFile(Object fileType);

  /// No description provided for @tool_Action_LoadingFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Loading {fileOrFilesType}! Please wait...'**
  String tool_Action_LoadingFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_Action_PrepareFileOrFiles1ForFileOrFiles2.
  ///
  /// In en, this message translates to:
  /// **'Prepare {fileOrFilesType1} For {fileOrFilesType2}'**
  String tool_Action_PrepareFileOrFiles1ForFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2);

  /// No description provided for @tool_Action_ProcessingScreen_Failed.
  ///
  /// In en, this message translates to:
  /// **'Action Failed'**
  String get tool_Action_ProcessingScreen_Failed;

  /// No description provided for @tool_Action_ProcessingScreen_PleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Processing Action! Please wait...'**
  String get tool_Action_ProcessingScreen_PleaseWait;

  /// No description provided for @tool_Action_ProcessingScreen_Successful.
  ///
  /// In en, this message translates to:
  /// **'Action Successful'**
  String get tool_Action_ProcessingScreen_Successful;

  /// No description provided for @tool_Action_ProcessingScreen_Title.
  ///
  /// In en, this message translates to:
  /// **'Processing Action'**
  String get tool_Action_ProcessingScreen_Title;

  /// No description provided for @tool_Action_ResultFilePagesOrder.
  ///
  /// In en, this message translates to:
  /// **'Result {fileType} Pages Order:-'**
  String tool_Action_ResultFilePagesOrder(Object fileType);

  /// No description provided for @tool_Action_ResultFilesPagesSets.
  ///
  /// In en, this message translates to:
  /// **'Result {filesType} Pages Sets:-'**
  String tool_Action_ResultFilesPagesSets(Object filesType);

  /// No description provided for @tool_Action_SanitizeUserInput.
  ///
  /// In en, this message translates to:
  /// **'Sanitize Your Input'**
  String get tool_Action_SanitizeUserInput;

  /// No description provided for @tool_Action_SizeOfFile.
  ///
  /// In en, this message translates to:
  /// **'Size of {fileType} = {size}'**
  String tool_Action_SizeOfFile(Object fileType, Object size);

  /// No description provided for @tool_Action_SmallFileSizeButBigUnitSelectedError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, {fileType} size is too small for taking input in this unit. Please choose a smaller unit.'**
  String tool_Action_SmallFileSizeButBigUnitSelectedError(Object fileType);

  /// No description provided for @tool_Action_selectAllPages_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Select All Pages'**
  String get tool_Action_selectAllPages_ListTileTitle;

  /// No description provided for @tool_CompressFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Compress {fileOrFilesType}'**
  String tool_CompressFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_CompressImage_RemoveExifData_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only works for jpg format'**
  String get tool_CompressImage_RemoveExifData_ListTileSubtitle;

  /// No description provided for @tool_CompressImage_RemoveExifData_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove EXIF Data'**
  String get tool_CompressImage_RemoveExifData_ListTileTitle;

  /// No description provided for @tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Can make {fileOrFilesType} obscure sometimes'**
  String tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileSubtitle(
      Object fileOrFilesType);

  /// No description provided for @tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Fonts From {fileOrFilesType}'**
  String tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileTitle(
      Object fileOrFilesType);

  /// No description provided for @tool_Compress_CompressionType_Custom.
  ///
  /// In en, this message translates to:
  /// **'Custom Compression'**
  String get tool_Compress_CompressionType_Custom;

  /// No description provided for @tool_Compress_CompressionType_High.
  ///
  /// In en, this message translates to:
  /// **'High Compression'**
  String get tool_Compress_CompressionType_High;

  /// No description provided for @tool_Compress_CompressionType_Low.
  ///
  /// In en, this message translates to:
  /// **'Low Compression'**
  String get tool_Compress_CompressionType_Low;

  /// No description provided for @tool_Compress_CompressionType_Medium.
  ///
  /// In en, this message translates to:
  /// **'Medium Compression'**
  String get tool_Compress_CompressionType_Medium;

  /// No description provided for @tool_Compress_ConfigureCompression.
  ///
  /// In en, this message translates to:
  /// **'Configure Compression'**
  String get tool_Compress_ConfigureCompression;

  /// No description provided for @tool_Compress_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'The higher the compression the lower the size and quality of {fileOrFilesType}.\n\nLess compression:\nImage scaling = 0.9, Image quality = 80\n\nMedium compression:\nImage scaling = 0.7, Image quality = 70\n\nExtreme compression:\nImage scaling = 0.7, Image quality = 60.'**
  String tool_Compress_InfoBody(Object fileOrFilesType);

  /// No description provided for @tool_Compress_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool helps decrease {fileOrFilesType} size'**
  String tool_Compress_InfoTitle(Object fileOrFilesType);

  /// No description provided for @tool_Compress_PdfNote.
  ///
  /// In en, this message translates to:
  /// **'Note: All compression methods remove duplicate or unused assets from the PDF.'**
  String get tool_Compress_PdfNote;

  /// No description provided for @tool_Compress_QualityType_Custom.
  ///
  /// In en, this message translates to:
  /// **'Custom Quality'**
  String get tool_Compress_QualityType_Custom;

  /// No description provided for @tool_Compress_QualityType_Good.
  ///
  /// In en, this message translates to:
  /// **'Good Quality'**
  String get tool_Compress_QualityType_Good;

  /// No description provided for @tool_Compress_QualityType_Low.
  ///
  /// In en, this message translates to:
  /// **'Low Quality'**
  String get tool_Compress_QualityType_Low;

  /// No description provided for @tool_Compress_QualityType_Ok.
  ///
  /// In en, this message translates to:
  /// **'Ok Quality'**
  String get tool_Compress_QualityType_Ok;

  /// No description provided for @tool_ConvertFileOrFiles1ToFileOrFiles2.
  ///
  /// In en, this message translates to:
  /// **'Convert {fileOrFilesType1} To {fileOrFilesType2}'**
  String tool_ConvertFileOrFiles1ToFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2);

  /// No description provided for @tool_ConvertFileOrFilesFormat.
  ///
  /// In en, this message translates to:
  /// **'Convert {fileOrFilesType} Format'**
  String tool_ConvertFileOrFilesFormat(Object fileOrFilesType);

  /// No description provided for @tool_Convert_SelectPagesToConvert.
  ///
  /// In en, this message translates to:
  /// **'Select Pages To Convert'**
  String get tool_Convert_SelectPagesToConvert;

  /// No description provided for @tool_DecryptFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Decrypt {fileOrFilesType}'**
  String tool_DecryptFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_DecryptPDF_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'If a {fileType} has an owner/permission password, but no user/open password, leave the input blank and continue because it can remove the owner/permission password without a password.\nHowever, if the {fileType} has a user password, you must enter it in order to decrypt it.\n\nAbout owner and user password:-\n\nA owner/permission password is generally used to restrict printing, editing, and copying content in the {fileType}. And it requires a user to type a password to change those permission settings.\n\nA user/open password requires a user to type a password to open the {fileType}.'**
  String tool_DecryptPDF_InfoBody(Object fileType);

  /// No description provided for @tool_Decrypt_ConfigureDecryption.
  ///
  /// In en, this message translates to:
  /// **'Configure Decryption'**
  String get tool_Decrypt_ConfigureDecryption;

  /// No description provided for @tool_Decrypt_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool removes encryption from {fileOrFilesType}'**
  String tool_Decrypt_InfoTitle(Object fileOrFilesType);

  /// No description provided for @tool_EncryptFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Encrypt {fileOrFilesType}'**
  String tool_EncryptFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_EncryptPDF_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'About owner and user password:-\n\nA owner/permission password is generally used to restrict printing, editing, and copying content in the {fileType}. And it requires a user to type a password to change those permission settings.\n\nA user/open password requires a user to type a password to open the {fileType}.'**
  String tool_EncryptPDF_InfoBody(Object fileType);

  /// No description provided for @tool_Encrypt_ConfigureEncryption.
  ///
  /// In en, this message translates to:
  /// **'Configure Encryption'**
  String get tool_Encrypt_ConfigureEncryption;

  /// No description provided for @tool_Encrypt_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool adds encryption to {fileOrFilesType}'**
  String tool_Encrypt_InfoTitle(Object fileOrFilesType);

  /// No description provided for @tool_Encrypt_Permission_AllowAssembly.
  ///
  /// In en, this message translates to:
  /// **'Allow Assembly'**
  String get tool_Encrypt_Permission_AllowAssembly;

  /// No description provided for @tool_Encrypt_Permission_AllowCopy.
  ///
  /// In en, this message translates to:
  /// **'Allow Copy'**
  String get tool_Encrypt_Permission_AllowCopy;

  /// No description provided for @tool_Encrypt_Permission_AllowDegradedPrinting.
  ///
  /// In en, this message translates to:
  /// **'Allow Degraded Printing'**
  String get tool_Encrypt_Permission_AllowDegradedPrinting;

  /// No description provided for @tool_Encrypt_Permission_AllowFillIn.
  ///
  /// In en, this message translates to:
  /// **'Allow Fill In'**
  String get tool_Encrypt_Permission_AllowFillIn;

  /// No description provided for @tool_Encrypt_Permission_AllowModifyingAnnotations.
  ///
  /// In en, this message translates to:
  /// **'Allow Modifying Annotations'**
  String get tool_Encrypt_Permission_AllowModifyingAnnotations;

  /// No description provided for @tool_Encrypt_Permission_AllowModifyingContents.
  ///
  /// In en, this message translates to:
  /// **'Allow Modifying Contents'**
  String get tool_Encrypt_Permission_AllowModifyingContents;

  /// No description provided for @tool_Encrypt_Permission_AllowPrinting.
  ///
  /// In en, this message translates to:
  /// **'Allow Printing'**
  String get tool_Encrypt_Permission_AllowPrinting;

  /// No description provided for @tool_Encrypt_Permission_AllowScreenReaders.
  ///
  /// In en, this message translates to:
  /// **'Allow Screen Readers'**
  String get tool_Encrypt_Permission_AllowScreenReaders;

  /// No description provided for @tool_Encrypt_SetEncryptionPermissions.
  ///
  /// In en, this message translates to:
  /// **'Set Encryption Permissions'**
  String get tool_Encrypt_SetEncryptionPermissions;

  /// No description provided for @tool_Encrypt_SetEncryptionType.
  ///
  /// In en, this message translates to:
  /// **'Set Encryption Type'**
  String get tool_Encrypt_SetEncryptionType;

  /// No description provided for @tool_Encrypt_Setting_DoNotEncryptMetadata.
  ///
  /// In en, this message translates to:
  /// **'Do Not Encrypt Metadata'**
  String get tool_Encrypt_Setting_DoNotEncryptMetadata;

  /// No description provided for @tool_Encrypt_Setting_EncryptEmbeddedFilesOnly.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Embedded Files Only'**
  String get tool_Encrypt_Setting_EncryptEmbeddedFilesOnly;

  /// No description provided for @tool_Encrypt_encryptionType_AES128.
  ///
  /// In en, this message translates to:
  /// **'AES\n128'**
  String get tool_Encrypt_encryptionType_AES128;

  /// No description provided for @tool_Encrypt_encryptionType_AES256.
  ///
  /// In en, this message translates to:
  /// **'AES\n256'**
  String get tool_Encrypt_encryptionType_AES256;

  /// No description provided for @tool_Encrypt_encryptionType_StandardAES128.
  ///
  /// In en, this message translates to:
  /// **'Standard\nAES\n128'**
  String get tool_Encrypt_encryptionType_StandardAES128;

  /// No description provided for @tool_Encrypt_encryptionType_StandardAES40.
  ///
  /// In en, this message translates to:
  /// **'Standard\nAES\n40'**
  String get tool_Encrypt_encryptionType_StandardAES40;

  /// No description provided for @tool_FileOrFiles1ToFileOrFiles2.
  ///
  /// In en, this message translates to:
  /// **'{fileOrFilesType1} To {fileOrFilesType2}'**
  String tool_FileOrFiles1ToFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2);

  /// No description provided for @tool_InfoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Tool Info'**
  String get tool_InfoCardTitle;

  /// No description provided for @tool_MergeFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Merge {fileOrFilesType}'**
  String tool_MergeFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_ModifyFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Modify {fileOrFilesType}'**
  String tool_ModifyFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_Modify_CropRotateFlipFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Crop, Rotate & Flip {fileOrFilesType}'**
  String tool_Modify_CropRotateFlipFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_Modify_RotateDeleteReorderFileOrFilesPages.
  ///
  /// In en, this message translates to:
  /// **'Rotate, Delete & Reorder {fileOrFilesType} Pages'**
  String tool_Modify_RotateDeleteReorderFileOrFilesPages(
      Object fileOrFilesType);

  /// No description provided for @tool_SplitFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Split {fileOrFilesType}'**
  String tool_SplitFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_Split_DiscardRangeRepeats_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Range duplicates are discarded'**
  String get tool_Split_DiscardRangeRepeats_ListTileSubtitle;

  /// No description provided for @tool_Split_DiscardRangeRepeats_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard Repeats In Range'**
  String get tool_Split_DiscardRangeRepeats_ListTileTitle;

  /// No description provided for @tool_Split_ExtractSinglePageFileError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, can\'t further extract page from a {fileType} with 1 page.'**
  String tool_Split_ExtractSinglePageFileError(Object fileType);

  /// No description provided for @tool_Split_ForceRangeAscending_ListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Range taken in ascending order'**
  String get tool_Split_ForceRangeAscending_ListTileSubtitle;

  /// No description provided for @tool_Split_ForceRangeAscending_ListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Force Ascending'**
  String get tool_Split_ForceRangeAscending_ListTileTitle;

  /// No description provided for @tool_Split_SinglePageFileError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, can\'t further split a {fileType} with 1 page.'**
  String tool_Split_SinglePageFileError(Object fileType);

  /// No description provided for @tool_Split_WithPageInterval_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'If pages in selected {fileType} = 10\n\nAnd, your input = 3\n\nThen, it will split the {fileType} at every next 3rd page\n\nSo, we will get (10 / 3) = 4 {filesType}\n\n{fileType} 1 containing pages - 1,2,3\n{fileType} 2 containing pages - 4,5,6\n{fileType} 3 containing pages - 7,8,9\n{fileType} 4 containing page - 10'**
  String tool_Split_WithPageInterval_InfoBody(
      Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithPageInterval_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool splits {fileType} into multiple {filesType}, each having pages equal to provided interval'**
  String tool_Split_WithPageInterval_InfoTitle(
      Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithPageInterval_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Provide Page Interval'**
  String get tool_Split_WithPageInterval_ScreenTitle;

  /// No description provided for @tool_Split_WithPageNumbers_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'If pages in selected {fileType} = 10\n\nAnd, your input = 3,7\n(Tip: 1 is default in input)\n\nThen, it will split the {fileType} from 1, 3 and 7\n\nSo, we will get 3 {filesType} :-\n\n{fileType} 1 containing pages - 1,2\n{fileType} 2 containing pages - 3,4,5,6\n{fileType} 3 containing pages - 7,8,9,10'**
  String tool_Split_WithPageNumbers_InfoBody(Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithPageNumbers_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool splits {fileType} into multiple {filesType}, from provided page numbers'**
  String tool_Split_WithPageNumbers_InfoTitle(
      Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithPageNumbers_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Provide Page Numbers'**
  String get tool_Split_WithPageNumbers_ScreenTitle;

  /// No description provided for @tool_Split_WithPageRange_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'If pages in selected {fileType} = 10\n\nAnd, your input = 2-4,6\n\nThen, result {fileType} will contain pages - 2,3,4,6'**
  String tool_Split_WithPageRange_InfoBody(Object fileType);

  /// No description provided for @tool_Split_WithPageRange_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool extracts a range of pages from {fileOrFilesType}'**
  String tool_Split_WithPageRange_InfoTitle(Object fileOrFilesType);

  /// No description provided for @tool_Split_WithPageRange_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Provide Page Range'**
  String get tool_Split_WithPageRange_ScreenTitle;

  /// No description provided for @tool_Split_WithPageRanges_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Provide Page Ranges'**
  String get tool_Split_WithPageRanges_ScreenTitle;

  /// No description provided for @tool_Split_WithSelectPages_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Pages To Extract'**
  String get tool_Split_WithSelectPages_ScreenTitle;

  /// No description provided for @tool_Split_WithSize_InfoBody.
  ///
  /// In en, this message translates to:
  /// **'If a {fileType} size = 100 MB\n\nAnd, your input(in MB) = 25\n\nThen, all result {filesType} size will be under 25 MB\n\nNote: If a provided size is not possible then it creates {filesType} of minimum possible size.'**
  String tool_Split_WithSize_InfoBody(Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithSize_InfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This tool splits {fileType} into multiple {filesType}, from provided size'**
  String tool_Split_WithSize_InfoTitle(Object fileType, Object filesType);

  /// No description provided for @tool_Split_WithSize_ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Provide Size'**
  String get tool_Split_WithSize_ScreenTitle;

  /// No description provided for @tool_WatermarkFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Watermark {fileOrFilesType}'**
  String tool_WatermarkFileOrFiles(Object fileOrFilesType);

  /// No description provided for @tool_Watermark_ConfigureWatermark.
  ///
  /// In en, this message translates to:
  /// **'Configure Watermark'**
  String get tool_Watermark_ConfigureWatermark;

  /// No description provided for @tool_Watermark_LayerType_OverContent.
  ///
  /// In en, this message translates to:
  /// **'Over Content'**
  String get tool_Watermark_LayerType_OverContent;

  /// No description provided for @tool_Watermark_LayerType_UnderContent.
  ///
  /// In en, this message translates to:
  /// **'Under Content'**
  String get tool_Watermark_LayerType_UnderContent;

  /// No description provided for @tool_Watermark_PositionType_BottomCenter.
  ///
  /// In en, this message translates to:
  /// **'Bottom\nCenter'**
  String get tool_Watermark_PositionType_BottomCenter;

  /// No description provided for @tool_Watermark_PositionType_BottomLeft.
  ///
  /// In en, this message translates to:
  /// **'Bottom\nLeft'**
  String get tool_Watermark_PositionType_BottomLeft;

  /// No description provided for @tool_Watermark_PositionType_BottomRight.
  ///
  /// In en, this message translates to:
  /// **'Bottom\nRight'**
  String get tool_Watermark_PositionType_BottomRight;

  /// No description provided for @tool_Watermark_PositionType_Center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get tool_Watermark_PositionType_Center;

  /// No description provided for @tool_Watermark_PositionType_CenterLeft.
  ///
  /// In en, this message translates to:
  /// **'Center\nLeft'**
  String get tool_Watermark_PositionType_CenterLeft;

  /// No description provided for @tool_Watermark_PositionType_CenterRight.
  ///
  /// In en, this message translates to:
  /// **'Center\nRight'**
  String get tool_Watermark_PositionType_CenterRight;

  /// No description provided for @tool_Watermark_PositionType_TopCenter.
  ///
  /// In en, this message translates to:
  /// **'Top\nCenter'**
  String get tool_Watermark_PositionType_TopCenter;

  /// No description provided for @tool_Watermark_PositionType_TopLeft.
  ///
  /// In en, this message translates to:
  /// **'Top\nLeft'**
  String get tool_Watermark_PositionType_TopLeft;

  /// No description provided for @tool_Watermark_PositionType_TopRight.
  ///
  /// In en, this message translates to:
  /// **'Top\nRight'**
  String get tool_Watermark_PositionType_TopRight;

  /// No description provided for @tool_Watermark_SelectWatermarkColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Watermark Color'**
  String get tool_Watermark_SelectWatermarkColor;

  /// No description provided for @tool_Watermark_SelectWatermarkLayer.
  ///
  /// In en, this message translates to:
  /// **'Choose Watermark Layer'**
  String get tool_Watermark_SelectWatermarkLayer;

  /// No description provided for @tool_Watermark_SelectWatermarkPosition.
  ///
  /// In en, this message translates to:
  /// **'Choose Watermark Position'**
  String get tool_Watermark_SelectWatermarkPosition;

  /// No description provided for @viewFileOrFiles.
  ///
  /// In en, this message translates to:
  /// **'Click on {fileOrFilesType} to view them'**
  String viewFileOrFiles(Object fileOrFilesType);

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;
}

class _AppLocaleDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocaleDelegate();

  @override
  Future<AppLocale> load(Locale locale) {
    return SynchronousFuture<AppLocale>(lookupAppLocale(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocaleDelegate old) => false;
}

AppLocale lookupAppLocale(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocaleEn();
  }

  throw FlutterError(
      'AppLocale.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
