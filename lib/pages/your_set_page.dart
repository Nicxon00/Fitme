import 'package:fitme_main/data/providers/set_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_set_page.dart';  // Untuk navigasi ke halaman CreateSetPage

class YourSetPage extends StatefulWidget {
  const YourSetPage({super.key});

  @override
  _YourSetPageState createState() => _YourSetPageState();
}

class _YourSetPageState extends State<YourSetPage> {
  List<String> _savedSets = [];

  @override
  void initState() {
    super.initState();
    _loadSavedSets();
  }

  // Memuat set yang disimpan
  Future<void> _loadSavedSets() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSets = prefs.getStringList('saved_sets') ?? [];
    setState(() {
      _savedSets = savedSets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Sets"),
      ),
      body: _savedSets.isEmpty
          ? const Center(child: Text("No sets created yet! Add a new one."))
          : ListView.builder(
              itemCount: _savedSets.length,
              itemBuilder: (ctx, i) {
                final setName = _savedSets[i];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(setName),
                    onTap: () {
                      // Navigasi ke halaman detail set
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SetDetailPage(setName: setName),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteSet(setName);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CreateSetPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Menghapus set
  Future<void> _deleteSet(String setName) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSets = prefs.getStringList('saved_sets') ?? [];

    // Hapus nama set dari daftar saved_sets
    savedSets.remove(setName);
    await prefs.setStringList('saved_sets', savedSets);

    // Menghapus data set dari SharedPreferences
    await prefs.remove('set_$setName');

    // Muat ulang data set setelah penghapusan dan update UI
    _loadSavedSets();
  }
}
