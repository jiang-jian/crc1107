/// CashierPage
/// 收银台主页面 - 充值套餐选择与结账

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/cashier_controller.dart';
import '../widgets/cart/cart_list_view.dart';
import '../widgets/cart/discount_info_section.dart';
import '../widgets/cart/total_amount_bar.dart';
import '../widgets/payment/payment_method_selector.dart';
import '../widgets/payment/checkout_button.dart';
import '../widgets/package/package_list_view.dart';
import '../widgets/package/voucher_grid_view.dart';
import '../widgets/package/retail_grid_view.dart';
import '../widgets/package/clear_cart_button.dart';
import '../widgets/package/category_accordion.dart';

class CashierPage extends StatelessWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController(), permanent: false);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Row(
        children: [
          _buildCartSection(),
          _buildPackageSection(),
        ],
      ),
    );
  }

  Widget _buildCartSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F6),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '购物车',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const ClearCartButton(),
                ],
              ),
            ),
            Expanded(
              child: const CartListView(),
            ),
            const DiscountInfoSection(),
            const TotalAmountBar(),
            const PaymentMethodSelector(),
            const CheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageSection() {
    final controller = Get.find<CashierController>();
    
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // 只设置上左下左圆角
                borderRadius: BorderRadius.only( topLeft: Radius.circular(6.r), bottomLeft: Radius.circular(6.r))
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      final category = controller.selectedCategory.value;
                      final isVoucher = ['引流', '机台兑币', '刮刮卡', '市场活动']
                          .contains(category);
                      final isRetail = ['小食品', '饮料'].contains(category);
                      
                      if (isVoucher) {
                        return const VoucherGridView();
                      } else if (isRetail) {
                        return const RetailGridView();
                      } else {
                        return const PackageListView();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
          const CategoryAccordion(),
        ],
      ),
    );
  }
}
