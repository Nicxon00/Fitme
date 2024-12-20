// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'data/providers/clothes_provider.dart';
// import 'pages/login_page.dart';

// void main() {
//   runApp(FitmeApp());
// }

// class FitmeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (ctx) => ClothesProvider(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'FitMe',
//         theme: ThemeData(
//           primarySwatch: Colors.green, // Define the primary swatch
//           // Or set the primaryColor directly:
//           primaryColor: const Color.fromARGB(255, 56, 126, 58),
//         ),
//         home: LoginPage(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/providers/clothes_provider.dart'; // Pastikan path import sudah benar
import 'pages/login_page.dart'; // Pastikan path import sudah benar

void main() {
  runApp(const FitmeApp()); // Gunakan const untuk efisiensi
}

class FitmeApp extends StatelessWidget {
  const FitmeApp({super.key}); // Tambahkan const pada konstruktor untuk efisiensi

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ClothesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitMe',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color.fromARGB(255, 56, 126, 58), // Definisikan warna utama
        ),
        home: const LoginPage(), // Gunakan const jika halaman login adalah widget statis
      ),
    );
  }
}
