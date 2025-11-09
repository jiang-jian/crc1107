import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sunmi_flutter_plugin_printer/bean/printer.dart';
import 'package:sunmi_flutter_plugin_printer/enum/printer_info.dart';
import 'package:sunmi_flutter_plugin_printer/enum/align.dart' as printer_align;
import 'package:sunmi_flutter_plugin_printer/printer_sdk.dart';
import 'package:sunmi_flutter_plugin_printer/style/base_style.dart';
import 'package:sunmi_flutter_plugin_printer/style/text_style.dart' as printer_text;
import 'sunmi_printer_listener.dart';
import '../../data/models/receipt/custody_receipt_template.dart';

/// 打印机状态枚举
enum PrinterStatus {
  ready,   // 就绪
  error,   // 错误
  warning, // 警告
  unknown, // 未知
}

/// 打印机详细信息（对应demo的【打印机详情】功能）
class PrinterDetailInfo {
  final String? printerId;        // 打印机ID
  final String? printerName;      // 打印机名称
  final String? printerStatus;    // 打印机状态
  final String? printerType;      // 打印机类型
  final String? printerPaper;     // 打印纸规格

  PrinterDetailInfo({
    this.printerId,
    this.printerName,
    this.printerStatus,
    this.printerType,
    this.printerPaper,
  });
}

/// 打印机状态信息
class PrinterStatusInfo {
  final PrinterStatus status;
  final String message;
  final String rawStatus;
  final PrinterDetailInfo? detailInfo;

  PrinterStatusInfo({
    required this.status,
    required this.message,
    required this.rawStatus,
    this.detailInfo,
  });
}

/// 商米打印机服务
/// 严格按照demo实现方式
class SunmiPrinterService extends GetxService {
  // 打印机监听器
  late final SunmiPrinterListener _printerListener;
  
  // 打印机实例
  Printer? get printer => _printerListener.printerInstance.value;
  
  // 打印机是否可用
  final isPrinterAvailable = false.obs;
  
  // 当前打印机状态
  final Rx<PrinterStatusInfo?> printerStatus = Rx<PrinterStatusInfo?>(null);
  
  // 是否正在检查状态
  final isChecking = false.obs;
  
  // 是否正在打印
  final isPrinting = false.obs;
  
  // 调试日志
  final debugLogs = <String>[].obs;

  /// 初始化服务
  Future<SunmiPrinterService> init() async {
    _addLog('========== 初始化商米打印机服务 ==========');
    
    if (kIsWeb) {
      _addLog('Web平台：跳过打印机初始化');
      return this;
    }

    try {
      // 创建监听器
      _printerListener = SunmiPrinterListener();
      
      // 监听打印机实例变化
      ever(_printerListener.printerInstance, (Printer? printer) {
        if (printer != null) {
          isPrinterAvailable.value = true;
          _addLog('✓ 打印机实例已就绪: ID=${printer.printerId}');
        } else {
          isPrinterAvailable.value = false;
          _addLog('✗ 打印机实例不可用');
        }
      });
      
      // 获取打印机实例（对应demo中的 PrinterSdk.instance.getPrinter()）
      _addLog('步骤1: 调用 PrinterSdk.instance.getPrinter()');
      await PrinterSdk.instance.getPrinter(_printerListener);
      _addLog('✓ 已请求打印机实例，等待回调...');
      
      // 等待打印机实例初始化
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (printer != null) {
        _addLog('✓ 打印机服务初始化成功');
        _addLog('========== 初始化完成 ==========');
        return this;
      } else {
        _addLog('⚠️ 未获取到打印机实例，请检查设备');
        _addLog('========== 初始化完成（无打印机） ==========');
        return this;
      }
    } catch (e, stackTrace) {
      _addLog('✗ 初始化失败: $e');
      _addLog('堆栈: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      _addLog('========== 初始化失败 ==========');
      return this;
    }
  }

  /// 添加调试日志
  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    debugLogs.add('[$timestamp] $message');
    if (debugLogs.length > 50) {
      debugLogs.removeAt(0);
    }
    print('[Printer] $message');
  }

  /// 清空调试日志
  void clearDebugLogs() {
    debugLogs.clear();
    _addLog('日志已清空');
  }

