import 'package:fitme_main/data/models/clothes_item.dart';

class ClothesSet {
  final int? id; // Unique identifier
  final String name; // Name of the set
  final List<ClothesItem> items; // List of clothes items in the set

  ClothesSet({
    this.id,
    required this.name,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}
