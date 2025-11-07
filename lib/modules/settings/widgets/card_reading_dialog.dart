import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 读卡中弹窗
class CardReadingDialog extends StatefulWidget {
  const CardReadingDialog({super.key});

  @override
  State<CardReadingDialog> createState() => _CardReadingDialogState();
}

class _CardReadingDialogState extends State<CardReadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 创建动画控制器 - 2秒循环
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true); // 往返循环

    // 创建渐变动画 - 从 0.3 到 1.0
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE0E0E0),
                    width: 1.h,
                  ),
                ),
              ),
              child: Text(
                '读卡登记',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 32.h),

            // 读卡图标（可选）
            Icon(
              Icons.credit_card,
              size: 64.sp,
              color: const Color(0xFFE5B544),
            ),

            SizedBox(height: 24.h),

            // 动态文字 - 读卡登记中...
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        Color.lerp(
                          const Color(0xFF666666),
                          const Color(0xFF2C3E50),
                          _animation.value,
                        )!,
                        Color.lerp(
                          const Color(0xFF999999),
                          const Color(0xFF2C3E50),
                          _animation.value,
                        )!,
                      ],
                      stops: const [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '读卡登记中...',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // 必须设置，但会被 ShaderMask 覆盖
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            // 提示文字
            Text(
              '请勿移动卡片',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

/// 显示读卡中弹窗
void showCardReadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 不允许点击外部关闭
    barrierColor: Colors.black.withOpacity(0.5), // 半透明遮罩
    builder: (context) => const CardReadingDialog(),
  );
}

/// 关闭读卡中弹窗
void hideCardReadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
