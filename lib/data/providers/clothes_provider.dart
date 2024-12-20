import 'package:flutter/material.dart';
import '../models/clothes_set.dart';
import '../models/clothes_item.dart';

class ClothesProvider extends ChangeNotifier {
  final List<ClothesItem> _clothes = [];
  final List<ClothesSet> _sets = []; // Add a list for sets

  List<ClothesItem> get clothes => _clothes;
  List<ClothesSet> get sets => _sets; // Getter for sets

  Future<void> loadClothes() async {
    // Logic to load clothes (if using a database)
    notifyListeners();
  }

  Future<void> addClothes(ClothesItem newClothes) async {
    _clothes.add(newClothes);
    notifyListeners();
  }

  void addSet(ClothesSet newSet) {
    _sets.add(newSet);
    notifyListeners();
  }

  void deleteSet(int id) {
    _sets.removeWhere((set) => set.id == id);
    notifyListeners();
  }
}
