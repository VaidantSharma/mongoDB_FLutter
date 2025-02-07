class StockStatus {
  final bool status;
  final String name;
  final String date;

  StockStatus({
    required this.status,
    required this.name,
    required this.date,
  });

  factory StockStatus.fromJson(Map<String, dynamic> json) {
    return StockStatus(
      status: json['status'],
      name: json['name'],
      date: json['date'],
    );
  }
}
