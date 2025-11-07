import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common_menu.dart';
import '../../../modules/network_check/widgets/network_check_widget.dart';
import '../../network_check/controllers/network_check_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/version_check_controller.dart';
import 'version_check_view.dart';
import 'change_password_view.dart';
import 'placeholder_view.dart';
import 'external_card_reader_view.dart';
import 'external_printer_view.dart';
import 'qr_scanner_config_view.dart';
import 'card_registration_view.dart';
import 'game_card_management_view.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Obx(
                      () => _buildContent(controller.selectedMenu.value),
                    ),
                  ),
                ),
                _buildSidebar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final menuItems = [
      const MenuItem(
        key: 'external_card_reader',
        label: '读卡器',
        icon: Icons.nfc,
      ),
      const MenuItem(key: 'qr_scanner', label: '二维码扫描仪', icon: Icons.qr_code_2),
      const MenuItem(key: 'external_printer', label: '打印机', icon: Icons.print),
      const MenuItem(
        key: 'network_detection',
        label: '网络检测',
        icon: Icons.network_check,
      ),
      const MenuItem(
        key: 'receipt_settings',
        label: '小票设置',
        icon: Icons.receipt,
      ),
      const MenuItem(
        key: 'card_registration',
        label: '卡片登记',
        icon: Icons.card_membership,
      ),
      const MenuItem(
        key: 'game_card_management',
        label: '游戏卡管理',
        icon: Icons.games,
      ),
      const MenuItem(key: 'change_password', label: '修改登录密码', icon: Icons.lock),
      const MenuItem(key: 'version_check', label: '版本检查', icon: Icons.info),
    ];

    return Obx(
      () => CommonMenu(
        menuItems: menuItems,
        selectedKey: controller.selectedMenu.value,
        onItemSelected: (key) => controller.selectMenu(key),
        // backgroundColor: const Color(0xFF2C3E50),
        width: 200.w,
      ),
    );
  }

  Widget _buildContent(String selectedMenu) {
    Widget content;
    switch (selectedMenu) {
      case 'external_card_reader':
        content = const ExternalCardReaderView();
        break;
      case 'qr_scanner':
        content = const QrScannerConfigView();
        break;
      case 'external_printer':
        content = const ExternalPrinterView();
        break;
      case 'network_detection':
        _ensureNetworkCheckController();
        content = const NetworkCheckWidget();
        break;
      case 'card_registration':
        content = const CardRegistrationView();
        break;
      case 'game_card_management':
        content = const GameCardManagementView();
        break;
      case 'version_check':
        _ensureVersionCheckController();
        content = const VersionCheckView();
        break;
      case 'change_password':
        content = const ChangePasswordView();
        break;
      default:
        content = const PlaceholderView();
    }

    return Container(padding: EdgeInsets.all(12.w), child: content);
  }

  void _ensureNetworkCheckController() {
    if (!Get.isRegistered<NetworkCheckController>()) {
      Get.put(NetworkCheckController());
      print('✓ 创建 NetworkCheckController');
    }
  }

  void _ensureVersionCheckController() {
    if (!Get.isRegistered<VersionCheckController>()) {
      Get.put(VersionCheckController());
    }
  }
}
