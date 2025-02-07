class Shop {
  final String shopName;
  final String fssaiId;

  Shop({required this.shopName, required this.fssaiId});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopName: json['shopName'] ?? '',
      fssaiId: json['fssaiId'] ?? '',
    );
  }
}
