import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/custody_receipt_config_controller.dart';

/// 托管小票预览组件
/// 实时显示小票打印效果
class CustodyReceiptPreview extends GetView<CustodyReceiptConfigController> {
  const CustodyReceiptPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 预览标题栏
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long, size: 20.sp, color: Colors.grey[700]),
              SizedBox(width: 8.w),
              Text(
                '实时预览',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: '刷新预览',
                iconSize: 20.sp,
                onPressed: () {
                  controller.template.refresh();
                },
              ),
            ],
          ),
        ),
        // 预览内容区域
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Center(
              child: _buildReceiptPreview(),
            ),
          ),
        ),
        // 底部操作栏
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              top: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('测试打印'),
                  onPressed: _testPrint,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建小票预览
  Widget _buildReceiptPreview() {
    return Obx(() {
      final paperWidth = controller.template.value.settings.paperWidth;
      final previewLines = controller.generatePreviewText();

      return Container(
        width: _calculatePreviewWidth(paperWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 热敏纸顶部效果
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
              ),
            ),
            // 小票内容
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: previewLines.map((line) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Text(
                      line,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 11.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // 热敏纸底部效果
            Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 计算预览宽度（根据纸张字符宽度）
  double _calculatePreviewWidth(int paperWidth) {
    // 每个字符约占 7 像素（等宽字体）
    const charWidth = 7.0;
    final contentWidth = paperWidth * charWidth;
    final padding = 32.0; // 左右 padding
    return contentWidth + padding;
  }

  /// 测试打印
  void _testPrint() {
    Get.dialog(
      AlertDialog(
        title: const Text('测试打印'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('请选择打印机类型：'),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('内置打印机'),
              subtitle: const Text('商米打印机'),
              onTap: () {
                Get.back();
                _printWithBuiltIn();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print_outlined),
              title: const Text('外置打印机'),
              subtitle: const Text('蓝牙/USB 打印机'),
              onTap: () {
                Get.back();
                _printWithExternal();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 使用内置打印机打印
  void _printWithBuiltIn() {
    Get.snackbar(
      '提示',
      '内置打印机打印功能待接入',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[900],
    );
    // TODO: 在第五步实现内置打印机适配器后，调用实际打印功能
  }

  /// 使用外置打印机打印
  void _printWithExternal() {
    Get.snackbar(
      '提示',
      '外置打印机打印功能待接入',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[900],
    );
    // TODO: 在第四步实现外置打印机适配器后，调用实际打印功能
  }
}
