/// CartListView
/// 购物车列表视图

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/cashier_controller.dart';
import 'cart_empty_view.dart';
import 'cart_item_tile.dart';

class CartListView extends GetView<CashierController> {
  const CartListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cartItems.isEmpty) {
        return const CartEmptyView();
      }

      return Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return CartItemTile(
                  index: index + 1,
                  item: item,
                  isSelected: false,
                  onTap: () {},
                  onDelete: () => controller.removeFromCart(item.id),
                  onQuantityChange: (delta) => 
                      controller.updateQuantity(item.id, delta),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEEEEEE),
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              '#',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '商品名称',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 104.w,
            child: Text(
              '数量',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(width: 24.w),
          SizedBox(
            width: 80.w,
            child: Text(
              '价格(AED)',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
