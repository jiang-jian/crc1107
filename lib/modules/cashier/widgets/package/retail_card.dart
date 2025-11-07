/// RetailCard
/// 零售商品卡片 - 横向布局

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/package_item.dart';

class RetailCard extends StatefulWidget {
  final PackageItem package;
  final VoidCallback onTap;

  const RetailCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  State<RetailCard> createState() => _RetailCardState();
}

class _RetailCardState extends State<RetailCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: .98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if ((widget.package.stock ?? 0) > 0) {
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
    final isOutOfStock = widget.package.isSoldOut || (widget.package.stock ?? 0) == 0;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isOutOfStock ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isOutOfStock 
                    ? Colors.grey.shade200 
                    : AppTheme.packageBgColor,
                borderRadius: BorderRadius.circular(8.r),
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
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: widget.package.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.network(
                            widget.package.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fastfood,
                                size: 40.w,
                                color: Colors.grey.shade400,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.fastfood,
                          size: 40.w,
                          color: Colors.grey.shade400,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.package.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isOutOfStock
                                    ? Colors.grey.shade500
                                    : AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.package.specification != null)
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Text(
                                '规格: ${widget.package.specification}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isOutOfStock
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '库存: ${widget.package.stock ?? 0}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isOutOfStock
                                  ? Colors.grey.shade400
                                  : (widget.package.stock ?? 0) < 10
                                      ? Colors.orange
                                      : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'AED ${widget.package.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock
                                  ? Colors.grey.shade400
                                  : AppTheme.priceColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isOutOfStock)
          Positioned.fill(
            child: Center(
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
          ),
      ],
    ),
      ),
    );
  }
}
