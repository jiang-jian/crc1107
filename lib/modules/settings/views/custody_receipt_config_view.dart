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
}
