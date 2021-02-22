// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'Photo.dart';
// import 'DBHelper.dart';
// import '../Services/Utility.dart';

// import 'dart:async';

// class SaveImageDemoSQLite extends StatefulWidget {
//   //
//   SaveImageDemoSQLite() : super();

//   final String title = "Flutter Save Image";

//   @override
//   _SaveImageDemoSQLiteState createState() => _SaveImageDemoSQLiteState();
// }

// class _SaveImageDemoSQLiteState extends State<SaveImageDemoSQLite> {
//   //
//   // Future<File> imageFile;
//   Image image;
//   DBHelper dbHelper;
//   List<Photo> images;

//   @override
//   void initState() {
//     super.initState();
//     images = [];
//     dbHelper = DBHelper();
//     refreshImages();
//   }

//   refreshImages() {
//     dbHelper.getPhotos().then((imgs) {
//       setState(() {
//         images.clear();
//         images.addAll(imgs);
//       });
//     });
//   }

//   pickImageFromGallery() {
//     ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
//       String imgString = Utility.base64String(imgFile.readAsBytesSync());
//       print("ccccccccIMAGESTRING IS NNNNN----->   $imgString");
//       Photo photo = Photo(0, imgString);
//       dbHelper.save(photo);

//       refreshImages();
//     });
//   }

//   gridView() {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: GridView.count(
//         crossAxisCount: 2,
//         childAspectRatio: 1.0,
//         mainAxisSpacing: 4.0,
//         crossAxisSpacing: 4.0,
//         children: images.map((photo) {
//           print(
//               "bbbbbbbbbbbbbbbbbbbbbcIMAGESTRING IS NNNNN----->   ${photo.photo_name}}");
//           return Utility.imageFromBase64String(photo.photo_name);
//         }).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               pickImageFromGallery();
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Flexible(
//               child: gridView(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
