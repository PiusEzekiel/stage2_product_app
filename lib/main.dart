import 'package:flutter/material.dart';
import 'package:stage2_product_app/screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // title: 'Stage2 Product App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: ProductListScreen(),
    );
  }
}
