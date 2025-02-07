import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget{
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thư viện'),
      ),
      body: Center(
        child: Text('Nội dung Thư viện'),
      ),
    );
  }
}