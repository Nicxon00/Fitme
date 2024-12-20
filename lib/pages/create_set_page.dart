import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../data/providers/clothes_provider.dart';
import '../data/models/clothes_set.dart';
import '../data/models/clothes_item.dart';

class CreateSetPage extends StatefulWidget {
  const CreateSetPage({super.key});

  @override
  _CreateSetPageState createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final _setNameController = TextEditingController();
  final List<ClothesItem> _selectedItems = [];

  void _toggleSelection(ClothesItem item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _saveSet(BuildContext context) {
    final setName = _setNameController.text.trim();
    if (setName.isEmpty || _selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please name the set and select items.")),
      );
      return;
    }

    final newSet = ClothesSet(
      id: DateTime.now().millisecondsSinceEpoch, // Unique ID
      name: setName,
      items: _selectedItems,
    );

    Provider.of<ClothesProvider>(context, listen: false).addSet(newSet);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final clothes = Provider.of<ClothesProvider>(context).clothes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Set"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _setNameController,
              decoration: const InputDecoration(
                labelText: "Set Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: clothes.length,
                itemBuilder: (ctx, i) {
                  final item = clothes[i];
                  final isSelected = _selectedItems.contains(item);
                  return GestureDetector(
                    onTap: () => _toggleSelection(item),
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor:
                            isSelected ? Colors.green : Colors.black54,
                        title: Text(item.name),
                      ),
                      child: Image.file(
                        File(item.imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _saveSet(context),
              child: const Text("Save Set"),
            ),
          ],
        ),
      ),
    );
  }
}
