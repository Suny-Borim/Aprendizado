class Product  {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  int quantidade;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.quantidade = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '' ,
      price: json['price'].toDouble(),
      image: json['image'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          image == other.image &&
          price == other.price &&
          description == other.description;
          

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ image.hashCode ^ price.hashCode ^ description.hashCode;
}