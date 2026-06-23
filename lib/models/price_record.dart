class PriceRecord {
  final int? id;
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String arrivalDate;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;

  PriceRecord({
    this.id,
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.arrivalDate,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  factory PriceRecord.fromJson(Map<String, dynamic> json) {
    return PriceRecord(
      state: (json['state'] ?? 'Unknown') as String,
      district: (json['district'] ?? 'Unknown') as String,
      market: (json['market'] ?? 'Unknown') as String,
      commodity: (json['commodity'] ?? 'Unknown') as String,
      arrivalDate: (json['arrivalDate'] ?? 'Unknown') as String,
      minPrice: (json['min_price'] ?? json['minPrice'] as num? ?? 0.0).toDouble(),
      maxPrice: (json['max_price'] ?? json['maxPrice'] as num? ?? 0.0).toDouble(),
      modalPrice: (json['modal_price'] ?? json['modalPrice'] as num? ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state': state,
      'district': district,
      'market': market,
      'commodity': commodity,
      'arrivalDate': arrivalDate,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'modalPrice': modalPrice,
    };
  }
}