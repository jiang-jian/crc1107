/// PaymentMethodSelector
/// 支付方式选择器

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_theme.dart';
import '../../controllers/cashier_controller.dart';

class PaymentMethodSelector extends GetView<CashierController> {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: _buildPaymentButton(
                label: '刷卡',
                icon: Icons.credit_card,
                method: PaymentMethod.card,
                isSelected: controller.selectedPaymentMethod.value == 
                    PaymentMethod.card,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildPaymentButton(
                label: '现金',
                icon: Icons.payments_outlined,
                method: PaymentMethod.cash,
                isSelected: controller.selectedPaymentMethod.value == 
                    PaymentMethod.cash,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaymentButton({
    required String label,
    required IconData icon,
    required PaymentMethod method,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => controller.selectPaymentMethod(method),
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withValues(alpha: .1) 
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor 
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28.w,
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : Colors.grey.shade600,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
