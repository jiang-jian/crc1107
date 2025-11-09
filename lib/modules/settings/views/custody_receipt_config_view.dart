import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/custody_receipt_config_controller.dart';
import '../widgets/custody_receipt_config_form.dart';
import '../widgets/custody_receipt_preview.dart';

/// 托管小票配置页面
/// 提供双栏布局：左侧配置表单，右侧实时预览
class CustodyReceiptConfigView extends GetView<CustodyReceiptConfigController> {
  const CustodyReceiptConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('托管小票配置'),
        actions: [
          // 打印测试菜单
          PopupMenuButton<String>(
            icon: const Icon(Icons.print),
            tooltip: '打印测试',
            onSelected: (value) {
              switch (value) {
                case 'test_barcode':
                  controller.testPrintBarcode();
                  break;
                case 'test_receipt':
                  controller.testPrintReceipt();
                  break;
                case 'check_status':
                  controller.checkPrinterStatus();
                  break;
                case 'view_logs':
                  _showPrinterLogs(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test_barcode',
                child: Row(
                  children: [
                    Icon(Icons.qr_code, size: 20),
                    SizedBox(width: 12),
                    Text('测试条形码打印'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test_receipt',
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, size: 20),
                    SizedBox(width: 12),
                    Text('测试完整小票'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'check_status',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 12),
                    Text('检查打印机状态'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'view_logs',
                child: Row(
                  children: [
                    Icon(Icons.bug_report, size: 20),
                    SizedBox(width: 12),
                    Text('查看调试日志'),
                  ],
                ),
              ),
            ],
          ),
          // 重置按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重置为默认',
            onPressed: () => _showResetDialog(context),
          ),
          // 保存按钮
          Obx(() => IconButton(
                icon: controller.isSaving.value
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                tooltip: '保存配置',
                onPressed: controller.isSaving.value ? null : _saveTemplate,
              )),
          SizedBox(width: 16.w),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Row(
          children: [
            // 左侧：配置表单
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey[50],
                child: const CustodyReceiptConfigForm(),
              ),
            ),
            // 分割线
            VerticalDivider(
              width: 1.w,
              thickness: 1,
              color: Colors.grey[300],
            ),
            // 右侧：预览区域
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: const CustodyReceiptPreview(),
              ),
            ),
          ],
        );
      }),
      // 底部操作栏
      bottomNavigationBar: Obx(() {
        if (!controller.hasUnsavedChanges.value) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            border: Border(
              top: BorderSide(color: Colors.orange[200]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[700], size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                '您有未保存的修改',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showDiscardDialog(context),
                child: const Text('放弃修改'),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: _saveTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                ),
                child: const Text('保存'),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 保存模板
  void _saveTemplate() async {
    // 先验证
    if (!controller.validateTemplate()) {
      return;
    }

    // 保存
    final success = await controller.saveTemplate();
    if (success) {
      Get.snackbar(
        '成功',
        '模板配置已保存',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    }
  }

  /// 显示重置确认对话框
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置确认'),
        content: const Text('确定要重置为默认模板吗？这将丢失所有自定义配置。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetToDefault();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }

  /// 显示放弃修改确认对话框
  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃修改'),
        content: const Text('确定要放弃所有未保存的修改吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.discardChanges();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
  }

  /// 显示打印机调试日志
  void _showPrinterLogs(BuildContext context) {
    final logs = controller.getPrinterLogs();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600.w,
          height: 500.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bug_report),
                  SizedBox(width: 8.w),
                  const Text(
                    '打印机调试日志',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: '清除日志',
                    onPressed: () {
                      controller.clearPrinterLogs();
                      Navigator.of(context).pop();
                      Get.snackbar(
                        '已清除',
                        '打印机日志已清空',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              const Divider(),
              SizedBox(height: 16.h),
              Expanded(
                child: logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 48.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              '暂无日志记录',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                log,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12.sp,
                                  color: _getLogColor(log),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '共 ${logs.length} 条日志',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 根据日志内容返回颜色
  Color _getLogColor(String log) {
    if (log.contains('✓') || log.contains('成功') || log.contains('完成')) {
      return Colors.green[300]!;
    } else if (log.contains('✗') || log.contains('错误') || log.contains('失败')) {
      return Colors.red[300]!;
    } else if (log.contains('⚠️') || log.contains('警告')) {
      return Colors.orange[300]!;
    } else if (log.contains('步骤') || log.contains('====')) {
      return Colors.blue[300]!;
    }
    return Colors.grey[400]!;
  }
}
