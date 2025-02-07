import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchPageState();
  }


}

class SearchPageState extends State<SearchPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text('Nội dung Thư viện'),
      ),
    );
  }
}