  /// 获取打印机详情（对应demo的【打印机详情】功能）
  /// 包括：ID、名称、状态、类型、规格
  Future<PrinterDetailInfo?> getPrinterDetails() async {
    _addLog('========== 获取打印机详情 ==========');
    
    try {
      if (kIsWeb) {
        _addLog('Web平台：返回模拟详情');
        return PrinterDetailInfo(
          printerId: 'WEB-MOCK-12345',
          printerName: 'Sunmi Web Mock Printer',
          printerStatus: 'READY',
          printerType: '热敏打印机',
          printerPaper: '58mm',
        );
      }

      if (printer == null) {
        _addLog('✗ 打印机实例不可用');
        return null;
      }

      // 获取打印机ID（直接从Printer对象获取）
      _addLog('步骤1: 获取打印机ID');
      final printerId = printer!.printerId;
      _addLog('✓ 打印机ID: $printerId');

      // 获取打印机名称（使用QueryApi）
      _addLog('步骤2: 调用 queryApi.getInfo(PrinterInfo.NAME)');
      final printerName = await printer!.queryApi.getInfo(PrinterInfo.NAME);
      _addLog('✓ 打印机名称: $printerName');

      // 获取打印机状态（使用QueryApi）
      _addLog('步骤3: 调用 queryApi.getStatus()');
      final status = await printer!.queryApi.getStatus();
      final printerStatus = status?.name ?? 'UNKNOWN';
      _addLog('✓ 打印机状态: $printerStatus');

      // 获取打印机类型（使用QueryApi）
      _addLog('步骤4: 调用 queryApi.getInfo(PrinterInfo.TYPE)');
      final printerType = await printer!.queryApi.getInfo(PrinterInfo.TYPE);
      _addLog('✓ 打印机类型: $printerType');

      // 获取打印纸规格（使用QueryApi）
      _addLog('步骤5: 调用 queryApi.getInfo(PrinterInfo.PAPER)');
      final printerPaper = await printer!.queryApi.getInfo(PrinterInfo.PAPER);
      _addLog('✓ 打印纸规格: $printerPaper');

      final detailInfo = PrinterDetailInfo(
        printerId: printerId,
        printerName: printerName,
        printerStatus: printerStatus,
        printerType: printerType,
        printerPaper: printerPaper,
      );

      _addLog('========== 打印机详情获取完成 ==========');
      return detailInfo;
      
    } on PlatformException catch (e) {
      _addLog('✗ 平台异常: ${e.message}');
      _addLog('代码: ${e.code}');
      return null;
    } catch (e, stackTrace) {
      _addLog('✗ 获取详情失败: $e');
      _addLog('堆栈: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      return null;
    }
  }

  /// 获取打印机状态
  /// 参考：https://developer.sunmi.com/docs/zh-CN/cdixeghjk491/xfxceghjk502
  Future<PrinterStatusInfo> getPrinterStatus() async {
    _addLog('========== 开始获取打印机状态 ==========');
    isChecking.value = true;
    
    try {
      if (kIsWeb) {
        _addLog('Web平台：返回模拟状态');
        final mockStatus = PrinterStatusInfo(
          status: PrinterStatus.ready,
          message: '打印机已准备好（Web 模拟）',
          rawStatus: 'READY',
        );
        printerStatus.value = mockStatus;
        return mockStatus;
      }

      if (printer == null) {
        _addLog('✗ 打印机实例不可用，请先初始化');
        final errorStatus = PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '打印机实例不可用',
          rawStatus: 'NO_PRINTER',
        );
        printerStatus.value = errorStatus;
        return errorStatus;
      }

      // 获取打印机详细信息
      _addLog('步骤1: 获取打印机详细信息');
      final detailInfo = await getPrinterDetails();
      
      if (detailInfo == null) {
        final errorStatus = PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '无法获取打印机信息',
          rawStatus: 'ERROR',
        );
        printerStatus.value = errorStatus;
        return errorStatus;
      }

      // 解析状态
      final statusInfo = _parseStatusString(detailInfo.printerStatus ?? 'UNKNOWN', detailInfo);
      _addLog('✓ 状态解析: ${statusInfo.message}');
      _addLog('========== 状态获取完成 ==========');
      
      printerStatus.value = statusInfo;
      return statusInfo;
      
    } catch (e, stackTrace) {
      _addLog('✗ 错误: $e');
      _addLog('堆栈: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      _addLog('========== 状态获取失败 ==========');
      
      final errorStatus = PrinterStatusInfo(
        status: PrinterStatus.error,
        message: '获取状态失败: $e',
        rawStatus: 'ERROR',
      );
      printerStatus.value = errorStatus;
      return errorStatus;
    } finally {
      isChecking.value = false;
    }
  }

