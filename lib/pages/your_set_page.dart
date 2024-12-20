import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitme_main/pages/create_set_page.dart';
import '../data/providers/clothes_provider.dart';

class YourSetPage extends StatelessWidget {
  const YourSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sets = Provider.of<ClothesProvider>(context).sets;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Sets"),
      ),
      body: sets.isEmpty
          ? const Center(
              child: Text("No sets created yet! Add a new one."),
            )
          : ListView.builder(
              itemCount: sets.length,
              itemBuilder: (ctx, i) {
                final set = sets[i];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(set.name),
                    subtitle: Text(
                      "${set.items.length} items",
                    ),
                    onTap: () {
                      // Optional: Navigate to a detailed set page
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<ClothesProvider>(context, listen: false)
                            .deleteSet(set.id!);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => CreateSetPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
