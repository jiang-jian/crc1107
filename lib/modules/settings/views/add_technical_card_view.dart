import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/services/external_card_reader_service.dart';
import '../../../data/models/external_card_reader_model.dart';
import '../widgets/card_reading_dialog.dart';
import '../widgets/card_reading_failure_dialog.dart';
import '../widgets/card_reading_success_dialog.dart';

class AddTechnicalCardView extends StatefulWidget {
  const AddTechnicalCardView({super.key});

  @override
  State<AddTechnicalCardView> createState() => _AddTechnicalCardViewState();
}

class _AddTechnicalCardViewState extends State<AddTechnicalCardView> with SingleTickerProviderStateMixin {
  late final TextEditingController _cardNumberController;
  late final ExternalCardReaderService _service;
  String? _lastCardUid; // 记录上次填充的卡号，避免重复填充
  bool _isDialogShowing = false; // 记录弹窗是否正在显示
  bool _hasProcessedSuccess = false; // 记录是否已处理成功状态，避免重复处理
  bool _isManualReading = false; // 标记是否为手动读卡（区分自动轮询和手动读卡）
  
  // 动画控制器（用于紫色渐变呼吸效果）
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    
    // 初始化动画控制器（紫色渐变呼吸效果）
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _shimmerAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
    
    // 获取或创建服务
    try {
      _service = Get.find<ExternalCardReaderService>();
    } catch (e) {
      _service = Get.put(ExternalCardReaderService());
      _service.init();
    }

    // 🔧 已移除自动读卡弹窗逻辑
    // 自动读卡（后台轮询）不应该显示弹窗，只在UI上显示实时状态
    // 弹窗只在手动触发读卡时显示（如果将来需要手动读卡功能）

