import 'package:flutter/material.dart';
import 'package:task/views/convas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          //primaryContainer: Colors.blueAccent,
          //secondaryContainer: Colors.blueAccent,

        ),
        useMaterial3: true,
      ),
      home: const ConvasScreen(),
    );
  }
}
