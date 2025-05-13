import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          SizedBox(width: 10,),
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 10,),
          Text(
            "Bạn muốn tìm kiếm gì ?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
