import 'package:flutter/material.dart';

/// 托管小票模板
/// 定义小票的完整配置结构，支持中英双语
class CustodyReceiptTemplate {
  final String id;
  final String name;
  final HeaderConfig header;
  final DepositInfoConfig depositInfo;
  final MemberInfoConfig memberInfo;
  final PrintInfoConfig printInfo;
  final FooterConfig footer;
  final PrintSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustodyReceiptTemplate({
    required this.id,
    required this.name,
    required this.header,
    required this.depositInfo,
    required this.memberInfo,
    required this.printInfo,
    required this.footer,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建默认模板
  factory CustodyReceiptTemplate.defaultTemplate() {
    final now = DateTime.now();
    return CustodyReceiptTemplate(
      id: 'default_custody',
      name: '默认托管小票模板',
      header: HeaderConfig.defaultConfig(),
      depositInfo: DepositInfoConfig.defaultConfig(),
      memberInfo: MemberInfoConfig.defaultConfig(),
      printInfo: PrintInfoConfig.defaultConfig(),
      footer: FooterConfig.defaultConfig(),
      settings: PrintSettings.defaultSettings(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 从 JSON 反序列化
  factory CustodyReceiptTemplate.fromJson(Map<String, dynamic> json) {
    return CustodyReceiptTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      header: HeaderConfig.fromJson(json['header'] as Map<String, dynamic>),
      depositInfo: DepositInfoConfig.fromJson(json['depositInfo'] as Map<String, dynamic>),
      memberInfo: MemberInfoConfig.fromJson(json['memberInfo'] as Map<String, dynamic>),
      printInfo: PrintInfoConfig.fromJson(json['printInfo'] as Map<String, dynamic>),
      footer: FooterConfig.fromJson(json['footer'] as Map<String, dynamic>),
      settings: PrintSettings.fromJson(json['settings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'header': header.toJson(),
      'depositInfo': depositInfo.toJson(),
      'memberInfo': memberInfo.toJson(),
      'printInfo': printInfo.toJson(),
      'footer': footer.toJson(),
      'settings': settings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 复制并修改
  CustodyReceiptTemplate copyWith({
    String? id,
    String? name,
    HeaderConfig? header,
    DepositInfoConfig? depositInfo,
    MemberInfoConfig? memberInfo,
    PrintInfoConfig? printInfo,
    FooterConfig? footer,
    PrintSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustodyReceiptTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      header: header ?? this.header,
      depositInfo: depositInfo ?? this.depositInfo,
      memberInfo: memberInfo ?? this.memberInfo,
      printInfo: printInfo ?? this.printInfo,
      footer: footer ?? this.footer,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 头部配置
class HeaderConfig {
  final String storeName;        // 店铺名称（中文）
  final String storeNameEn;      // 店铺名称（英文）
  final bool showLogo;           // 是否显示Logo
  final TextAlign alignment;     // 对齐方式
  final int fontSize;            // 字体大小（相对大小：1-正常，2-大，3-特大）
  final bool bold;               // 是否加粗

  HeaderConfig({
    required this.storeName,
    required this.storeNameEn,
    required this.showLogo,
    required this.alignment,
    required this.fontSize,
    required this.bold,
  });

  factory HeaderConfig.defaultConfig() {
    return HeaderConfig(
      storeName: 'HOLOX超乐场',
      storeNameEn: 'HOLOX',
      showLogo: true,
      alignment: TextAlign.center,
      fontSize: 3,
      bold: true,
    );
  }

  factory HeaderConfig.fromJson(Map<String, dynamic> json) {
    return HeaderConfig(
      storeName: json['storeName'] as String,
      storeNameEn: json['storeNameEn'] as String,
      showLogo: json['showLogo'] as bool,
      alignment: TextAlign.values[json['alignment'] as int],
      fontSize: json['fontSize'] as int,
      bold: json['bold'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'storeNameEn': storeNameEn,
      'showLogo': showLogo,
      'alignment': alignment.index,
      'fontSize': fontSize,
      'bold': bold,
    };
  }

  HeaderConfig copyWith({
    String? storeName,
    String? storeNameEn,
    bool? showLogo,
    TextAlign? alignment,
    int? fontSize,
    bool? bold,
  }) {
    return HeaderConfig(
      storeName: storeName ?? this.storeName,
      storeNameEn: storeNameEn ?? this.storeNameEn,
      showLogo: showLogo ?? this.showLogo,
      alignment: alignment ?? this.alignment,
      fontSize: fontSize ?? this.fontSize,
      bold: bold ?? this.bold,
    );
  }
}

/// 存币信息配置
class DepositInfoConfig {
  final bool showDepositNumber;     // 显示存币单号
  final bool showStoreName;         // 显示门店名称
  final bool showBarcode;           // 显示条形码
  final String depositLabel;        // "存币单号" 标签
  final String depositLabelEn;      // "Deposit Ticket No." 标签
  final String storeLabel;          // "门店" 标签
  final String storeLabelEn;        // "Store" 标签
  final BarcodeType barcodeType;    // 条形码类型

  DepositInfoConfig({
    required this.showDepositNumber,
    required this.showStoreName,
    required this.showBarcode,
    required this.depositLabel,
    required this.depositLabelEn,
    required this.storeLabel,
    required this.storeLabelEn,
    required this.barcodeType,
  });

  factory DepositInfoConfig.defaultConfig() {
    return DepositInfoConfig(
      showDepositNumber: true,
      showStoreName: true,
      showBarcode: true,
      depositLabel: '存币单号',
      depositLabelEn: 'Deposit Ticket No.',
      storeLabel: '门店',
      storeLabelEn: 'Store',
      barcodeType: BarcodeType.code128,
    );
  }

  factory DepositInfoConfig.fromJson(Map<String, dynamic> json) {
    return DepositInfoConfig(
      showDepositNumber: json['showDepositNumber'] as bool,
      showStoreName: json['showStoreName'] as bool,
      showBarcode: json['showBarcode'] as bool,
      depositLabel: json['depositLabel'] as String,
      depositLabelEn: json['depositLabelEn'] as String,
      storeLabel: json['storeLabel'] as String,
      storeLabelEn: json['storeLabelEn'] as String,
      barcodeType: BarcodeType.values[json['barcodeType'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showDepositNumber': showDepositNumber,
      'showStoreName': showStoreName,
      'showBarcode': showBarcode,
      'depositLabel': depositLabel,
      'depositLabelEn': depositLabelEn,
      'storeLabel': storeLabel,
      'storeLabelEn': storeLabelEn,
      'barcodeType': barcodeType.index,
    };
  }

  DepositInfoConfig copyWith({
    bool? showDepositNumber,
    bool? showStoreName,
    bool? showBarcode,
    String? depositLabel,
    String? depositLabelEn,
    String? storeLabel,
    String? storeLabelEn,
    BarcodeType? barcodeType,
  }) {
    return DepositInfoConfig(
      showDepositNumber: showDepositNumber ?? this.showDepositNumber,
      showStoreName: showStoreName ?? this.showStoreName,
      showBarcode: showBarcode ?? this.showBarcode,
      depositLabel: depositLabel ?? this.depositLabel,
      depositLabelEn: depositLabelEn ?? this.depositLabelEn,
      storeLabel: storeLabel ?? this.storeLabel,
      storeLabelEn: storeLabelEn ?? this.storeLabelEn,
      barcodeType: barcodeType ?? this.barcodeType,
    );
  }
}

/// 会员信息配置
class MemberInfoConfig {
  final bool showMemberId;          // 显示会员编号
  final bool showOperationTime;     // 显示操作时间
  final bool showTicketQuantity;    // 显示彩票数量
  final Map<String, String> labels; // 中英文标签映射

  MemberInfoConfig({
    required this.showMemberId,
    required this.showOperationTime,
    required this.showTicketQuantity,
    required this.labels,
  });

  factory MemberInfoConfig.defaultConfig() {
    return MemberInfoConfig(
      showMemberId: true,
      showOperationTime: true,
      showTicketQuantity: true,
      labels: {
        'memberId': '会员编号',
        'memberIdEn': 'Member ID',
        'operationTime': '操作时间',
        'operationTimeEn': 'Operation Time',
        'ticketQuantity': '彩票数量',
        'ticketQuantityEn': 'Ticket Quantity',
      },
    );
  }

  factory MemberInfoConfig.fromJson(Map<String, dynamic> json) {
    return MemberInfoConfig(
      showMemberId: json['showMemberId'] as bool,
      showOperationTime: json['showOperationTime'] as bool,
      showTicketQuantity: json['showTicketQuantity'] as bool,
      labels: Map<String, String>.from(json['labels'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showMemberId': showMemberId,
      'showOperationTime': showOperationTime,
      'showTicketQuantity': showTicketQuantity,
      'labels': labels,
    };
  }

  MemberInfoConfig copyWith({
    bool? showMemberId,
    bool? showOperationTime,
    bool? showTicketQuantity,
    Map<String, String>? labels,
  }) {
    return MemberInfoConfig(
      showMemberId: showMemberId ?? this.showMemberId,
      showOperationTime: showOperationTime ?? this.showOperationTime,
      showTicketQuantity: showTicketQuantity ?? this.showTicketQuantity,
      labels: labels ?? this.labels,
    );
  }
}

/// 打印信息配置
class PrintInfoConfig {
  final bool showPrintTime;         // 显示打印时间
  final bool showOperator;          // 显示操作员
  final bool showAddress;           // 显示地址
  final bool showPhone;             // 显示电话
  final String address;             // 门店地址
  final String phone;               // 联系电话
  final Map<String, String> labels; // 中英文标签映射

  PrintInfoConfig({
    required this.showPrintTime,
    required this.showOperator,
    required this.showAddress,
    required this.showPhone,
    required this.address,
    required this.phone,
    required this.labels,
  });

  factory PrintInfoConfig.defaultConfig() {
    return PrintInfoConfig(
      showPrintTime: true,
      showOperator: true,
      showAddress: true,
      showPhone: true,
      address: 'Dubai Mall',
      phone: 'XX-XXXXXXXX',
      labels: {
        'printTime': '打印时间',
        'printTimeEn': 'Print Time',
        'operator': '操作员',
        'operatorEn': 'Operator',
        'address': '地址',
        'addressEn': 'Address',
        'phone': '电话',
        'phoneEn': 'Phone',
      },
    );
  }

  factory PrintInfoConfig.fromJson(Map<String, dynamic> json) {
    return PrintInfoConfig(
      showPrintTime: json['showPrintTime'] as bool,
      showOperator: json['showOperator'] as bool,
      showAddress: json['showAddress'] as bool,
      showPhone: json['showPhone'] as bool,
      address: json['address'] as String,
      phone: json['phone'] as String,
      labels: Map<String, String>.from(json['labels'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showPrintTime': showPrintTime,
      'showOperator': showOperator,
      'showAddress': showAddress,
      'showPhone': showPhone,
      'address': address,
      'phone': phone,
      'labels': labels,
    };
  }

  PrintInfoConfig copyWith({
    bool? showPrintTime,
    bool? showOperator,
    bool? showAddress,
    bool? showPhone,
    String? address,
    String? phone,
    Map<String, String>? labels,
  }) {
    return PrintInfoConfig(
      showPrintTime: showPrintTime ?? this.showPrintTime,
      showOperator: showOperator ?? this.showOperator,
      showAddress: showAddress ?? this.showAddress,
      showPhone: showPhone ?? this.showPhone,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      labels: labels ?? this.labels,
    );
  }
}

/// 底部配置
class FooterConfig {
  final bool showReminder;          // 显示提示语
  final bool showThankYou;          // 显示感谢语
  final String reminderText;        // 中文提示
  final String reminderTextEn;      // 英文提示
  final String thankYouText;        // 中文感谢
  final String thankYouTextEn;      // 英文感谢
  final TextAlign alignment;        // 对齐方式

  FooterConfig({
    required this.showReminder,
    required this.showThankYou,
    required this.reminderText,
    required this.reminderTextEn,
    required this.thankYouText,
    required this.thankYouTextEn,
    required this.alignment,
  });

  factory FooterConfig.defaultConfig() {
    return FooterConfig(
      showReminder: true,
      showThankYou: true,
      reminderText: '请妥善保管好您的小票，如需兑换礼品请持小票到收银台兑换！',
      reminderTextEn: 'Please keep your receipt safe. To redeem gifts, present it at the cashier desk.',
      thankYouText: '感谢惠顾！祝您游玩愉快！',
      thankYouTextEn: 'Thank you for your patronage! Wish you a pleasant time!',
      alignment: TextAlign.center,
    );
  }

  factory FooterConfig.fromJson(Map<String, dynamic> json) {
    return FooterConfig(
      showReminder: json['showReminder'] as bool,
      showThankYou: json['showThankYou'] as bool,
      reminderText: json['reminderText'] as String,
      reminderTextEn: json['reminderTextEn'] as String,
      thankYouText: json['thankYouText'] as String,
      thankYouTextEn: json['thankYouTextEn'] as String,
      alignment: TextAlign.values[json['alignment'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showReminder': showReminder,
      'showThankYou': showThankYou,
      'reminderText': reminderText,
      'reminderTextEn': reminderTextEn,
      'thankYouText': thankYouText,
      'thankYouTextEn': thankYouTextEn,
      'alignment': alignment.index,
    };
  }

  FooterConfig copyWith({
    bool? showReminder,
    bool? showThankYou,
    String? reminderText,
    String? reminderTextEn,
    String? thankYouText,
    String? thankYouTextEn,
    TextAlign? alignment,
  }) {
    return FooterConfig(
      showReminder: showReminder ?? this.showReminder,
      showThankYou: showThankYou ?? this.showThankYou,
      reminderText: reminderText ?? this.reminderText,
      reminderTextEn: reminderTextEn ?? this.reminderTextEn,
      thankYouText: thankYouText ?? this.thankYouText,
      thankYouTextEn: thankYouTextEn ?? this.thankYouTextEn,
      alignment: alignment ?? this.alignment,
    );
  }
}

/// 打印设置
class PrintSettings {
  final bool bilingual;             // 是否双语打印
  final int paperWidth;             // 纸张宽度（字符数）
  final bool cutPaper;              // 自动切纸
  final int feedLines;              // 走纸行数
  final bool boldTitle;             // 标题加粗
  final bool showSeparator;         // 显示分隔线

  PrintSettings({
    required this.bilingual,
    required this.paperWidth,
    required this.cutPaper,
    required this.feedLines,
    required this.boldTitle,
    required this.showSeparator,
  });

  factory PrintSettings.defaultSettings() {
    return PrintSettings(
      bilingual: true,
      paperWidth: 48,  // 80mm纸张
      cutPaper: true,
      feedLines: 3,
      boldTitle: true,
      showSeparator: true,
    );
  }

  factory PrintSettings.fromJson(Map<String, dynamic> json) {
    return PrintSettings(
      bilingual: json['bilingual'] as bool,
      paperWidth: json['paperWidth'] as int,
      cutPaper: json['cutPaper'] as bool,
      feedLines: json['feedLines'] as int,
      boldTitle: json['boldTitle'] as bool,
      showSeparator: json['showSeparator'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bilingual': bilingual,
      'paperWidth': paperWidth,
      'cutPaper': cutPaper,
      'feedLines': feedLines,
      'boldTitle': boldTitle,
      'showSeparator': showSeparator,
    };
  }

  PrintSettings copyWith({
    bool? bilingual,
    int? paperWidth,
    bool? cutPaper,
    int? feedLines,
    bool? boldTitle,
    bool? showSeparator,
  }) {
    return PrintSettings(
      bilingual: bilingual ?? this.bilingual,
      paperWidth: paperWidth ?? this.paperWidth,
      cutPaper: cutPaper ?? this.cutPaper,
      feedLines: feedLines ?? this.feedLines,
      boldTitle: boldTitle ?? this.boldTitle,
      showSeparator: showSeparator ?? this.showSeparator,
    );
  }
}

/// 条形码类型
enum BarcodeType {
  code128,
  code39,
  ean13,
  qrcode,
}

extension BarcodeTypeExtension on BarcodeType {
  String get displayName {
    switch (this) {
      case BarcodeType.code128:
        return 'CODE128';
      case BarcodeType.code39:
        return 'CODE39';
      case BarcodeType.ean13:
        return 'EAN13';
      case BarcodeType.qrcode:
        return 'QR Code';
    }
  }
}
