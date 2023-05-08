import 'package:flutter/material.dart';
import 'package:evolution/grid_page.dart';
import 'package:evolution/data_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evolução',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: DataReader.readEvolutions(),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data == true
              ? const GridPage()
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
