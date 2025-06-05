class Battery {
  final String number;
  final double price;
  final double discount;
  final double deliveryCharges;
  final double taxAndDisposalFees;

  Battery({
    required this.number,
    required this.price,
    required this.discount,
    required this.deliveryCharges,
    required this.taxAndDisposalFees,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'price': price,
    'discount': discount,
    'deliveryCharges': deliveryCharges,
    'taxAndDisposalFees': taxAndDisposalFees,
  };

  factory Battery.fromJson(Map<String, dynamic> json) => Battery(
    number: json['number'],
    price: json['price'].toDouble(),
    discount: json['discount'].toDouble(),
    deliveryCharges: json['deliveryCharges'].toDouble(),
    taxAndDisposalFees: json['taxAndDisposalFees'].toDouble(),
  );
}
