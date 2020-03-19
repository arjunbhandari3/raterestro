class Payment {
  String id;
  String status;
  String method;

  Payment.init();

  Payment(this.method);

  Payment.fromJSON(Map<dynamic, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        status = jsonMap['status'] ?? '',
        method = jsonMap['method'] ?? '';

  Map<dynamic, dynamic> toMap() {
    return {
      'status': status,
      'method': method,
    };
  }
}
