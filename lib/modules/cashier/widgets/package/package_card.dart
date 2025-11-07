/// PackageCard
/// 充值套餐卡片

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/package_item.dart';

class PackageCard extends StatefulWidget {
  final PackageItem package;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: .95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if ((widget.package.stock ?? 1) > 0) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = (widget.package.stock ?? 1) == 0;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isOutOfStock ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isOutOfStock 
                ? Colors.grey.shade200 
                : AppTheme.packageBgColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isOutOfStock 
                  ? Colors.grey.shade300 
                  : AppTheme.packageBorderColor.withValues(alpha: .3),
              width: 1.w,
            ),
            boxShadow: isOutOfStock
                ? null
                : [
                    BoxShadow(
                      color: AppTheme.packageBorderColor.withValues(alpha: .15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.package.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isOutOfStock 
                              ? Colors.grey.shade500 
                              : AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.package.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isOutOfStock 
                              ? Colors.grey.shade400 
                              : Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'AED ${widget.package.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isOutOfStock 
                            ? Colors.grey.shade400 
                            : AppTheme.priceColor,
                      ),
                    ),
                    if (isOutOfStock)
                      Positioned(
                        left: -40.w,
                        child: SizedBox(
                          width: 68.w,
                          height: 68.w,
                          child: SvgPicture.asset(
                            'assets/images/soldOut.svg',
                            width: 68.w,
                            height: 68.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
