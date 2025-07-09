// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/image_preview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Picker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PickImageScreen(),
    );
  }
}
