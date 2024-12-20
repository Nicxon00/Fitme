import 'package:flutter/material.dart';
import '../models/clothes_set.dart';
import '../models/clothes_item.dart';

class ClothesProvider extends ChangeNotifier {
  final List<ClothesItem> _clothes = [];
  final List<ClothesSet> _sets = []; // List untuk menyimpan set

  List<ClothesItem> get clothes => _clothes;
  List<ClothesSet> get sets => _sets; // Getter untuk set

  Future<void> loadClothes() async {
    // Logic untuk memuat pakaian (jika menggunakan database)
    notifyListeners();
  }

  Future<void> addClothes(ClothesItem newClothes) async {
    _clothes.add(newClothes);
    notifyListeners();
  }

  void addSet(ClothesSet newSet) {
    _sets.add(newSet);
    notifyListeners(); // Memberitahu perubahan data
  }

  void deleteSet(int id) {
    _sets.removeWhere((set) => set.id == id);
    notifyListeners(); // Memberitahu perubahan data
  }
}
