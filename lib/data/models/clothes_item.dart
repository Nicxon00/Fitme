class ClothesItem {
  final int? id;
  final String name;
  final String category;
  final String imagePath;

  ClothesItem({
    this.id,
    required this.name,
    required this.category,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
    };
  }

  // Predefined categories
  static const List<String> predefinedCategories = [
    'Headwear',
    'Upper Body',
    'Lower Body',
    'Footwear',
    'Accessories',
  ];
}
