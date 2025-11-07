/// ClearCartButton
/// 清空购物车按钮

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_theme.dart';
import '../../controllers/cashier_controller.dart';

class ClearCartButton extends GetView<CashierController> {
  const ClearCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasItems = controller.cartItems.isNotEmpty;
      
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: hasItems ? 1.0 : .3,
        child: InkWell(
          onTap: hasItems ? () => _showClearConfirmDialog(context) : null,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: hasItems 
                  ? AppTheme.errorColor.withValues(alpha: .1) 
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: hasItems 
                    ? AppTheme.errorColor 
                    : Colors.grey.shade300,
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 16.w,
                  color: hasItems 
                      ? AppTheme.errorColor 
                      : Colors.grey.shade400,
                ),
                SizedBox(width: 4.w),
                Text(
                  '清空',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: hasItems 
                        ? AppTheme.errorColor 
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showClearConfirmDialog(BuildContext context) {
    final ctrl = Get.find<CashierController>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('确认清空', style: TextStyle(fontSize: 18.sp)),
        content: SizedBox(
          width: 400.w,
          child: Text('您确定要清空购物车吗?', style: TextStyle(fontSize: 14.sp)),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('取消', style: TextStyle(fontSize: 16.sp)),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('确定', style: TextStyle(fontSize: 16.sp)),
            onPressed: () {
              ctrl.clearCart();
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }
}
