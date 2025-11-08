# 后端接口对接文档

本文档记录了所有待后端接口开发完成后需要对接的功能。

---

## 📋 目录

1. [添加技术卡功能](#1-添加技术卡功能)
2. [修改密码功能](#2-修改密码功能)
3. [注销技术卡功能](#3-注销技术卡功能)
4. [后端接口对接步骤](#后端接口对接步骤)
5. [ApiService 实现参考](#apiservice-实现参考)

---

## 🔴 待对接功能清单

### 1. 添加技术卡功能

**状态：** ⏳ 待对接（需要完整数据流实现）

**涉及文件：**
- `lib/modules/settings/views/add_technical_card_view.dart`
- `lib/modules/settings/views/card_registration_view.dart`

**当前实现：**
```dart
// add_technical_card_view.dart
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
```

**需要实现的数据流：**
```
用户点击"添加技术卡"
  ↓
跳转到添加页面
  ↓
输入卡号，点击"添加"按钮
  ↓
调用后端接口保存 (ApiService.addCard)
  ↓
保存成功
  ↓
返回列表页，并传递新卡片数据 (Navigator.pop)
  ↓
列表页接收数据，更新 _mockData
  ↓
自动选中新添加的卡片
  ↓
显示成功提示
```

**后端接口定义：**

**请求：**
- **URL:** `POST /api/technical-card/add`
- **Body:**
  ```json
  {
    "cardNumber": "1001"
  }
  ```

**响应：**
```json
{
  "success": true,
  "data": {
    "cardNumber": "1001",
    "password": "123456",
    "operationTime": "2024-01-20 10:30:25",
    "operator": "张三"
  },
  "message": "技术卡添加成功"
}
```

**对接代码示例：**

```dart
// 1. 修改 add_technical_card_view.dart 的 _handleAddCard 方法
void _handleAddCard() async {
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
  
  try {
    // 调用后端接口
    final response = await ApiService.addCard(cardNumber);
    
    if (response.success) {
      // 构造新卡片数据
      final newCard = {
        'cardNumber': response.data['cardNumber'],
        'password': response.data['password'],
        'operationTime': response.data['operationTime'],
        'operator': response.data['operator'],
      };
      
      // 返回到列表页，并传递新卡片数据
      Navigator.of(context).pop(newCard);
    } else {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? '添加失败'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e) {
    // 网络错误处理
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('网络错误：${e.toString()}'),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// 2. 修改 card_registration_view.dart 的添加按钮事件
_buildButton(
  label: '添加技术卡',
  backgroundColor: const Color(0xFF4CAF50),
  onPressed: () async {
    // 等待添加页面的返回结果
    final newCard = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (context) => const AddTechnicalCardView(),
      ),
    );
    
    // 如果返回了新卡片数据，添加到列表
    if (newCard != null) {
      setState(() {
        _mockData.add(newCard);
        _selectedIndex = _mockData.length - 1; // 选中新添加的卡片
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('技术卡添加成功！卡号：${newCard['cardNumber']}'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  },
),
```

---

### 2. 修改密码功能

**状态：** ⏳ 待对接（数据已组织好，只需取消注释）

**涉及文件：**
- `lib/modules/settings/widgets/change_password_dialog.dart`

**当前实现：**
```dart
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
```

**后端接口定义：**

**请求：**
- **URL:** `POST /api/technical-card/change-password`
- **Body:**
  ```json
  {
    "cardNumber": "1001",
    "oldPassword": "123456",
    "newPassword": "abc123"
  }
  ```

**响应：**
```json
{
  "success": true,
  "message": "密码修改成功"
}
```

**对接步骤：**
1. 在 `change_password_dialog.dart` 找到 `_handleSubmit` 方法
2. 取消注释 `TODO: 后端接口对接` 部分的代码
3. 删除临时演示代码（`widget.onPasswordChanged...` 和临时提示）
4. 实现 `ApiService.changePassword()` 方法
5. 测试接口调用和错误处理

**验证规则：**
- ✅ 新密码长度至少 6 位
- ✅ 新密码不能与旧密码相同
- ✅ 新密码和确认密码必须一致

---

### 3. 注销技术卡功能

**状态：** ⏳ 待对接（数据已组织好，只需取消注释）

**涉及文件：**
- `lib/modules/settings/widgets/deactivate_card_dialog.dart`

**当前实现：**
```dart
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
```

**后端接口定义：**

**请求：**
- **URL:** `POST /api/technical-card/deactivate`
- **Body:**
  ```json
  {
    "cardNumber": "1001"
  }
  ```

**响应：**
```json
{
  "success": true,
  "message": "技术卡注销成功"
}
```

**对接步骤：**
1. 在 `deactivate_card_dialog.dart` 找到 `_handleSubmit` 方法
2. 取消注释 `TODO: 后端接口对接` 部分的代码
3. 删除临时演示代码（`onCardDeactivated...` 和临时提示）
4. 实现 `ApiService.deactivateCard()` 方法
5. 测试接口调用和错误处理

**警告提示：**
- ⚠️ 注销技术卡成功之后，不可对商户内一体机进行操作

---

## 🔧 后端接口对接步骤

### 第一步：实现 ApiService 方法

创建或修改 `lib/data/services/api_service.dart`：

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://your-api-domain.com/api';
  
  /// 1. 添加技术卡
  static Future<ApiResponse> addCard(String cardNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/technical-card/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cardNumber': cardNumber}),
      );
      
      final data = jsonDecode(response.body);
      return ApiResponse(
        success: data['success'] ?? false,
        data: data['data'],
        message: data['message'],
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: '网络连接失败：${e.toString()}',
      );
    }
  }
  
  /// 2. 修改密码
  static Future<ApiResponse> changePassword(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/technical-card/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      final responseData = jsonDecode(response.body);
      return ApiResponse(
        success: responseData['success'] ?? false,
        message: responseData['message'],
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: '网络连接失败：${e.toString()}',
      );
    }
  }
  
  /// 3. 注销技术卡
  static Future<ApiResponse> deactivateCard(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/technical-card/deactivate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      final responseData = jsonDecode(response.body);
      return ApiResponse(
        success: responseData['success'] ?? false,
        message: responseData['message'],
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: '网络连接失败：${e.toString()}',
      );
    }
  }
}

