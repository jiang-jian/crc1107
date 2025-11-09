/// 托管小票数据模型
/// 表示实际打印时的数据内容
class CustodyReceiptData {
  final String depositNumber;       // 存币单号
  final String storeName;           // 门店名称
  final String memberId;            // 会员编号
  final DateTime operationTime;     // 操作时间
  final int ticketQuantity;         // 彩票数量
  final DateTime printTime;         // 打印时间
  final String operator;            // 操作员
  final String? operatorId;         // 操作员ID（可选）

  CustodyReceiptData({
    required this.depositNumber,
    required this.storeName,
    required this.memberId,
    required this.operationTime,
    required this.ticketQuantity,
    required this.printTime,
    required this.operator,
    this.operatorId,
  });

  /// 创建测试数据
  factory CustodyReceiptData.sample() {
    final now = DateTime.now();
    return CustodyReceiptData(
      depositNumber: '01339483945069',
      storeName: 'HoloX超乐场-Dubai mall',
      memberId: '483945069',
      operationTime: now,
      ticketQuantity: 2893,
      printTime: now,
      operator: '美丽',
      operatorId: 'OP001',
    );
  }

  /// 从 JSON 反序列化
  factory CustodyReceiptData.fromJson(Map<String, dynamic> json) {
    return CustodyReceiptData(
      depositNumber: json['depositNumber'] as String,
      storeName: json['storeName'] as String,
      memberId: json['memberId'] as String,
      operationTime: DateTime.parse(json['operationTime'] as String),
      ticketQuantity: json['ticketQuantity'] as int,
      printTime: DateTime.parse(json['printTime'] as String),
      operator: json['operator'] as String,
      operatorId: json['operatorId'] as String?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'depositNumber': depositNumber,
      'storeName': storeName,
      'memberId': memberId,
      'operationTime': operationTime.toIso8601String(),
      'ticketQuantity': ticketQuantity,
      'printTime': printTime.toIso8601String(),
      'operator': operator,
      'operatorId': operatorId,
    };
  }

  /// 复制并修改
  CustodyReceiptData copyWith({
    String? depositNumber,
    String? storeName,
    String? memberId,
    DateTime? operationTime,
    int? ticketQuantity,
    DateTime? printTime,
    String? operator,
    String? operatorId,
  }) {
    return CustodyReceiptData(
      depositNumber: depositNumber ?? this.depositNumber,
      storeName: storeName ?? this.storeName,
      memberId: memberId ?? this.memberId,
      operationTime: operationTime ?? this.operationTime,
      ticketQuantity: ticketQuantity ?? this.ticketQuantity,
      printTime: printTime ?? this.printTime,
      operator: operator ?? this.operator,
      operatorId: operatorId ?? this.operatorId,
    );
  }

  /// 格式化操作时间
  String get formattedOperationTime {
    return '${operationTime.year}/${operationTime.month.toString().padLeft(2, '0')}/${operationTime.day.toString().padLeft(2, '0')} '
           '${operationTime.hour.toString().padLeft(2, '0')}:${operationTime.minute.toString().padLeft(2, '0')}:${operationTime.second.toString().padLeft(2, '0')}';
  }

  /// 格式化打印时间
  String get formattedPrintTime {
    return '${printTime.year}/${printTime.month.toString().padLeft(2, '0')}/${printTime.day.toString().padLeft(2, '0')} '
           '${printTime.hour.toString().padLeft(2, '0')}:${printTime.minute.toString().padLeft(2, '0')}:${printTime.second.toString().padLeft(2, '0')}';
  }

  /// 格式化彩票数量（添加千分位）
  String get formattedTicketQuantity {
    final parts = ticketQuantity.toString().split('.');
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return parts.join('.');
  }
}