    // 监听卡片数据变化，处理读卡成功
    ever(_service.cardData, (cardData) {
      if (mounted && 
          cardData != null && 
          cardData['isValid'] == true && 
          !_hasProcessedSuccess) {
        // 标记已处理，避免重复
        _hasProcessedSuccess = true;
        
        final cardUid = cardData['uid'];
        if (cardUid != null && cardUid != 'Unknown') {
          // 🔧 直接填充卡号，不显示成功弹窗（避免干扰用户操作）
          // 自动读卡成功后，只需要填充输入框即可
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _cardNumberController.text != cardUid) {
              _cardNumberController.text = cardUid;
              _lastCardUid = cardUid;
              // 重置成功标志，允许下次读卡
              Future.delayed(const Duration(seconds: 1), () {
                _hasProcessedSuccess = false;
              });
            }
          });
        }
      }
    });

    // 监听错误状态（自动读卡的错误会在页面内显示，不需要弹窗）
    ever(_service.lastError, (error) {
      if (mounted && error != null) {
        // 🔧 错误信息会在页面内的实时状态区域显示
        // 不需要弹窗，避免干扰用户操作
        // 自动重置错误状态，允许继续读卡
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _service.lastError.value = null;
            _hasProcessedSuccess = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF2C3E50), size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '添加技术卡',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 3,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 读卡器类型
                _buildCardReaderType(),
                
                SizedBox(height: 32.h),
                
                // 2. 读卡器状态
                _buildCardReaderStatus(),
                
                SizedBox(height: 32.h),
                
                // 3. 卡面卡号
                _buildCardNumberInput(),
              ],
            ),
          ),
        ),
      );
    );
  }

  /// 1. 读卡器类型部分
  Widget _buildCardReaderType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel('读卡器类型'),
        SizedBox(height: 12.h),
        
        // 只显示一种类型：感应式IC卡（M1芯片）
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.radio_button_checked,
                color: const Color(0xFF4CAF50),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                '感应式IC卡（M1芯片）',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 2. 读卡器状态部分
  Widget _buildCardReaderStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel('读卡器状态'),
        SizedBox(height: 12.h),
        
        Obx(() {
          final selectedDevice = _service.selectedReader.value;
          final isConnected = selectedDevice != null;
          final isScanning = _service.isScanning.value;
          
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                // 状态指示器
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // 状态文字
                Text(
                  isConnected ? '已连接就绪' : '未连接',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isConnected
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const Spacer(),
                
                // 连接/刷新按钮
                if (!isConnected)
                  // 未连接时显示黄色文字按钮
                  TextButton(
                    onPressed: isScanning ? null : () => _service.scanUsbReaders(),
                    child: Text(
                      isScanning ? '扫描中...' : '连接读卡器',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isScanning
                            ? const Color(0xFF999999)
                            : const Color(0xFFE5B544),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  // 已连接时显示刷新图标按钮
                  IconButton(
                    onPressed: isScanning ? null : () => _service.scanUsbReaders(),
                    icon: Icon(
                      Icons.refresh,
                      color: isScanning
                          ? const Color(0xFF999999)
                          : const Color(0xFFE5B544),
                      size: 24.sp,
                    ),
                  ),
              ],
            ),
          );
        }),
        
        // 设备信息（如果已连接）
        Obx(() {
          final selectedDevice = _service.selectedReader.value;
          if (selectedDevice != null) {
            return Container(
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.usb,
                    size: 18.sp,
                    color: const Color(0xFF4CAF50),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      selectedDevice.displayName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        
        // 紫色渐变动态提示（放置在读卡器状态区域底部）
        Obx(() {
          final selectedDevice = _service.selectedReader.value;
          final isReading = _service.isReading.value;
          final cardData = _service.cardData.value;
          final lastError = _service.lastError.value;
          
          // 只在已连接、未读卡、无错误、无数据时显示
          if (selectedDevice != null && !isReading && cardData == null && lastError == null) {
            return AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.only(top: 16.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF9C27B0).withOpacity(_shimmerAnimation.value * 0.15),
                        Color(0xFFE1BEE7).withOpacity(_shimmerAnimation.value * 0.25),
                        Color(0xFF9C27B0).withOpacity(_shimmerAnimation.value * 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFF9C27B0).withOpacity(_shimmerAnimation.value * 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 20.sp,
                        color: Color(0xFF9C27B0).withOpacity(_shimmerAnimation.value),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          '请将技术卡放置在读卡器上，系统将自动读取卡号',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF6A1B9A).withOpacity(_shimmerAnimation.value),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// 3. 卡面卡号输入部分
  Widget _buildCardNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel('卡面卡号'),
        SizedBox(height: 12.h),
        
        Row(
          children: [
            // 输入框 - 监听卡片数据变化
            Expanded(
              child: Obx(() {
                final cardData = _service.cardData.value;
                final cardUid = cardData?['uid'];
                
                // 自动填充卡号逻辑
                if (cardUid != null && 
                    cardUid != 'Unknown' && 
                    cardUid != _lastCardUid) {
                  // 使用 WidgetsBinding 在下一帧更新，避免在 build 中直接修改
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _cardNumberController.text = cardUid;
                    _lastCardUid = cardUid;
                  });
                }
                
                return TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    hintText: '请输入卡面卡号',
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF999999),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF333333),
                  ),
                );
              }),
            ),
            
            SizedBox(width: 12.w),
            
            // 添加按钮
            ElevatedButton(
              onPressed: _handleAddCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5B544),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                '添加',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        // 实时读卡提示
        Obx(() {
          final selectedDevice = _service.selectedReader.value;
          final cardData = _service.cardData.value;
          final isReading = _service.isReading.value;
          final lastError = _service.lastError.value;
          
          if (selectedDevice != null) {
            // 优先显示错误状态
            if (lastError != null) {
              return Container(
                margin: EdgeInsets.only(top: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 18.sp,
                      color: const Color(0xFFC62828),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '读卡失败：$lastError',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // 显示读卡状态
            if (cardData != null && cardData['isValid'] == true) {
              // 成功读取卡片
              return Container(
                margin: EdgeInsets.only(top: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18.sp,
                      color: const Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '已读取到卡片：${cardData['uid']}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (isReading) {
              // 正在读卡
              return Container(
                margin: EdgeInsets.only(top: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '正在读取卡片...',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // 🔧 "等待放卡"提示已移动到读卡器状态区域（紫色渐变动画）
          }
          
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// 处理添加卡片
  void _handleAddCard() {
    final cardNumber = _cardNumberController.text.trim();
    if (cardNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入卡面卡号'),
          backgroundColor: Color(0xFFE5B544),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    // TODO: 调用后端接口保存技术卡
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('保存功能开发中，卡号: $cardNumber'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 必填标签
  Widget _buildRequiredLabel(String label) {
    return Row(
      children: [
        Text(
          '*',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
