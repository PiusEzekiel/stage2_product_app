class Product {
  final String? id;
  final String? name;
  final String? description;
  final String? uniqueId;
  final String? urlSlug;
  final bool isAvailable;
  final bool isService;
  final List<Photo> photos;
  final List<Price> currentPrice; // Changed to Map<String, Price>
  final bool isDeleted;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.uniqueId,
    required this.urlSlug,
    required this.isAvailable,
    required this.isService,
    required this.photos,
    required this.currentPrice,
    required this.isDeleted,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      uniqueId: json['unique_id'] as String?,
      urlSlug: json['url_slug'] as String?,
      isAvailable: json['is_available'] as bool,
      isService: json['is_service'] as bool,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((photo) => Photo.fromJson(photo))
              .toList() ??
          [],
      currentPrice: (json['current_price'] as List<dynamic>?)
              ?.map((price) => Price.fromJson(price))
              .toList() ??
          [], //
      isDeleted: json['is_deleted'] as bool,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $currentPrice, photos: $photos...}';
  }
}

class Photo {
  final String? url; // Make 'url' nullable

  Photo({required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(url: json['url'] as String?); // Now 'url' is nullable
  }
}

class Price {
  final String? currencyCode;
  final double? amount;

  Price({this.currencyCode, this.amount});
  bool get isNegative => amount != null && amount! < 0;

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currencyCode: json['currencyCode'] as String?,
      amount: json['amount'] as double?,
    );
  }
}
