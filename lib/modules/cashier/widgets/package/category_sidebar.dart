/// CategorySidebar
/// 分类侧边栏

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/cashier_controller.dart';

class CategorySidebar extends StatelessWidget {
  const CategorySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();
    
    return Container(
      width: 120.w,
      decoration: const BoxDecoration(
        color: Color(0xFF2B2E3A),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return _buildCategoryItem(
              category, 
              isSelected, 
              controller,
            );
          });
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    String category, 
    bool isSelected,
    CashierController controller,
  ) {
    return InkWell(
      onTap: () => controller.selectCategory(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFB74D) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