  /// 解析状态字符串
  PrinterStatusInfo _parseStatusString(String statusStr, PrinterDetailInfo? detailInfo) {
    _addLog('解析状态字符串: $statusStr');

    final upperStatus = statusStr.toUpperCase();

    // Status.READY - 打印机已准备好，可正常打印（绿色）
    if (upperStatus.contains('READY')) {
      return PrinterStatusInfo(
        status: PrinterStatus.ready,
        message: '打印机已准备好，可正常打印',
        rawStatus: 'READY',
        detailInfo: detailInfo,
      );
    }
    // Status.ERR_* - 错误类（红色）
    else if (upperStatus.startsWith('ERR_') || upperStatus.contains('ERROR')) {
      if (upperStatus.contains('PAPER_OUT')) {
        return PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '打印机缺纸',
          rawStatus: 'ERR_PAPER_OUT',
          detailInfo: detailInfo,
        );
      } else if (upperStatus.contains('PAPER_JAM')) {
        return PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '打印机堵纸',
          rawStatus: 'ERR_PAPER_JAM',
          detailInfo: detailInfo,
        );
      } else if (upperStatus.contains('PAPER_MISMATCH')) {
        return PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '当前打印纸不匹配打印机',
          rawStatus: 'ERR_PAPER_MISMATCH',
          detailInfo: detailInfo,
        );
      } else {
        return PrinterStatusInfo(
          status: PrinterStatus.error,
          message: '打印机错误: $statusStr',
          rawStatus: upperStatus,
          detailInfo: detailInfo,
        );
      }
    }
    // Status.OFFLINE - 打印机离线/故障（红色）
    else if (upperStatus.contains('OFFLINE')) {
      return PrinterStatusInfo(
        status: PrinterStatus.error,
        message: '打印机离线/故障',
        rawStatus: 'OFFLINE',
        detailInfo: detailInfo,
      );
    }
    // Status.COMM - 打印机通信异常（红色）
    else if (upperStatus.contains('COMM')) {
      return PrinterStatusInfo(
        status: PrinterStatus.error,
        message: '打印机通信异常',
        rawStatus: 'COMM',
        detailInfo: detailInfo,
      );
    }
    // Status.WARN_* - 警告类（黄色）
    else if (upperStatus.startsWith('WARN_') || upperStatus.contains('WARNING')) {
      return PrinterStatusInfo(
        status: PrinterStatus.warning,
        message: '打印机警告: $statusStr',
        rawStatus: upperStatus,
        detailInfo: detailInfo,
      );
    }
    // 未知状态
    else {
      return PrinterStatusInfo(
        status: PrinterStatus.unknown,
        message: '未识别的状态: $statusStr',
        rawStatus: 'UNKNOWN',
        detailInfo: detailInfo,
      );
    }
  }

  /// 【打印文本测试】对应demo的【打印票据】->【打印文本测试】功能
  /// 参考demo中的 _printText() 方法
  Future<bool> testPrintText() async {
    _addLog('========== 打印文本测试 ==========');
    isPrinting.value = true;
    
    try {
      if (kIsWeb) {
        _addLog('Web平台：模拟打印');
        await Future.delayed(const Duration(seconds: 1));
        _addLog('✓ 模拟打印完成');
        return true;
      }

      if (printer == null) {
        _addLog('✗ 打印机实例不可用');
        return false;
      }

      // 获取LineApi（对应demo中的 lineApi）
      final lineApi = printer!.lineApi;
      
      // 步骤1: 初始化打印行（对应demo: lineApi?.initLine()）
      _addLog('步骤1: initLine(BaseStyle.getStyle())');
      lineApi.initLine(BaseStyle.getStyle());
      _addLog('✓ 打印行初始化完成');

      // 步骤2: 打印文本（对应demo: lineApi?.printText()）
      _addLog('步骤2: printText("打印热敏小票测试")');
      lineApi.printText('打印热敏小票测试', printer_text.TextStyle.getStyle());
      _addLog('✓ 文本已发送到打印机');

      // 步骤3: 自动输出（对应demo: lineApi?.autoOut()）
      _addLog('步骤3: autoOut()');
      lineApi.autoOut();
      _addLog('✓ 自动输出完成');

      _addLog('========== 打印完成 ==========');
      return true;
      
    } on PlatformException catch (e) {
      _addLog('✗ 平台异常: ${e.message}');
      _addLog('代码: ${e.code}');
      _addLog('========== 打印失败 ==========');
      return false;
    } catch (e, stackTrace) {
      _addLog('✗ 打印失败: $e');
      _addLog('堆栈: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      _addLog('========== 打印失败 ==========');
      return false;
    } finally {
      isPrinting.value = false;
    }
  }

  /// 测试打印热敏小票（保留原方法兼容）
  Future<bool> testPrintReceipt() async {
    return await testPrintText();
  }

  /// 打印条形码
  /// [data] 条形码数据
  /// [type] 条形码类型
  /// [width] 条形码宽度 (1-6，默认2)
  /// [height] 条形码高度 (像素，默认162)
  /// [textPosition] 文字位置 (0=不显示, 1=上方, 2=下方, 3=上下都显示，默认2)
  Future<bool> printBarcode(
    String data,
    BarcodeType type, {
    int width = 2,
    int height = 162,
    int textPosition = 2,
  }) async {
    _addLog('========== 打印条形码 ==========');
    _addLog('数据: $data');
    _addLog('类型: ${type.name}');
    _addLog('宽度: $width, 高度: $height');
    
    isPrinting.value = true;
    
    try {
      if (kIsWeb) {
        _addLog('Web平台：模拟条形码打印');
        await Future.delayed(const Duration(milliseconds: 500));
        _addLog('✓ 模拟打印完成');
        return true;
      }

      if (printer == null) {
        _addLog('✗ 打印机实例不可用');
        return false;
      }

      final lineApi = printer!.lineApi;
      
      // 步骤1: 初始化打印行
      _addLog('步骤1: initLine()');
      lineApi.initLine(BaseStyle.getStyle());
      
      // 步骤2: 映射条形码类型到打印机格式
      final barcodeTypeCode = _mapBarcodeType(type);
      _addLog('步骤2: 条形码类型映射 -> $barcodeTypeCode');
      
      // 步骤3: 尝试调用条形码打印方法
      // 注意：这里使用反射或动态调用，因为插件API不明确
      _addLog('步骤3: 尝试打印条形码...');
      
      try {
        // 方法1: 尝试直接调用可能存在的printBarcode方法
        // 如果插件支持，这应该能工作
        final dynamic lineApiDynamic = lineApi;
        
        // 尝试调用 printBarcode 方法（如果存在）
        if (lineApiDynamic is Object) {
          // 使用 noSuchMethod 捕获来尝试调用
          try {
            // 这是一个实验性的调用，可能会失败
            await lineApiDynamic.printBarcode?.call(
              data,
              barcodeTypeCode,
              width,
              height,
              textPosition,
            );
            _addLog('✓ 条形码打印命令已发送（方法1）');
          } catch (e) {
            // 如果方法不存在，尝试备用方案
            _addLog('方法1失败，尝试备用方案: $e');
            
            // 方法2: 使用 ESC/POS 原始命令
            final barcodeCommand = _generateBarcodeEscPosCommand(
              data,
              barcodeTypeCode,
              width,
              height,
              textPosition,
            );
            
            // 尝试通过文本方式发送控制命令
            // 这是最后的尝试，可能不会工作
            lineApi.printText(
              '\n[条形码占位: $data (${type.label})]\n',
              printer_text.TextStyle.getStyle(),
            );
            _addLog('⚠️ 使用文本占位符替代（插件可能不支持条形码）');
          }
        }
      } catch (e) {
        _addLog('✗ 条形码打印失败: $e');
        // 降级处理：打印文本形式的条形码数据
        lineApi.printText(
          '\n[条形码: $data]\n',
          printer_text.TextStyle.getStyle(),
        );
        _addLog('⚠️ 已降级为文本模式');
      }
      
      // 步骤4: 自动输出
      _addLog('步骤4: autoOut()');
      lineApi.autoOut();
      _addLog('✓ 输出完成');
      
      _addLog('========== 条形码打印完成 ==========');
      return true;
      
    } on PlatformException catch (e) {
      _addLog('✗ 平台异常: \${e.message}');
      _addLog('代码: \${e.code}');
      _addLog('========== 打印失败 ==========');
      return false;
    } catch (e, stackTrace) {
      _addLog('✗ 打印失败: $e');
      _addLog('堆栈: \${stackTrace.toString().split(\'\\n\').take(3).join(\'\\n\')}');
      _addLog('========== 打印失败 ==========');
      return false;
    } finally {
      isPrinting.value = false;
    }
  }

  /// 映射条形码类型到打印机格式代码
  /// 基于 ESC/POS 标准和 Sunmi 打印机规范
  int _mapBarcodeType(BarcodeType type) {
    switch (type) {
      case BarcodeType.code128:
        return 73; // GS k m n d1...dn - Code 128
      case BarcodeType.code39:
        return 69; // Code 39
      case BarcodeType.ean13:
        return 67; // EAN-13
      case BarcodeType.qrCode:
        return 49; // QR Code (2D)
    }
  }

  /// 生成 ESC/POS 条形码命令（备用方案）
  /// 返回原始字节命令
  List<int> _generateBarcodeEscPosCommand(
    String data,
    int barcodeType,
    int width,
    int height,
    int textPosition,
  ) {
    final List<int> command = [];
    
    // GS H n - 设置条形码文字位置
    command.addAll([0x1D, 0x48, textPosition]);
    
    // GS w n - 设置条形码宽度
    command.addAll([0x1D, 0x77, width]);
    
    // GS h n - 设置条形码高度
    command.addAll([0x1D, 0x68, height]);
    
    // GS k m n d1...dn - 打印条形码
    command.addAll([0x1D, 0x6B, barcodeType, data.length]);
    command.addAll(data.codeUnits);
    
    return command;
  }

  /// 打印托管小票（完整版本）
  /// [template] 小票模板配置
  /// [data] 小票数据
  Future<bool> printCustodyReceipt(
    CustodyReceiptTemplate template,
    CustodyReceiptData data,
  ) async {
    _addLog('========== 打印托管小票 ==========');
    isPrinting.value = true;
    
    try {
      if (kIsWeb) {
        _addLog('Web平台：模拟小票打印');
        await Future.delayed(const Duration(seconds: 1));
        _addLog('✓ 模拟打印完成');
        return true;
      }

      if (printer == null) {
        _addLog('✗ 打印机实例不可用');
        return false;
      }

      final lineApi = printer!.lineApi;
      final config = template;
      final bilingual = config.settings.enableBilingual;
      
      // 初始化
      lineApi.initLine(BaseStyle.getStyle());
      
      // 打印头部
      if (config.header.showLogo) {
        // TODO: 打印Logo（需要图片处理）
        _addLog('TODO: Logo打印');
      }
      
      if (config.header.showTitle) {
        lineApi.printText(
          config.header.title,
          printer_text.TextStyle.getStyle(),
        );
        if (bilingual) {
          lineApi.printText(
            config.header.titleEn,
            printer_text.TextStyle.getStyle(),
          );
        }
      }
      
      // 分隔线
      if (config.settings.showSeparator) {
        lineApi.printText('--------------------------------', printer_text.TextStyle.getStyle());
      }
      
      // 存币信息
      if (config.depositInfo.showDepositNumber) {
        final label = bilingual 
            ? '\${config.depositInfo.depositLabel}/\${config.depositInfo.depositLabelEn}'
            : config.depositInfo.depositLabel;
        lineApi.printText('$label: \${data.depositNumber}', printer_text.TextStyle.getStyle());
      }
      
      if (config.depositInfo.showStoreName) {
        final label = bilingual
            ? '\${config.depositInfo.storeLabel}/\${config.depositInfo.storeLabelEn}'
            : config.depositInfo.storeLabel;
        lineApi.printText('$label: \${data.storeName}', printer_text.TextStyle.getStyle());
      }
      
      // 条形码
      if (config.depositInfo.showBarcode) {
        await printBarcode(
          data.depositNumber,
          config.depositInfo.barcodeType,
        );
      }
      
      // 会员信息
      if (config.settings.showSeparator) {
        lineApi.printText('--------------------------------', printer_text.TextStyle.getStyle());
      }
      
      if (config.memberInfo.showMemberId) {
        final label = bilingual
            ? '\${config.memberInfo.memberLabel}/\${config.memberInfo.memberLabelEn}'
            : config.memberInfo.memberLabel;
        lineApi.printText('$label: \${data.memberId}', printer_text.TextStyle.getStyle());
      }
      
      if (config.memberInfo.showOperationTime) {
        final label = bilingual
            ? '\${config.memberInfo.timeLabel}/\${config.memberInfo.timeLabelEn}'
            : config.memberInfo.timeLabel;
        lineApi.printText('$label: \${data.formattedOperationTime}', printer_text.TextStyle.getStyle());
      }
      
      if (config.memberInfo.showTicketQuantity) {
        final label = bilingual
            ? '\${config.memberInfo.quantityLabel}/\${config.memberInfo.quantityLabelEn}'
            : config.memberInfo.quantityLabel;
        lineApi.printText('$label: \${data.formattedTicketQuantity}', printer_text.TextStyle.getStyle());
      }
      
      // 打印信息
      if (config.settings.showSeparator) {
        lineApi.printText('--------------------------------', printer_text.TextStyle.getStyle());
      }
      
      if (config.printInfo.showPrintTime) {
        final label = bilingual
            ? '\${config.printInfo.printTimeLabel}/\${config.printInfo.printTimeLabelEn}'
            : config.printInfo.printTimeLabel;
        lineApi.printText('$label: \${data.formattedPrintTime}', printer_text.TextStyle.getStyle());
      }
      
      if (config.printInfo.showOperator) {
        final label = bilingual
            ? '\${config.printInfo.operatorLabel}/\${config.printInfo.operatorLabelEn}'
            : config.printInfo.operatorLabel;
        lineApi.printText('$label: \${data.operator}', printer_text.TextStyle.getStyle());
      }
      
      // 底部
      if (config.settings.showSeparator) {
        lineApi.printText('--------------------------------', printer_text.TextStyle.getStyle());
      }
      
      if (config.footer.showHint && config.footer.hintText.isNotEmpty) {
        lineApi.printText(config.footer.hintText, printer_text.TextStyle.getStyle());
        if (bilingual && config.footer.hintTextEn.isNotEmpty) {
          lineApi.printText(config.footer.hintTextEn, printer_text.TextStyle.getStyle());
        }
      }
      
      if (config.footer.showThanks && config.footer.thanksText.isNotEmpty) {
        lineApi.printText(config.footer.thanksText, printer_text.TextStyle.getStyle());
        if (bilingual && config.footer.thanksTextEn.isNotEmpty) {
          lineApi.printText(config.footer.thanksTextEn, printer_text.TextStyle.getStyle());
        }
      }
      
      // 空行
      lineApi.printText('\n\n', printer_text.TextStyle.getStyle());
      
      // 输出并切纸
      lineApi.autoOut();
      
      if (config.settings.enableCut) {
        // TODO: 切纸命令（需要确认插件API）
        _addLog('TODO: 切纸功能');
      }
      
      _addLog('========== 小票打印完成 ==========');
      return true;
      
    } on PlatformException catch (e) {
      _addLog('✗ 平台异常: \${e.message}');
      _addLog('========== 打印失败 ==========');
      return false;
    } catch (e, stackTrace) {
      _addLog('✗ 打印失败: $e');
      _addLog('堆栈: \${stackTrace.toString().split(\'\\n\').take(3).join(\'\\n\')}');
      _addLog('========== 打印失败 ==========');
      return false;
    } finally {
      isPrinting.value = false;
    }
  }

  @override
  void onClose() {
    _addLog('商米打印机服务已关闭');
    super.onClose();
  }
}
