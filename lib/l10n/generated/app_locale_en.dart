import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

/// The translations for English (`en`).
class AppLocaleEn extends AppLocale {
  AppLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get aboutUs_ScreenTitle => 'About Us';

  @override
  String get appDescription =>
      'Files Tools is an application on which I worked during my spare time. It provides tools to perform various operations on files (documents and media), which helps everyone in their everyday life.';

  @override
  String get button_Cancel => 'Cancel';

  @override
  String get button_ClearAll => 'Clear All';

  @override
  String get button_Done => 'Done';

  @override
  String button_ExtractFileWithPageRange(Object fileType) {
    return 'Extract $fileType pages by page range';
  }

  @override
  String button_ExtractFileWithSelection(Object fileType) {
    return 'Extract $fileType pages by selecting pages';
  }

  @override
  String get button_GoBack => 'Go Back';

  @override
  String button_PickFileOrFiles(Object fileOrFilesType) {
    return 'Pick $fileOrFilesType';
  }

  @override
  String get button_PickMore => 'Pick More';

  @override
  String get button_PrivacyPolicy => 'Privacy Policy';

  @override
  String get button_Process => 'Process';

  @override
  String get button_ReportError => 'Report Error';

  @override
  String get button_ResetTheme => 'Reset Theme';

  @override
  String button_SaveFileOrFiles(Object fileOrFilesType) {
    return 'Save $fileOrFilesType';
  }

  @override
  String get button_ShowAll => 'Show All';

  @override
  String get button_ShowSourceCode => 'Show Source Code';

  @override
  String get button_Skip => 'Skip';

  @override
  String button_SplitFileWithPageInterval(Object fileType) {
    return 'Split at a specific interval in $fileType';
  }

  @override
  String button_SplitFileWithPageNumbers(Object fileType) {
    return 'Split at specific page numbers in $fileType';
  }

  @override
  String button_SplitFileWithSize(Object fileType) {
    return 'Split $fileType in specific size';
  }

  @override
  String get button_TermsAndConditions => 'Terms & Conditions';

  @override
  String get colorPicker_Heading => 'Select color';

  @override
  String get colorPicker_Subheading => 'Select color shade';

  @override
  String get colorPicker_WheelSubheading => 'Selected color and its shades';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get contributors => 'Contributors';

  @override
  String get creator => 'Creator';

  @override
  String get credits => 'Credits';

  @override
  String get crop => 'Crop';

  @override
  String get delete => 'Delete';

