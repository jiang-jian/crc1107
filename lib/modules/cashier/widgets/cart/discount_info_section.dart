/// DiscountInfoSection
/// 优惠信息展示区域

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/cashier_controller.dart';

class DiscountInfoSection extends GetView<CashierController> {
  const DiscountInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cartItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 227, 227),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            if (controller.discountAmount > 0)
              _buildDiscountItem('折扣优惠', controller.discountAmount),
            if (controller.packageDiscountAmount > 0)
              _buildDiscountItem('套餐优惠', controller.packageDiscountAmount),
            if (controller.couponAmount > 0)
              _buildDiscountItem('优惠券', controller.couponAmount),
          ],
        ),
      );
    });
  }

  Widget _buildDiscountItem(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          Text(
            '-AED ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFF4D4F),
            ),
          ),
        ],
      ),
    );
  }
}
