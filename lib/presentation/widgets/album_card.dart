// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AlbumCard extends StatelessWidget{
//   final ImageProvider image;
//   final String label;
//   final Function onTap;
//   final double size;
//   const AlbumCard({
//     Key key,
//     this.image,
//     this.label,
//     this.onTap,
//     this.size = 120
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => AlbumView(
//             image: image,
//           ))
//         );
//       },
//     );
//   }
//
// }