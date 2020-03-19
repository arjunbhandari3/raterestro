class OrderStatus {
  String id;
  String status;

  OrderStatus();

  OrderStatus.fromJSON(Map<dynamic, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        status = jsonMap['status'] != null ? jsonMap['status'] : '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
    };
  }
}
