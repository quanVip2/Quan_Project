import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget{
  const PremiumPage({super.key});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PremiumPageState();
  }
}

class PremiumPageState extends State<PremiumPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premium'),
      ),
      body: Center(
        child: Text('Nội dung Thư viện'),
      ),
    );
  }
}