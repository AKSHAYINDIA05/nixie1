import 'package:flutter/material.dart';
import 'package:nixie1/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '#Nixie',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 2, 30, 53)),
      home: const HomePage(),
    );
  }
}
