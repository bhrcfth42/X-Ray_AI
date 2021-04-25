import 'package:flutter/material.dart';
import 'package:xray_yapay_zeka/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X-Ray Yapay Zeka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: YapayZekaHome(),
    );
  }
}
