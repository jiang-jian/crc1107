/// VoucherCard
/// 兑换券卡片 - 矩形网格布局

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/package_item.dart';

class VoucherCard extends StatefulWidget {
  final PackageItem package;
  final VoidCallback onTap;

  const VoucherCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard>
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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.package.validFrom != null &&
                        widget.package.validTo != null)
                      Text(
                        '有效期起止:${_formatDate(widget.package.validFrom!)} - ${_formatDate(widget.package.validTo!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isOutOfStock
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
