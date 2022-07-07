import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "homeScreen";

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: const Text("Homescreen")),
      body: SingleChildScrollView(child: Container()),
    ));
  }
}
