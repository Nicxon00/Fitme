import 'package:fitme_main/data/models/clothes_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class CreateSetPage extends StatefulWidget {
  const CreateSetPage({super.key});

  @override
  _CreateSetPageState createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final _setNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Map<String, List<ClothesItem>> _itemsByCategory = {
    "Accessories": [],
    "Tops": [],
    "Bottoms": [],
    "Dresses": [],
    "Jackets": [],
    "Shoes": [],
  };

  // Menambahkan gambar ke kategori
  Future<void> _addImage(String category) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final newItem = ClothesItem(
        id: DateTime.now().millisecondsSinceEpoch,
        name: "New Item",
        category: category,
        imagePath: pickedFile.path,
      );

      setState(() {
        _itemsByCategory[category]?.add(newItem);
      });
    }
  }

  // Menyimpan set ke SharedPreferences
  Future<void> _saveSet() async {
    final setName = _setNameController.text;
    if (setName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Set Name cannot be empty!")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // Mengonversi _itemsByCategory menjadi JSON
    final setData = _itemsByCategory.map((category, items) {
      return MapEntry(
        category,
        items.map((item) => item.toJson()).toList(),
      );
    });

    // Menyimpan data set ke SharedPreferences
    final setKey = 'set_$setName';
    await prefs.setString(setKey, jsonEncode(setData));

    // Menyimpan nama set dalam daftar nama set
    final savedSets = prefs.getStringList('saved_sets') ?? [];
    if (!savedSets.contains(setName)) {
      savedSets.add(setName);
      await prefs.setStringList('saved_sets', savedSets);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Set '$setName' saved successfully!")),
    );

    // Reset setelah menyimpan
    _setNameController.clear();
    setState(() {
      _itemsByCategory = {
        "Accessories": [],
        "Tops": [],
        "Bottoms": [],
        "Dresses": [],
        "Jackets": [],
        "Shoes": [],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Set"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Set Name Field
              TextField(
                controller: _setNameController,
                decoration: const InputDecoration(labelText: 'Set Name'),
              ),
              const SizedBox(height: 20),
              // Display Categories and their items
              ..._itemsByCategory.entries.map((entry) {
                final category = entry.key;
                final items = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(item.imagePath),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () => _addImage(category),
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 3),
              // Center the Save Set button with a green background
              Center(
                child: ElevatedButton(
                  onPressed: _saveSet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Save Set"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
