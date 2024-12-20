import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/clothes_item.dart';

class SetDetailPage extends StatefulWidget {
  final String setName;
  const SetDetailPage({super.key, required this.setName});

  @override
  _SetDetailPageState createState() => _SetDetailPageState();
}

class _SetDetailPageState extends State<SetDetailPage> {
  late Map<String, List<ClothesItem>> _setDetails;

  @override
  void initState() {
    super.initState();
    _loadSetDetails();
  }

  // Memuat detail set dari SharedPreferences
  Future<void> _loadSetDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final setDataJson = prefs.getString('set_${widget.setName}') ?? '{}';
    final Map<String, dynamic> setData = jsonDecode(setDataJson);

    final setDetails = setData.map((category, items) {
      final itemList = (items as List)
          .map((itemJson) => ClothesItem.fromJson(itemJson))
          .toList();
      return MapEntry(category, itemList);
    });

    setState(() {
      _setDetails = setDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setName),
      ),
      body: _setDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _setDetails.keys.length,
              itemBuilder: (context, index) {
                final category = _setDetails.keys.elementAt(index);
                final items = _setDetails[category]!;

                return ExpansionTile(
                  title: Text(category),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item.name),
                      leading: Image.file(File(item.imagePath)),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
