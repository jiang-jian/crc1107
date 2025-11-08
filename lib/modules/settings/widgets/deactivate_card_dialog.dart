import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 注销技术卡对话框
class DeactivateCardDialog extends StatelessWidget {
  /// 选中的技术卡号
  final String cardNumber;
  
  /// 注销成功回调
  final Function(String cardNumber) onCardDeactivated;

  const DeactivateCardDialog({
    super.key,
    required this.cardNumber,
    required this.onCardDeactivated,
  });

  /// 提交注销（预留后端接口对接）
  void _handleSubmit(BuildContext context) {
    // 组织数据，准备调用后端接口
    final requestData = {
      'cardNumber': cardNumber,
    };
    
    // TODO: 后端接口对接
    // 示例代码（待后端接口开发完成后启用）：
    // try {
    //   final response = await ApiService.deactivateCard(requestData);
    //   if (response.success) {
    //     // 接口调用成功
    //     onCardDeactivated(cardNumber);
    //     Navigator.of(context).pop();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('技术卡注销成功！卡号：$cardNumber'),
    //         backgroundColor: const Color(0xFF4CAF50),
    //         behavior: SnackBarBehavior.floating,
    //       ),
    //     );
    //   } else {
    //     // 接口返回失败
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(response.message ?? '技术卡注销失败'),
    //         backgroundColor: const Color(0xFFE53935),
    //         behavior: SnackBarBehavior.floating,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   // 接口调用异常
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('网络错误：${e.toString()}'),
    //       backgroundColor: const Color(0xFFE53935),
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    // }
    
    // 临时方案：直接执行回调（演示效果）
    // 后端接口开发完成后，删除此段代码，启用上面的接口调用代码
    onCardDeactivated(cardNumber);
    Navigator.of(context).pop();
    
    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('技术卡注销成功！卡号：$cardNumber（临时演示，待对接后端）'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            _buildHeader(),
            
            // 内容区域
            _buildContent(),
            
            SizedBox(height: 24.h),
            
            // 操作按钮
            _buildActionButtons(context),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  /// 标题栏
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // 浅蓝色
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Text(
        '注销技术卡',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1976D2),
        ),
      ),
    );
  }

  /// 内容区域
  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 技术卡号（只读显示）
          _buildInfoField(
            label: '技术卡号',
            value: cardNumber,
          ),
          
          SizedBox(height: 20.h),
          
          // 警告图标和文字
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: const Color(0xFFFF9800),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '注销技术卡成功之后，不可对商户内一体机进行操作',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 信息字段（只读）
  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }

  /// 操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 取消按钮（白色背景，灰色文字）
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF999999),
                ),
              ),
              child: Text(
                '取消',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF999999),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // 确定按钮（黄色背景，黑色文字）
          GestureDetector(
            onTap: () => _handleSubmit(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107), // 黄色
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '确定',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
