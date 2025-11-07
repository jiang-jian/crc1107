import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/common_menu.dart';
import '../../controllers/cashier_controller.dart';

class CategoryAccordion extends StatelessWidget {
  const CategoryAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();

    final menuItems = [
      const MenuItem(
        key: 'game_coins',
        label: '游戏币',
        icon: Icons.monetization_on_outlined,
        children: [
          MenuItem(key: '游戏币套餐', label: '游戏币套餐', icon: Icons.circle),
          MenuItem(key: '超级币套餐', label: '超级币套餐', icon: Icons.circle),
        ],
      ),
      const MenuItem(
        key: 'vouchers',
        label: '兑换券',
        icon: Icons.card_giftcard_outlined,
        children: [
          MenuItem(key: '引流', label: '引流', icon: Icons.circle),
          MenuItem(key: '机台兑币', label: '机台兑币', icon: Icons.circle),
          MenuItem(key: '刮刮卡', label: '刮刮卡', icon: Icons.circle),
          MenuItem(key: '市场活动', label: '市场活动', icon: Icons.circle),
        ],
      ),
      const MenuItem(
        key: 'retail',
        label: '零售商品',
        icon: Icons.shopping_bag_outlined,
        children: [
          MenuItem(key: '小食品', label: '小食品', icon: Icons.circle),
          MenuItem(key: '饮料', label: '饮料', icon: Icons.circle),
        ],
      ),
    ];

    return Obx(
      () => CommonMenu(
        menuItems: menuItems,
        selectedKey: controller.selectedCategory.value,
        onItemSelected: (key) => controller.selectCategory(key),
        // backgroundColor: const Color(0xFF2B2E3A),
        width: 200.w,
      ),
    );
  }
}