/// API 响应数据模型
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
}
```

### 第二步：启用接口调用代码

按照每个功能的对接步骤，依次启用接口调用代码。

### 第三步：测试验证

**测试清单：**
- [ ] 添加技术卡 - 成功场景
- [ ] 添加技术卡 - 失败场景（重复卡号、无效卡号等）
- [ ] 添加技术卡 - 网络错误场景
- [ ] 修改密码 - 成功场景
- [ ] 修改密码 - 失败场景（旧密码错误、新密码不符合要求等）
- [ ] 修改密码 - 网络错误场景
- [ ] 注销技术卡 - 成功场景
- [ ] 注销技术卡 - 失败场景（卡号不存在等）
- [ ] 注销技术卡 - 网络错误场景

---

## 📊 ApiService 实现参考

### 完整的 ApiService 类

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // API 基础 URL（根据实际环境配置）
  static const String baseUrl = 'http://your-api-domain.com/api';
  
  // 超时设置
  static const Duration timeout = Duration(seconds: 30);
  
  /// 通用 POST 请求方法
  static Future<ApiResponse> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              // 如果需要认证，添加 token
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);
      
      // 检查 HTTP 状态码
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(
          success: data['success'] ?? false,
          data: data['data'],
          message: data['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: '请求超时，请检查网络连接',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: '网络错误：${e.toString()}',
      );
    }
  }
  
  /// 1. 添加技术卡
  static Future<ApiResponse> addCard(String cardNumber) async {
    return await _post(
      '/technical-card/add',
      {'cardNumber': cardNumber},
    );
  }
  
  /// 2. 修改密码
  static Future<ApiResponse> changePassword(Map<String, String> data) async {
    return await _post(
      '/technical-card/change-password',
      data,
    );
  }
  
  /// 3. 注销技术卡
  static Future<ApiResponse> deactivateCard(Map<String, String> data) async {
    return await _post(
      '/technical-card/deactivate',
      data,
    );
  }
}

/// API 响应数据模型
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
  
  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message)';
  }
}
```

---

## 🎯 后端接口规范

### 统一响应格式

所有接口应返回统一的 JSON 格式：

```json
{
  "success": true|false,
  "data": {},           // 成功时返回的数据（可选）
  "message": "提示信息" // 成功或失败的提示信息
}
```

### HTTP 状态码

- **200 OK:** 请求成功
- **400 Bad Request:** 请求参数错误
- **401 Unauthorized:** 未授权（如需要登录）
- **404 Not Found:** 资源不存在
- **500 Internal Server Error:** 服务器内部错误

### 错误处理

后端应返回明确的错误信息：

```json
{
  "success": false,
  "message": "卡号已存在"
}
```

```json
{
  "success": false,
  "message": "旧密码不正确"
}
```

```json
{
  "success": false,
  "message": "卡号不存在"
}
```

---

## 📝 对接检查清单

### 开发前
- [ ] 确认后端接口 URL 和端口
- [ ] 确认接口请求格式（JSON）
- [ ] 确认接口响应格式
- [ ] 确认是否需要身份认证（Token）
- [ ] 准备测试数据

### 开发中
- [ ] 实现 ApiService 类
- [ ] 实现 ApiResponse 数据模型
- [ ] 添加超时处理
- [ ] 添加错误处理
- [ ] 添加网络状态检查

### 开发后
- [ ] 单元测试接口调用
- [ ] 测试成功场景
- [ ] 测试失败场景
- [ ] 测试网络异常场景
- [ ] 测试超时场景
- [ ] UI 交互测试
- [ ] 完整流程测试

---

## 🚀 完成标志

所有功能对接完成后，应满足以下条件：

1. ✅ 添加技术卡后，列表立即更新显示新卡片
2. ✅ 修改密码后，列表中的密码和操作时间正确更新
3. ✅ 注销技术卡后，该卡片从列表中移除
4. ✅ 所有操作都有明确的成功/失败提示
5. ✅ 网络错误时有友好的错误提示
6. ✅ 所有临时演示代码已删除
7. ✅ 通过所有测试场景

---

## 📞 联系方式

如有疑问，请联系前端开发团队。

---

**文档版本：** 1.0  
**创建日期：** 2024-01-20  
**最后更新：** 2024-01-20  
