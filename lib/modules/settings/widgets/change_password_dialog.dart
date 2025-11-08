import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 修改密码对话框
class ChangePasswordDialog extends StatefulWidget {
  /// 选中的技术卡号
  final String cardNumber;
  
  /// 当前密码
  final String currentPassword;
  
  /// 修改成功回调
  final Function(String newPassword) onPasswordChanged;

  const ChangePasswordDialog({
    super.key,
    required this.cardNumber,
    required this.currentPassword,
    required this.onPasswordChanged,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 验证新密码
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入新密码';
    }
    if (value.length < 6) {
      return '密码长度至少6位';
    }
    if (value == widget.currentPassword) {
      return '新密码不能与旧密码相同';
    }
    return null;
  }

  /// 验证确认密码
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请再次输入新密码';
    }
    if (value != _newPasswordController.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  /// 提交修改（预留后端接口对接）
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // 组织数据，准备调用后端接口
      final requestData = {
        'cardNumber': widget.cardNumber,
        'oldPassword': widget.currentPassword,
        'newPassword': _newPasswordController.text,
      };
      
      // TODO: 后端接口对接
      // 示例代码（待后端接口开发完成后启用）：
      // try {
      //   final response = await ApiService.changePassword(requestData);
      //   if (response.success) {
      //     // 接口调用成功
      //     widget.onPasswordChanged(_newPasswordController.text);
      //     Navigator.of(context).pop();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('密码修改成功！卡号：${widget.cardNumber}'),
      //         backgroundColor: const Color(0xFF4CAF50),
      //         behavior: SnackBarBehavior.floating,
      //       ),
      //     );
      //   } else {
      //     // 接口返回失败
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(response.message ?? '密码修改失败'),
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
      
      // 临时方案：直接更新本地数据（演示效果）
      // 后端接口开发完成后，删除此段代码，启用上面的接口调用代码
      widget.onPasswordChanged(_newPasswordController.text);
      Navigator.of(context).pop();
      
      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('密码修改成功！卡号：${widget.cardNumber}（临时演示，待对接后端）'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
            // 标题栏（浅蓝色背景）
            _buildHeader(),
            
            // 表单内容
            _buildForm(),
            
            SizedBox(height: 24.h),
            
            // 操作按钮
            _buildActionButtons(),
            
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
        '修改密码',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1976D2),
        ),
      ),
    );
  }

  /// 表单内容
  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 技术卡号（只读显示）
            _buildInfoField(
              label: '技术卡号',
              value: widget.cardNumber,
            ),
            
            SizedBox(height: 20.h),
            
            // 旧密码（只读显示）
            _buildInfoField(
              label: '旧密码',
              value: widget.currentPassword,
            ),
            
            SizedBox(height: 20.h),
            
            // 新密码输入框
            _buildPasswordField(
              controller: _newPasswordController,
              label: '新密码',
              hint: '请输入新密码',
              obscureText: _obscureNewPassword,
              validator: _validateNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 确认新密码输入框
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: '确认新密码',
              hint: '请再次输入新密码',
              obscureText: _obscureConfirmPassword,
              validator: _validateConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ],
        ),
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

  /// 密码输入框
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required String? Function(String?) validator,
    required VoidCallback onToggleVisibility,
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF333333),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF999999),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFF1976D2),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 2,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
              onPressed: onToggleVisibility,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }

  /// 操作按钮
  Widget _buildActionButtons() {
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
            onTap: _handleSubmit,
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
