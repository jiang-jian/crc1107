/// CheckoutButton
/// 收银按钮

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/loading.dart';
import '../../controllers/cashier_controller.dart';

class CheckoutButton extends GetView<CashierController> {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCheckingOut = controller.isCheckingOut.value;
      final hasPaymentMethod = controller.selectedPaymentMethod.value != null;
      final hasItems = controller.cartItems.isNotEmpty;
      final isDisabled = isCheckingOut || !hasPaymentMethod || !hasItems;
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isDisabled ? null : () => _handleCheckout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: isCheckingOut
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    '收银',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    });
  }

  Future<void> _handleCheckout(BuildContext context) async {
    // 显示全局 Loading
    Loading.show(context: context, message: '正在处理支付...');

    try {
      await controller.checkout();
    } catch (e) {
      // 异常处理已在 controller 中完成
    } finally {
      // 无论成功或失败都关闭 loading
      Loading.hide();
    }
  }
}
