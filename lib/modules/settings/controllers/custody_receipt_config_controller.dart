import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/receipt/custody_receipt_template.dart';
import '../../../data/models/receipt/custody_receipt_data.dart';
import '../../../data/services/sunmi_printer_service.dart';

/// 托管小票配置控制器
/// 负责模板的加载、保存、预览等业务逻辑
class CustodyReceiptConfigController extends GetxController {
  // 存储键名
  static const String _storageKey = 'custody_receipt_template';

  // 当前模板配置（响应式）
  final Rx<CustodyReceiptTemplate> template = CustodyReceiptTemplate.defaultTemplate().obs;

  // 预览数据（响应式）
  final Rx<CustodyReceiptData> previewData = CustodyReceiptData.sample().obs;

  // 加载状态
  final RxBool isLoading = false.obs;

  // 保存状态
  final RxBool isSaving = false.obs;

  // 修改状态（是否有未保存的修改）
  final RxBool hasUnsavedChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTemplate();
  }

  /// 加载模板配置
  Future<void> loadTemplate() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        template.value = CustodyReceiptTemplate.fromJson(json);
        Get.snackbar(
          '加载成功',
          '已加载托管小票模板配置',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // 如果没有保存的配置，使用默认模板
        template.value = CustodyReceiptTemplate.defaultTemplate();
      }

      hasUnsavedChanges.value = false;
    } catch (e) {
      Get.snackbar(
        '加载失败',
        '加载模板配置时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      // 出错时使用默认模板
      template.value = CustodyReceiptTemplate.defaultTemplate();
    } finally {
      isLoading.value = false;
    }
  }

  /// 保存模板配置
  Future<bool> saveTemplate() async {
    try {
      isSaving.value = true;
      final prefs = await SharedPreferences.getInstance();

      // 更新时间戳
      final updatedTemplate = template.value.copyWith(
        updatedAt: DateTime.now(),
      );
      template.value = updatedTemplate;

      // 序列化并保存
      final jsonString = jsonEncode(updatedTemplate.toJson());
      await prefs.setString(_storageKey, jsonString);

      hasUnsavedChanges.value = false;

      Get.snackbar(
        '保存成功',
        '托管小票模板配置已保存',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        '保存失败',
        '保存模板配置时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// 重置为默认模板
  void resetToDefault() {
    template.value = CustodyReceiptTemplate.defaultTemplate();
    hasUnsavedChanges.value = true;
    Get.snackbar(
      '已重置',
      '模板已重置为默认配置',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// 更新头部配置
  void updateHeader(HeaderConfig newHeader) {
    template.value = template.value.copyWith(header: newHeader);
    hasUnsavedChanges.value = true;
  }

  /// 更新存币信息配置
  void updateDepositInfo(DepositInfoConfig newDepositInfo) {
    template.value = template.value.copyWith(depositInfo: newDepositInfo);
    hasUnsavedChanges.value = true;
  }

  /// 更新会员信息配置
  void updateMemberInfo(MemberInfoConfig newMemberInfo) {
    template.value = template.value.copyWith(memberInfo: newMemberInfo);
    hasUnsavedChanges.value = true;
  }

  /// 更新打印信息配置
  void updatePrintInfo(PrintInfoConfig newPrintInfo) {
    template.value = template.value.copyWith(printInfo: newPrintInfo);
    hasUnsavedChanges.value = true;
  }

  /// 更新底部配置
  void updateFooter(FooterConfig newFooter) {
    template.value = template.value.copyWith(footer: newFooter);
    hasUnsavedChanges.value = true;
  }

  /// 更新打印设置
  void updateSettings(PrintSettings newSettings) {
    template.value = template.value.copyWith(settings: newSettings);
    hasUnsavedChanges.value = true;
  }

  /// 更新预览数据
  void updatePreviewData(CustodyReceiptData newData) {
    previewData.value = newData;
  }

  /// 导出模板配置（返回 JSON 字符串）
  String exportTemplate() {
    try {
      final json = template.value.toJson();
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      Get.snackbar(
        '导出失败',
        '导出模板配置时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return '';
    }
  }

  /// 导入模板配置（从 JSON 字符串）
  bool importTemplate(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      template.value = CustodyReceiptTemplate.fromJson(json);
      hasUnsavedChanges.value = true;
      Get.snackbar(
        '导入成功',
        '模板配置已导入',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        '导入失败',
        '解析模板配置时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// 验证模板配置
  bool validateTemplate() {
    final errors = <String>[];

    // 验证头部
    if (template.value.header.storeName.isEmpty) {
      errors.add('店铺名称不能为空');
    }
    if (template.value.header.storeNameEn.isEmpty) {
      errors.add('英文店铺名称不能为空');
    }

    // 验证打印信息
    if (template.value.printInfo.showAddress && template.value.printInfo.address.isEmpty) {
      errors.add('启用地址显示时，地址不能为空');
    }
    if (template.value.printInfo.showPhone && template.value.printInfo.phone.isEmpty) {
      errors.add('启用电话显示时，电话不能为空');
    }

    // 验证底部信息
    if (template.value.footer.showReminder && template.value.footer.reminderText.isEmpty) {
      errors.add('启用提示语时，提示语不能为空');
    }
    if (template.value.footer.showThankYou && template.value.footer.thankYouText.isEmpty) {
      errors.add('启用感谢语时，感谢语不能为空');
    }

    // 验证打印设置
    if (template.value.settings.paperWidth < 32 || template.value.settings.paperWidth > 64) {
      errors.add('纸张宽度必须在 32-64 个字符之间');
    }

    if (errors.isNotEmpty) {
      Get.snackbar(
        '验证失败',
        errors.join('\n'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  /// 生成预览文本（用于预览组件显示）
  List<String> generatePreviewText() {
    final lines = <String>[];
    final config = template.value;
    final data = previewData.value;
    final bilingual = config.settings.bilingual;

    // 头部
    if (bilingual) {
      lines.add(_centerText(config.header.storeName));
      lines.add(_centerText(config.header.storeNameEn));
    } else {
      lines.add(_centerText(config.header.storeName));
    }
    
    if (config.settings.showSeparator) {
      lines.add(_separator());
    }

    // 存币信息
    if (config.depositInfo.showDepositNumber) {
      if (bilingual) {
        lines.add('${config.depositInfo.depositLabel}：${data.depositNumber}');
        lines.add('${config.depositInfo.depositLabelEn}: ${data.depositNumber}');
      } else {
        lines.add('${config.depositInfo.depositLabel}：${data.depositNumber}');
      }
    }

    if (config.depositInfo.showStoreName) {
      if (bilingual) {
        lines.add('${config.depositInfo.storeLabel}：${data.storeName}');
        lines.add('${config.depositInfo.storeLabelEn}: ${data.storeName}');
      } else {
        lines.add('${config.depositInfo.storeLabel}：${data.storeName}');
      }
    }

    if (config.depositInfo.showBarcode) {
      lines.add(_centerText('[条形码区域]'));
      lines.add(_centerText('[Barcode Area]'));
    }

    if (config.settings.showSeparator) {
      lines.add(_separator());
    }

    // 会员信息
    if (config.memberInfo.showMemberId) {
      if (bilingual) {
        lines.add('${config.memberInfo.labels['memberId']}：${data.memberId}');
        lines.add('${config.memberInfo.labels['memberIdEn']}: ${data.memberId}');
      } else {
        lines.add('${config.memberInfo.labels['memberId']}：${data.memberId}');
      }
    }

    if (config.memberInfo.showOperationTime) {
      if (bilingual) {
        lines.add('${config.memberInfo.labels['operationTime']}：${data.formattedOperationTime}');
        lines.add('${config.memberInfo.labels['operationTimeEn']}: ${data.formattedOperationTime}');
      } else {
        lines.add('${config.memberInfo.labels['operationTime']}：${data.formattedOperationTime}');
      }
    }

    if (config.memberInfo.showTicketQuantity) {
      if (bilingual) {
        lines.add('${config.memberInfo.labels['ticketQuantity']}：${data.formattedTicketQuantity}');
        lines.add('${config.memberInfo.labels['ticketQuantityEn']}: ${data.formattedTicketQuantity}');
      } else {
        lines.add('${config.memberInfo.labels['ticketQuantity']}：${data.formattedTicketQuantity}');
      }
    }

    if (config.settings.showSeparator) {
      lines.add(_separator());
    }

    // 打印信息
    if (config.printInfo.showPrintTime) {
      if (bilingual) {
        lines.add('${config.printInfo.labels['printTime']}：${data.formattedPrintTime}');
        lines.add('${config.printInfo.labels['printTimeEn']}: ${data.formattedPrintTime}');
      } else {
        lines.add('${config.printInfo.labels['printTime']}：${data.formattedPrintTime}');
      }
    }

    if (config.printInfo.showOperator) {
      if (bilingual) {
        lines.add('${config.printInfo.labels['operator']}：${data.operator}');
        lines.add('${config.printInfo.labels['operatorEn']}: ${data.operator}');
      } else {
        lines.add('${config.printInfo.labels['operator']}：${data.operator}');
      }
    }

    if (config.printInfo.showAddress) {
      if (bilingual) {
        lines.add('${config.printInfo.labels['address']}：${config.printInfo.address}');
        lines.add('${config.printInfo.labels['addressEn']}: ${config.printInfo.address}');
      } else {
        lines.add('${config.printInfo.labels['address']}：${config.printInfo.address}');
      }
    }

    if (config.printInfo.showPhone) {
      if (bilingual) {
        lines.add('${config.printInfo.labels['phone']}：${config.printInfo.phone}');
        lines.add('${config.printInfo.labels['phoneEn']}: ${config.printInfo.phone}');
      } else {
        lines.add('${config.printInfo.labels['phone']}：${config.printInfo.phone}');
      }
    }

    if (config.settings.showSeparator) {
      lines.add(_separator());
    }

    // 底部信息
    if (config.footer.showReminder) {
      if (bilingual) {
        lines.add(_wrapText(config.footer.reminderText));
        lines.add(_wrapText(config.footer.reminderTextEn));
      } else {
        lines.add(_wrapText(config.footer.reminderText));
      }
    }

    if (config.footer.showThankYou) {
      lines.add('');
      if (bilingual) {
        lines.add(_centerText(config.footer.thankYouText));
        lines.add(_centerText(config.footer.thankYouTextEn));
      } else {
        lines.add(_centerText(config.footer.thankYouText));
      }
    }

    return lines;
  }

  /// 居中文本
  String _centerText(String text) {
    final width = template.value.settings.paperWidth;
    if (text.length >= width) return text;
    final padding = (width - text.length) ~/ 2;
    return ' ' * padding + text;
  }

  /// 分隔线
  String _separator() {
    return '-' * template.value.settings.paperWidth;
  }

  /// 自动换行文本
  String _wrapText(String text) {
    final width = template.value.settings.paperWidth;
    if (text.length <= width) return text;
    
    // 简单的换行处理
    final lines = <String>[];
    for (var i = 0; i < text.length; i += width) {
      final end = (i + width < text.length) ? i + width : text.length;
      lines.add(text.substring(i, end));
    }
    return lines.join('\n');
  }

  /// 检查是否有未保存的修改
  bool get canDiscard {
    return !hasUnsavedChanges.value;
  }

  /// 丢弃修改
  Future<void> discardChanges() async {
    await loadTemplate();
    Get.snackbar(
      '已放弃',
      '未保存的修改已放弃',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ========== 打印功能集成 ==========

  /// 获取打印机服务
  SunmiPrinterService get _printerService {
    try {
      return Get.find<SunmiPrinterService>();
    } catch (e) {
      throw Exception('打印机服务未初始化，请确保在 main.dart 中注册了 SunmiPrinterService');
    }
  }

  /// 测试条形码打印
  /// 使用当前配置的条形码类型和预览数据进行测试
  Future<void> testPrintBarcode() async {
    try {
      final config = template.value.depositInfo;
      
      if (!config.showBarcode) {
        Get.snackbar(
          '提示',
          '条形码显示已关闭，请先在配置中启用',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        '正在打印',
        '正在测试条形码打印...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      final success = await _printerService.printBarcode(
        previewData.value.depositNumber,
        config.barcodeType,
      );

      if (success) {
        Get.snackbar(
          '打印成功',
          '条形码已发送到打印机',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '打印失败',
          '条形码打印失败，请检查打印机状态',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        '打印错误',
        '条形码打印时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 测试完整小票打印
  /// 使用当前模板配置和预览数据打印完整小票
  Future<void> testPrintReceipt() async {
    try {
      // 先验证配置
      if (!validateTemplate()) {
        return; // 验证失败时已经显示了错误信息
      }

      Get.snackbar(
        '正在打印',
        '正在打印托管小票...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      final success = await _printerService.printCustodyReceipt(
        template.value,
        previewData.value,
      );

      if (success) {
        Get.snackbar(
          '打印成功',
          '托管小票已发送到打印机',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '打印失败',
          '小票打印失败，请检查打印机状态',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        '打印错误',
        '小票打印时出错: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 检查打印机状态
  Future<void> checkPrinterStatus() async {
    try {
      final status = await _printerService.getPrinterStatus();
      
      String statusText;
      switch (status.status) {
        case PrinterStatus.ready:
          statusText = '✅ 打印机就绪';
          break;
        case PrinterStatus.error:
          statusText = '❌ 打印机错误: ${status.message}';
          break;
        case PrinterStatus.warning:
          statusText = '⚠️ 打印机警告: ${status.message}';
          break;
        case PrinterStatus.unknown:
          statusText = '❓ 打印机状态未知';
          break;
      }

      Get.snackbar(
        '打印机状态',
        statusText,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '状态检查失败',
        '无法获取打印机状态: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 获取打印机调试日志
  List<String> getPrinterLogs() {
    return _printerService.debugLogs.toList();
  }

  /// 清除打印机日志
  void clearPrinterLogs() {
    _printerService.debugLogs.clear();
  }
}