  @override
  String document(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Documents',
      one: 'Document',
      zero: '0 Document',
    );
    return '$_temp0';
  }

  @override
  String get documentTools => 'Document Tools';

  @override
  String get errorReportSuccess => 'Error reported successfully';

  @override
  String get example => 'Example';

  @override
  String file(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Files',
      one: 'File',
      zero: '0 File',
    );
    return '$_temp0';
  }

  @override
  String get flip => 'Flip';

  @override
  String get home_ScreenTitle => 'Files Tools';

  @override
  String image(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Images',
      one: 'Image',
      zero: '0 Image',
    );
    return '$_temp0';
  }

  @override
  String get imageTools => 'Image Tools';

  @override
  String get loadingPage => 'Loading Page! Please wait...';

  @override
  String media(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Media',
      one: 'Media',
      zero: '0 Media',
    );
    return '$_temp0';
  }

  @override
  String get mediaTools => 'Media Tools';

  @override
  String get noAds => 'No Ads';

  @override
  String noOfPagesInFile(Object fileType, Object noOfPages) {
    return 'No. of pages in $fileType = $noOfPages';
  }

  @override
  String get noToolsAvailable => 'No tools available';

  @override
  String get notSupportedFile_Opening =>
      'Sorry! We don\'t support opening this type of file.';

  @override
  String get onBoarding_CustomizeAppTheme => 'Customize App Theme';

  @override
  String get openSource => 'Open Source';

  @override
  String page(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pages',
      one: 'Page',
      zero: '0 Page',
    );
    return '$_temp0';
  }

  @override
  String pdf(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PDFs',
      one: 'PDF',
      zero: '0 PDF',
    );
    return '$_temp0';
  }

  @override
  String get pdfTools => 'PDF Tools';

  @override
  String pickOneFile(Object fileType) {
    return 'Please pick a $fileType';
  }

  @override
  String get pickOneMoreFile => 'Please pick at least one more file';

  @override
  String pickSomeFiles(Object filesType) {
    return 'Please pick some $filesType';
  }

  @override
  String get pickedFiles_Fetching => 'Picking files! Please wait ...';

  @override
  String pickedFiles_Rearrange(Object filesType) {
    return 'Long press and drag to rearrange $filesType';
  }

  @override
  String get reorder => 'Reorder';

  @override
  String get rotate => 'Rotate';

  @override
  String savingFileOrFilesPleaseWait(Object fileOrFilesType) {
    return 'Saving $fileOrFilesType. Please wait...';
  }

  @override
  String savingFileOrFiles_PleaseWait(Object fileOrFilesType) {
    return 'Saving $fileOrFilesType! Please wait...';
  }

  @override
  String get settings_ScreenTitle => 'Settings';

  @override
  String get settings_Theming_ChooseThemeColor_ListTileTitle =>
      'Choose Theme Color';

  @override
  String get settings_Theming_DynamicTheme_ListTileSubtitle =>
      'Use wallpaper for theme colors';

  @override
  String get settings_Theming_DynamicTheme_ListTileTitle => 'Dynamic Theme';

  @override
  String get settings_Theming_ThemeMode_Dark_ListTileSubtitle =>
      'Dark Theme Mode';

  @override
  String get settings_Theming_ThemeMode_Light_ListTileSubtitle =>
      'Light Theme Mode';

  @override
  String get settings_Theming_ThemeMode_ListTileTitle => 'Theme Mode';

  @override
  String get settings_Theming_ThemeMode_System_ListTileSubtitle =>
      'Auto/System Theme Mode';

  @override
  String get settings_Theming_Title => 'Theming';

  @override
  String get settings_UsageAndDiagnostics_About =>
      'Note: For a free & small app user reports are the only way to keep track of bugs.\n\nThe information collected is secure, does not contain any sensitive user information, and is only used for app development purposes.\n\nStill, if you don\'t want to share, we understand.';

  @override
  String get settings_UsageAndDiagnostics_Analytics_ListTileSubtitle =>
      'Share app usage for app improvement';

  @override
  String get settings_UsageAndDiagnostics_Analytics_ListTileTitle =>
      'Analytics';

  @override
  String get settings_UsageAndDiagnostics_Crashlytics_ListTileSubtitle =>
      'Share crash-reports for bugs fixing';

  @override
  String get settings_UsageAndDiagnostics_Crashlytics_ListTileTitle =>
      'Crashlytics';

  @override
  String get settings_UsageAndDiagnostics_Title => 'Usage & Diagnostics';

  @override
  String textField_ErrorText_EnterNumberGreaterThanXNumber(Object no) {
    return 'Enter number greater than $no.';
  }

  @override
  String textField_ErrorText_EnterNumberInRange(Object beginNo, Object endNo) {
    return 'Enter number from $beginNo to $endNo.';
  }

  @override
  String textField_ErrorText_EnterNumberInRangeExcludingBegin(
      Object beginNo, Object endNo) {
    return 'Enter number from $beginNo (excluded) to $endNo.';
  }

  @override
  String textField_ErrorText_EnterNumberInRangeExcludingLimits(
      Object beginNo, Object endNo) {
    return 'Enter a number btwn. $beginNo and $endNo excluding ends.';
  }

  @override
  String textField_ErrorText_EnterNumbersAndRangeInRange(
      Object beginNo, Object endNo) {
    return 'Enter numbers and range from $beginNo to $endNo.';
  }

  @override
  String textField_ErrorText_EnterNumbersInRangeSeparatedByComma(
      Object beginNo, Object endNo) {
    return 'Enter numbers separated by \',\' from $beginNo to $endNo.';
  }

  @override
  String get textField_ErrorText_EnterOwnerPwIfUserPwEmpty =>
      'Must enter owner PW if user PW is empty.';

  @override
  String get textField_ErrorText_EnterUserPwIfOwnerPwEmpty =>
      'Must enter user PW if owner PW is empty.';

  @override
  String get textField_ErrorText_FldMustBeFilled =>
      'This field can\'t be left empty.';

  @override
  String get textField_HelperText_HigherScalingHigherQuality =>
      'High scaling gives quality but slows processing';

  @override
  String get textField_HelperText_LeaveFldEmptyIfNoOwnerPwSet =>
      'Leave empty if only owner password is set';

  @override
  String get textField_LabelText_EnterImageQuality => 'Enter Image Quality';

  @override
  String get textField_LabelText_EnterImageScaling => 'Enter Image Scaling';

  @override
  String get textField_LabelText_EnterOwnerOrUserPw =>
      'Enter Owner/User Password';

  @override
  String get textField_LabelText_EnterOwnerPw => 'Enter Owner Password';

  @override
  String get textField_LabelText_EnterPageInterval => 'Enter Page Interval';

  @override
  String get textField_LabelText_EnterPageNumbers => 'Enter Page Numbers';

  @override
  String get textField_LabelText_EnterPageRange => 'Enter Page Range';

  @override
  String get textField_LabelText_EnterSize => 'Enter Size';

  @override
  String get textField_LabelText_EnterUserPw => 'Enter User Password';

  @override
  String get textField_LabelText_EnterWatermarkFontSize =>
      'Enter Watermark Font Size';

  @override
  String get textField_LabelText_EnterWatermarkOpacity =>
      'Enter Watermark Opacity';

  @override
  String get textField_LabelText_EnterWatermarkRotationAngle =>
      'Enter Watermark Rotation Angle';

  @override
  String get textField_LabelText_EnterWatermarkText => 'Enter Watermark Text';

  @override
  String tool(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tools',
      one: 'Tool',
      zero: '0 Tool',
    );
    return '$_temp0';
  }

  @override
  String tool_Action_CreateMultipleFile(Object fileType) {
    return 'Create Multiple $fileType';
  }

  @override
  String tool_Action_LoadingFileOrFiles(Object fileOrFilesType) {
    return 'Loading $fileOrFilesType! Please wait...';
  }

  @override
  String tool_Action_PrepareFileOrFiles1ForFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2) {
    return 'Prepare $fileOrFilesType1 For $fileOrFilesType2';
  }

  @override
  String get tool_Action_ProcessingScreen_Failed => 'Action Failed';

  @override
  String get tool_Action_ProcessingScreen_PleaseWait =>
      'Processing Action! Please wait...';

  @override
  String get tool_Action_ProcessingScreen_Successful => 'Action Successful';

  @override
  String get tool_Action_ProcessingScreen_Title => 'Processing Action';

  @override
  String tool_Action_ResultFilePagesOrder(Object fileType) {
    return 'Result $fileType Pages Order:-';
  }

  @override
  String tool_Action_ResultFilesPagesSets(Object filesType) {
    return 'Result $filesType Pages Sets:-';
  }

  @override
  String get tool_Action_SanitizeUserInput => 'Sanitize Your Input';

  @override
  String tool_Action_SizeOfFile(Object fileType, Object size) {
    return 'Size of $fileType = $size';
  }

  @override
  String tool_Action_SmallFileSizeButBigUnitSelectedError(Object fileType) {
    return 'Sorry, $fileType size is too small for taking input in this unit. Please choose a smaller unit.';
  }

  @override
  String get tool_Action_selectAllPages_ListTileTitle => 'Select All Pages';

  @override
  String tool_CompressFileOrFiles(Object fileOrFilesType) {
    return 'Compress $fileOrFilesType';
  }

  @override
  String get tool_CompressImage_RemoveExifData_ListTileSubtitle =>
      'Only works for jpg format';

  @override
  String get tool_CompressImage_RemoveExifData_ListTileTitle =>
      'Remove EXIF Data';

  @override
  String tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileSubtitle(
      Object fileOrFilesType) {
    return 'Can make $fileOrFilesType obscure sometimes';
  }

  @override
  String tool_CompressPDF_RemoveFontsFromFileOrFiles_ListTileTitle(
      Object fileOrFilesType) {
    return 'Remove Fonts From $fileOrFilesType';
  }

  @override
  String get tool_Compress_CompressionType_Custom => 'Custom Compression';

  @override
  String get tool_Compress_CompressionType_High => 'High Compression';

  @override
  String get tool_Compress_CompressionType_Low => 'Low Compression';

  @override
  String get tool_Compress_CompressionType_Medium => 'Medium Compression';

  @override
  String get tool_Compress_ConfigureCompression => 'Configure Compression';

  @override
  String tool_Compress_InfoBody(Object fileOrFilesType) {
    return 'The higher the compression the lower the size and quality of $fileOrFilesType.\n\nLess compression:\nImage scaling = 0.9, Image quality = 80\n\nMedium compression:\nImage scaling = 0.7, Image quality = 70\n\nExtreme compression:\nImage scaling = 0.7, Image quality = 60.';
  }

  @override
  String tool_Compress_InfoTitle(Object fileOrFilesType) {
    return 'This tool helps decrease $fileOrFilesType size';
  }

  @override
  String get tool_Compress_PdfNote =>
      'Note: All compression methods remove duplicate or unused assets from the PDF.';

  @override
  String get tool_Compress_QualityType_Custom => 'Custom Quality';

  @override
  String get tool_Compress_QualityType_Good => 'Good Quality';

  @override
  String get tool_Compress_QualityType_Low => 'Low Quality';

  @override
  String get tool_Compress_QualityType_Ok => 'Ok Quality';

  @override
  String tool_ConvertFileOrFiles1ToFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2) {
    return 'Convert $fileOrFilesType1 To $fileOrFilesType2';
  }

  @override
  String tool_ConvertFileOrFilesFormat(Object fileOrFilesType) {
    return 'Convert $fileOrFilesType Format';
  }

  @override
  String get tool_Convert_SelectPagesToConvert => 'Select Pages To Convert';

  @override
  String tool_DecryptFileOrFiles(Object fileOrFilesType) {
    return 'Decrypt $fileOrFilesType';
  }

  @override
  String tool_DecryptPDF_InfoBody(Object fileType) {
    return 'If a $fileType has an owner/permission password, but no user/open password, leave the input blank and continue because it can remove the owner/permission password without a password.\nHowever, if the $fileType has a user password, you must enter it in order to decrypt it.\n\nAbout owner and user password:-\n\nA owner/permission password is generally used to restrict printing, editing, and copying content in the $fileType. And it requires a user to type a password to change those permission settings.\n\nA user/open password requires a user to type a password to open the $fileType.';
  }

  @override
  String get tool_Decrypt_ConfigureDecryption => 'Configure Decryption';

  @override
  String tool_Decrypt_InfoTitle(Object fileOrFilesType) {
    return 'This tool removes encryption from $fileOrFilesType';
  }

  @override
  String tool_EncryptFileOrFiles(Object fileOrFilesType) {
    return 'Encrypt $fileOrFilesType';
  }

  @override
  String tool_EncryptPDF_InfoBody(Object fileType) {
    return 'About owner and user password:-\n\nA owner/permission password is generally used to restrict printing, editing, and copying content in the $fileType. And it requires a user to type a password to change those permission settings.\n\nA user/open password requires a user to type a password to open the $fileType.';
  }

  @override
  String get tool_Encrypt_ConfigureEncryption => 'Configure Encryption';

  @override
  String tool_Encrypt_InfoTitle(Object fileOrFilesType) {
    return 'This tool adds encryption to $fileOrFilesType';
  }

  @override
  String get tool_Encrypt_Permission_AllowAssembly => 'Allow Assembly';

  @override
  String get tool_Encrypt_Permission_AllowCopy => 'Allow Copy';

  @override
  String get tool_Encrypt_Permission_AllowDegradedPrinting =>
      'Allow Degraded Printing';

  @override
  String get tool_Encrypt_Permission_AllowFillIn => 'Allow Fill In';

  @override
  String get tool_Encrypt_Permission_AllowModifyingAnnotations =>
      'Allow Modifying Annotations';

  @override
  String get tool_Encrypt_Permission_AllowModifyingContents =>
      'Allow Modifying Contents';

  @override
  String get tool_Encrypt_Permission_AllowPrinting => 'Allow Printing';

  @override
  String get tool_Encrypt_Permission_AllowScreenReaders =>
      'Allow Screen Readers';

  @override
  String get tool_Encrypt_SetEncryptionPermissions =>
      'Set Encryption Permissions';

  @override
  String get tool_Encrypt_SetEncryptionType => 'Set Encryption Type';

  @override
  String get tool_Encrypt_Setting_DoNotEncryptMetadata =>
      'Do Not Encrypt Metadata';

  @override
  String get tool_Encrypt_Setting_EncryptEmbeddedFilesOnly =>
      'Encrypt Embedded Files Only';

  @override
  String get tool_Encrypt_encryptionType_AES128 => 'AES\n128';

  @override
  String get tool_Encrypt_encryptionType_AES256 => 'AES\n256';

  @override
  String get tool_Encrypt_encryptionType_StandardAES128 => 'Standard\nAES\n128';

  @override
  String get tool_Encrypt_encryptionType_StandardAES40 => 'Standard\nAES\n40';

  @override
  String tool_FileOrFiles1ToFileOrFiles2(
      Object fileOrFilesType1, Object fileOrFilesType2) {
    return '$fileOrFilesType1 To $fileOrFilesType2';
  }

  @override
  String get tool_InfoCardTitle => 'Tool Info';

  @override
  String tool_MergeFileOrFiles(Object fileOrFilesType) {
    return 'Merge $fileOrFilesType';
  }

  @override
  String tool_ModifyFileOrFiles(Object fileOrFilesType) {
    return 'Modify $fileOrFilesType';
  }

  @override
  String tool_Modify_CropRotateFlipFileOrFiles(Object fileOrFilesType) {
    return 'Crop, Rotate & Flip $fileOrFilesType';
  }

  @override
  String tool_Modify_RotateDeleteReorderFileOrFilesPages(
      Object fileOrFilesType) {
    return 'Rotate, Delete & Reorder $fileOrFilesType Pages';
  }

  @override
  String tool_SplitFileOrFiles(Object fileOrFilesType) {
    return 'Split $fileOrFilesType';
  }

  @override
  String get tool_Split_DiscardRangeRepeats_ListTileSubtitle =>
      'Range duplicates are discarded';

  @override
  String get tool_Split_DiscardRangeRepeats_ListTileTitle =>
      'Discard Repeats In Range';

  @override
  String tool_Split_ExtractSinglePageFileError(Object fileType) {
    return 'Sorry, can\'t further extract page from a $fileType with 1 page.';
  }

  @override
  String get tool_Split_ForceRangeAscending_ListTileSubtitle =>
      'Range taken in ascending order';

  @override
  String get tool_Split_ForceRangeAscending_ListTileTitle => 'Force Ascending';

  @override
  String tool_Split_SinglePageFileError(Object fileType) {
    return 'Sorry, can\'t further split a $fileType with 1 page.';
  }

  @override
  String tool_Split_WithPageInterval_InfoBody(
      Object fileType, Object filesType) {
    return 'If pages in selected $fileType = 10\n\nAnd, your input = 3\n\nThen, it will split the $fileType at every next 3rd page\n\nSo, we will get (10 / 3) = 4 $filesType\n\n$fileType 1 containing pages - 1,2,3\n$fileType 2 containing pages - 4,5,6\n$fileType 3 containing pages - 7,8,9\n$fileType 4 containing page - 10';
  }

  @override
  String tool_Split_WithPageInterval_InfoTitle(
      Object fileType, Object filesType) {
    return 'This tool splits $fileType into multiple $filesType, each having pages equal to provided interval';
  }

  @override
  String get tool_Split_WithPageInterval_ScreenTitle => 'Provide Page Interval';

  @override
  String tool_Split_WithPageNumbers_InfoBody(
      Object fileType, Object filesType) {
    return 'If pages in selected $fileType = 10\n\nAnd, your input = 3,7\n(Tip: 1 is default in input)\n\nThen, it will split the $fileType from 1, 3 and 7\n\nSo, we will get 3 $filesType :-\n\n$fileType 1 containing pages - 1,2\n$fileType 2 containing pages - 3,4,5,6\n$fileType 3 containing pages - 7,8,9,10';
  }

  @override
  String tool_Split_WithPageNumbers_InfoTitle(
      Object fileType, Object filesType) {
    return 'This tool splits $fileType into multiple $filesType, from provided page numbers';
  }

  @override
  String get tool_Split_WithPageNumbers_ScreenTitle => 'Provide Page Numbers';

  @override
  String tool_Split_WithPageRange_InfoBody(Object fileType) {
    return 'If pages in selected $fileType = 10\n\nAnd, your input = 2-4,6\n\nThen, result $fileType will contain pages - 2,3,4,6';
  }

  @override
  String tool_Split_WithPageRange_InfoTitle(Object fileOrFilesType) {
    return 'This tool extracts a range of pages from $fileOrFilesType';
  }

  @override
  String get tool_Split_WithPageRange_ScreenTitle => 'Provide Page Range';

  @override
  String get tool_Split_WithPageRanges_ScreenTitle => 'Provide Page Ranges';

  @override
  String get tool_Split_WithSelectPages_ScreenTitle =>
      'Select Pages To Extract';

  @override
  String tool_Split_WithSize_InfoBody(Object fileType, Object filesType) {
    return 'If a $fileType size = 100 MB\n\nAnd, your input(in MB) = 25\n\nThen, all result $filesType size will be under 25 MB\n\nNote: If a provided size is not possible then it creates $filesType of minimum possible size.';
  }

  @override
  String tool_Split_WithSize_InfoTitle(Object fileType, Object filesType) {
    return 'This tool splits $fileType into multiple $filesType, from provided size';
  }

  @override
  String get tool_Split_WithSize_ScreenTitle => 'Provide Size';

  @override
  String tool_WatermarkFileOrFiles(Object fileOrFilesType) {
    return 'Watermark $fileOrFilesType';
  }

  @override
  String get tool_Watermark_ConfigureWatermark => 'Configure Watermark';

  @override
  String get tool_Watermark_LayerType_OverContent => 'Over Content';

  @override
  String get tool_Watermark_LayerType_UnderContent => 'Under Content';

  @override
  String get tool_Watermark_PositionType_BottomCenter => 'Bottom\nCenter';

  @override
  String get tool_Watermark_PositionType_BottomLeft => 'Bottom\nLeft';

  @override
  String get tool_Watermark_PositionType_BottomRight => 'Bottom\nRight';

  @override
  String get tool_Watermark_PositionType_Center => 'Center';

  @override
  String get tool_Watermark_PositionType_CenterLeft => 'Center\nLeft';

  @override
  String get tool_Watermark_PositionType_CenterRight => 'Center\nRight';

  @override
  String get tool_Watermark_PositionType_TopCenter => 'Top\nCenter';

  @override
  String get tool_Watermark_PositionType_TopLeft => 'Top\nLeft';

  @override
  String get tool_Watermark_PositionType_TopRight => 'Top\nRight';

  @override
  String get tool_Watermark_SelectWatermarkColor => 'Choose Watermark Color';

  @override
  String get tool_Watermark_SelectWatermarkLayer => 'Choose Watermark Layer';

  @override
  String get tool_Watermark_SelectWatermarkPosition =>
      'Choose Watermark Position';

  @override
  String viewFileOrFiles(Object fileOrFilesType) {
    return 'Click on $fileOrFilesType to view them';
  }

  @override
  String get welcome => 'Welcome';
}
