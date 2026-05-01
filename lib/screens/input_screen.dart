import 'package:flutter/material.dart';

class InputScreen extends StatelessWidget {
  final String title;

  const InputScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),
      body: Center(
        child: Text(
          'Halaman Input $title (TBD)',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
