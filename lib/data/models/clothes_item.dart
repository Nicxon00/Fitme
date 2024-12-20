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

  // Method untuk mengonversi ClothesItem menjadi Map (untuk serialisasi)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
    };
  }

  // Method untuk mengonversi ClothesItem menjadi JSON (menggunakan toMap)
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Factory method untuk membuat ClothesItem dari JSON
  factory ClothesItem.fromJson(Map<String, dynamic> json) {
    return ClothesItem(
      id: json['id'] as int?,  // id bisa null, jadi pastikan ini di-handle
      name: json['name'] as String,
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  // Kategori pra-definisi yang tersedia
  static const List<String> predefinedCategories = [
    'Headwear',  // Tambahkan kategori lain yang relevan di sini
    'Tops',
    'Bottoms',
    'Shoes',
    'Accessories',
    'Outerwear',
    // etc.
  ];

  // Method untuk mengecek apakah kategori yang diberikan valid
  bool isValidCategory() {
    return predefinedCategories.contains(category);
  }
}
