import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitme_main/data/models/clothes_item.dart';
import 'package:fitme_main/data/providers/clothes_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class ClothesListScreen extends StatefulWidget {
  const ClothesListScreen({Key? key}) : super(key: key);

  @override
  State<ClothesListScreen> createState() => _ClothesListScreenState();
}

class _ClothesListScreenState extends State<ClothesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClothesProvider>(context, listen: false).loadClothes();
    });
  }

  Future<void> _addClothes() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedImage.path);
    final savedImage =
        await File(pickedImage.path).copy('${appDir.path}/$fileName');

    final _textController = TextEditingController();
    String? _selectedCategory;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add New Clothing Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name Field with * indicator
              Row(
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name',
                ),
              ),
              const SizedBox(height: 20),

              // Category Dropdown with * indicator
              Row(
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select a Category'),
                items: ClothesItem.predefinedCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog if canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = _textController.text;
                if (name.isEmpty || _selectedCategory == null) {
                  // Show validation errors if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final newClothes = ClothesItem(
                  name: name,
                  category: _selectedCategory!,
                  imagePath: savedImage.path,
                );
                await Provider.of<ClothesProvider>(context, listen: false)
                    .addClothes(newClothes);
                Navigator.of(ctx).pop(); // Close dialog after adding
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clothes = Provider.of<ClothesProvider>(context).clothes;

    // Group clothes by category
    final Map<String, List<ClothesItem>> clothesByCategory = {};
    for (var category in ClothesItem.predefinedCategories) {
      clothesByCategory[category] =
          clothes.where((item) => item.category == category).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitme - Clothes list'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ClothesItem.predefinedCategories.map((category) {
            final categoryClothes = clothesByCategory[category] ?? [];

            if (categoryClothes.isEmpty) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180, // Adjust height of the carousel
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryClothes.length,
                      itemBuilder: (ctx, index) {
                        final item = categoryClothes[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(item.imagePath),
                                  height: 140,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item.name,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClothes,
        child: const Icon(Icons.add),
      ),
    );
  }
}
