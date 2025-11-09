import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/receipt/custody_receipt_template.dart';
import '../controllers/custody_receipt_config_controller.dart';

/// 托管小票配置表单
/// 提供所有配置项的编辑界面
class CustodyReceiptConfigForm extends GetView<CustodyReceiptConfigController> {
  const CustodyReceiptConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('头部配置'),
          _buildHeaderSection(),
          SizedBox(height: 32.h),
          _buildSectionTitle('存币信息配置'),
          _buildDepositInfoSection(),
          SizedBox(height: 32.h),
          _buildSectionTitle('会员信息配置'),
          _buildMemberInfoSection(),
          SizedBox(height: 32.h),
          _buildSectionTitle('打印信息配置'),
          _buildPrintInfoSection(),
          SizedBox(height: 32.h),
          _buildSectionTitle('底部配置'),
          _buildFooterSection(),
          SizedBox(height: 32.h),
          _buildSectionTitle('打印设置'),
          _buildPrintSettingsSection(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// 区域标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  /// 头部配置区域
  Widget _buildHeaderSection() {
    return Obx(() {
      final header = controller.template.value.header;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextFormField(
                initialValue: header.storeName,
                decoration: const InputDecoration(
                  labelText: '店铺名称（中文）',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.updateHeader(header.copyWith(storeName: value));
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                initialValue: header.storeNameEn,
                decoration: const InputDecoration(
                  labelText: '店铺名称（英文）',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.updateHeader(header.copyWith(storeNameEn: value));
                },
              ),
              SizedBox(height: 16.h),
              SwitchListTile(
                title: const Text('显示 Logo'),
                value: header.showLogo,
                onChanged: (value) {
                  controller.updateHeader(header.copyWith(showLogo: value));
                },
              ),
              SwitchListTile(
                title: const Text('标题加粗'),
                value: header.bold,
                onChanged: (value) {
                  controller.updateHeader(header.copyWith(bold: value));
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 存币信息配置区域
  Widget _buildDepositInfoSection() {
    return Obx(() {
      final depositInfo = controller.template.value.depositInfo;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('显示存币单号'),
                value: depositInfo.showDepositNumber,
                onChanged: (value) {
                  controller.updateDepositInfo(
                    depositInfo.copyWith(showDepositNumber: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示门店名称'),
                value: depositInfo.showStoreName,
                onChanged: (value) {
                  controller.updateDepositInfo(
                    depositInfo.copyWith(showStoreName: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示条形码'),
                value: depositInfo.showBarcode,
                onChanged: (value) {
                  controller.updateDepositInfo(
                    depositInfo.copyWith(showBarcode: value),
                  );
                },
              ),
              if (depositInfo.showBarcode) ...[
                SizedBox(height: 16.h),
                DropdownButtonFormField<BarcodeType>(
                  value: depositInfo.barcodeType,
                  decoration: const InputDecoration(
                    labelText: '条形码类型',
                    border: OutlineInputBorder(),
                  ),
                  items: BarcodeType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateDepositInfo(
                        depositInfo.copyWith(barcodeType: value),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  /// 会员信息配置区域
  Widget _buildMemberInfoSection() {
    return Obx(() {
      final memberInfo = controller.template.value.memberInfo;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('显示会员编号'),
                value: memberInfo.showMemberId,
                onChanged: (value) {
                  controller.updateMemberInfo(
                    memberInfo.copyWith(showMemberId: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示操作时间'),
                value: memberInfo.showOperationTime,
                onChanged: (value) {
                  controller.updateMemberInfo(
                    memberInfo.copyWith(showOperationTime: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示彩票数量'),
                value: memberInfo.showTicketQuantity,
                onChanged: (value) {
                  controller.updateMemberInfo(
                    memberInfo.copyWith(showTicketQuantity: value),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 打印信息配置区域
  Widget _buildPrintInfoSection() {
    return Obx(() {
      final printInfo = controller.template.value.printInfo;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('显示打印时间'),
                value: printInfo.showPrintTime,
                onChanged: (value) {
                  controller.updatePrintInfo(
                    printInfo.copyWith(showPrintTime: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示操作员'),
                value: printInfo.showOperator,
                onChanged: (value) {
                  controller.updatePrintInfo(
                    printInfo.copyWith(showOperator: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示地址'),
                value: printInfo.showAddress,
                onChanged: (value) {
                  controller.updatePrintInfo(
                    printInfo.copyWith(showAddress: value),
                  );
                },
              ),
              if (printInfo.showAddress) ...[
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: printInfo.address,
                  decoration: const InputDecoration(
                    labelText: '门店地址',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.updatePrintInfo(
                      printInfo.copyWith(address: value),
                    );
                  },
                ),
              ],
              SwitchListTile(
                title: const Text('显示电话'),
                value: printInfo.showPhone,
                onChanged: (value) {
                  controller.updatePrintInfo(
                    printInfo.copyWith(showPhone: value),
                  );
                },
              ),
              if (printInfo.showPhone) ...[
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: printInfo.phone,
                  decoration: const InputDecoration(
                    labelText: '联系电话',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.updatePrintInfo(
                      printInfo.copyWith(phone: value),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  /// 底部配置区域
  Widget _buildFooterSection() {
    return Obx(() {
      final footer = controller.template.value.footer;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('显示提示语'),
                value: footer.showReminder,
                onChanged: (value) {
                  controller.updateFooter(
                    footer.copyWith(showReminder: value),
                  );
                },
              ),
              if (footer.showReminder) ...[
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: footer.reminderText,
                  decoration: const InputDecoration(
                    labelText: '提示语（中文）',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    controller.updateFooter(
                      footer.copyWith(reminderText: value),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: footer.reminderTextEn,
                  decoration: const InputDecoration(
                    labelText: '提示语（英文）',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    controller.updateFooter(
                      footer.copyWith(reminderTextEn: value),
                    );
                  },
                ),
              ],
              SizedBox(height: 16.h),
              SwitchListTile(
                title: const Text('显示感谢语'),
                value: footer.showThankYou,
                onChanged: (value) {
                  controller.updateFooter(
                    footer.copyWith(showThankYou: value),
                  );
                },
              ),
              if (footer.showThankYou) ...[
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: footer.thankYouText,
                  decoration: const InputDecoration(
                    labelText: '感谢语（中文）',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    controller.updateFooter(
                      footer.copyWith(thankYouText: value),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  initialValue: footer.thankYouTextEn,
                  decoration: const InputDecoration(
                    labelText: '感谢语（英文）',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    controller.updateFooter(
                      footer.copyWith(thankYouTextEn: value),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  /// 打印设置区域
  Widget _buildPrintSettingsSection() {
    return Obx(() {
      final settings = controller.template.value.settings;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('双语打印'),
                subtitle: const Text('同时打印中英文内容'),
                value: settings.bilingual,
                onChanged: (value) {
                  controller.updateSettings(
                    settings.copyWith(bilingual: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('显示分隔线'),
                value: settings.showSeparator,
                onChanged: (value) {
                  controller.updateSettings(
                    settings.copyWith(showSeparator: value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('自动切纸'),
                value: settings.cutPaper,
                onChanged: (value) {
                  controller.updateSettings(
                    settings.copyWith(cutPaper: value),
                  );
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                initialValue: settings.paperWidth.toString(),
                decoration: const InputDecoration(
                  labelText: '纸张宽度（字符数）',
                  border: OutlineInputBorder(),
                  helperText: '范围：32-64',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final width = int.tryParse(value);
                  if (width != null && width >= 32 && width <= 64) {
                    controller.updateSettings(
                      settings.copyWith(paperWidth: width),
                    );
                  }
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                initialValue: settings.feedLines.toString(),
                decoration: const InputDecoration(
                  labelText: '走纸行数',
                  border: OutlineInputBorder(),
                  helperText: '打印后走纸的行数',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final lines = int.tryParse(value);
                  if (lines != null && lines >= 0 && lines <= 10) {
                    controller.updateSettings(
                      settings.copyWith(feedLines: lines),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
