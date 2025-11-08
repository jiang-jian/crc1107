import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'add_technical_card_view.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/deactivate_card_dialog.dart';

class CardRegistrationView extends StatefulWidget {
  const CardRegistrationView({super.key});

  @override
  State<CardRegistrationView> createState() => _CardRegistrationViewState();
}

class _CardRegistrationViewState extends State<CardRegistrationView> {
  int _selectedIndex = 0; // 当前选中的行索引，默认选中第一行
  
  // 模拟数据（提升到 State 类级别，以便更新）
  List<Map<String, String>> _mockData = [
    {
      'cardNumber': '1001',
      'password': '123456',
      'operationTime': '2024-01-15 10:30:25',
      'operator': '张三',
    },
    {
      'cardNumber': '1002',
      'password': '654321',
      'operationTime': '2024-01-16 14:20:10',
      'operator': '李四',
    },
    {
      'cardNumber': '1003',
      'password': '111222',
      'operationTime': '2024-01-17 09:15:30',
      'operator': '王五',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 页面标题
          _buildHeader(),
          SizedBox(height: 24.h),
          
          // 技术卡登记表格
          Expanded(
            child: _buildDataTable(),
          ),
          
          SizedBox(height: 24.h),
          
          // 底部操作按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 页面标题
  Widget _buildHeader() {
    return Text(
      '技术卡登记',
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2C3E50),
      ),
    );
  }

  /// 数据表格
  Widget _buildDataTable() {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // 表头
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: _buildTableRow(
              isHeader: true,
              selected: false,
              cardNumber: '技术卡号',
              password: '密码',
              operationTime: '操作时间',
              operator: '操作人',
            ),
          ),
          
          // 分隔线
          Divider(height: 1.h, color: const Color(0xFFE0E0E0)),
          
          // 数据行
          Expanded(
            child: ListView.separated(
              itemCount: _mockData.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: const Color(0xFFE0E0E0),
              ),
              itemBuilder: (context, index) {
                final item = _mockData[index];
                return _buildTableRow(
                  isHeader: false,
                  selected: _selectedIndex == index, // 根据状态判断是否选中
                  cardNumber: item['cardNumber']!,
                  password: item['password']!,
                  operationTime: item['operationTime']!,
                  operator: item['operator']!,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index; // 更新选中行
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 表格行
  Widget _buildTableRow({
    required bool isHeader,
    required bool selected,
    required String cardNumber,
    required String password,
    required String operationTime,
    required String operator,
    VoidCallback? onTap,
  }) {
    final textStyle = TextStyle(
      fontSize: isHeader ? 16.sp : 15.sp,
      fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
      color: isHeader ? const Color(0xFF2C3E50) : const Color(0xFF333333),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: selected && !isHeader
            ? const Color(0xFFF0F8FF)
            : Colors.transparent,
        child: Row(
          children: [
            // 选择列
            SizedBox(
              width: 60.w,
              child: isHeader
                  ? Text('选择', style: textStyle)
                  : Radio<bool>(
                      value: true,
                      groupValue: selected,
                      onChanged: (value) {
                        onTap?.call();
                      },
                      activeColor: const Color(0xFF4CAF50),
                    ),
            ),
            
            // 技术卡号
            Expanded(
              flex: 2,
              child: Text(cardNumber, style: textStyle),
            ),
            
            // 密码
            Expanded(
              flex: 2,
              child: Text(password, style: textStyle),
            ),
            
            // 操作时间
            Expanded(
              flex: 3,
              child: Text(operationTime, style: textStyle),
            ),
            
            // 操作人
            Expanded(
              flex: 2,
              child: Text(operator, style: textStyle),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部操作按钮
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 添加技术卡按钮（绿色）
        _buildButton(
          label: '添加技术卡',
          backgroundColor: const Color(0xFF4CAF50),
          onPressed: () {
            // 跳转到添加技术卡页面
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTechnicalCardView(),
              ),
            );
          },
        ),
        
        SizedBox(width: 16.w),
        
        // 修改密码按钮（紫色渐变）
        _buildButton(
          label: '修改密码',
          gradient: const LinearGradient(
            colors: [
              Color(0xFF9C27B0),
              Color(0xFFE91E63),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onPressed: () {
            // 检查是否有选中的卡片
            if (_selectedIndex < 0 || _selectedIndex >= _mockData.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('请先选择要修改密码的技术卡'),
                  backgroundColor: Color(0xFFFF9800),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            
            // 获取选中的卡片数据
            final selectedCard = _mockData[_selectedIndex];
            
            // 显示修改密码对话框
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ChangePasswordDialog(
                cardNumber: selectedCard['cardNumber']!,
                currentPassword: selectedCard['password']!,
                onPasswordChanged: (newPassword) {
                  // 更新密码和操作时间
                  setState(() {
                    _mockData[_selectedIndex]['password'] = newPassword;
                    _mockData[_selectedIndex]['operationTime'] = 
                        DateTime.now().toString().substring(0, 19);
                    // TODO: 这里应该更新操作人为当前登录用户
                    // _mockData[_selectedIndex]['operator'] = currentUser;
                  });
                },
              ),
            );
          },
        ),
        
        SizedBox(width: 16.w),
        
        // 注销技术卡按钮（灰色）
        _buildButton(
          label: '注销',
          backgroundColor: const Color(0xFF9E9E9E),
          onPressed: () {
            // 检查是否有选中的卡片
            if (_selectedIndex < 0 || _selectedIndex >= _mockData.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('请先选择要注销的技术卡'),
                  backgroundColor: Color(0xFFFF9800),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            
            // 获取选中的卡片数据
            final selectedCard = _mockData[_selectedIndex];
            
            // 显示注销技术卡对话框
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DeactivateCardDialog(
                cardNumber: selectedCard['cardNumber']!,
                onCardDeactivated: (cardNumber) {
                  // 从列表中移除注销的卡片
                  setState(() {
                    _mockData.removeAt(_selectedIndex);
                    // 重置选中索引
                    if (_mockData.isNotEmpty) {
                      _selectedIndex = 0; // 默认选中第一行
                    } else {
                      _selectedIndex = -1; // 没有数据时重置为 -1
                    }
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// 通用按钮
  Widget _buildButton({
    required String label,
    Color? backgroundColor,
    Gradient? gradient,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 140.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
