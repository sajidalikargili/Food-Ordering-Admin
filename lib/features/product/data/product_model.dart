
class AddProductModel {
  final String name;
  final double price;
  final String description;
  final String categoryId;
  final String imageUrl;
  final double rating;

  const AddProductModel({
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.imageUrl,
    required this.rating
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'image': imageUrl,
      'rating': rating,
    };
  }
}
