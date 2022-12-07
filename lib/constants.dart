// ignore_for_file: constant_identifier_names

/// App privacy policy url.
String privacyPolicyUrl = 'https://pureinfoapps.com/files-tools/privacy-policy';

/// App terms and conditions url.
String termsAndConditionsUrl =
    'https://pureinfoapps.com/files-tools/terms-and-conditions';

/// App source code url.
String sourceCodeUrl = 'https://github.com/chaudharydeepanshu/files_tools';

/// App creator github account url.
String creatorGithubUrl = 'https://github.com/chaudharydeepanshu';

/// App creator linkedin account url.
String creatorLinkedInUrl = 'https://www.linkedin.com/in/chaudhary-deepanshu/';

/// Types of formats for a file size.
enum BytesFormatType {
  /// Auto type is used get file size in best suitable format.
  auto,

  /// B type is used get file size in Byte format.
  B,

  /// KB type is used get file size in Kilo Byte format.
  KB,

  /// MB type is used get file size in Mega Byte format.
  MB,

  /// GB type is used get file size in Giga Byte format.
  GB,

  /// TB type is used get file size in Tera Byte format.
  TB,

  /// PB type is used get file size in Peta Byte format.
  PB,

  /// EB type is used get file size in Exa Byte format.
  EB,

  /// ZB type is used get file size in Zetta Byte format.
  ZB,

  /// YB type is used get file size in Yotta Byte format.
  YB,
}

/// Types of compressions for a file.
enum CompressionTypes {
  /// For less compression.
  less,

  /// For medium compression.
  medium,

  /// For high compression.
  extreme,

  /// For custom compression.
  custom,
}
