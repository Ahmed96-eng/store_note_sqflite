import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_app/Services/Utility.dart';
import 'package:sqflite_app/Widgets/ButtonWidget.dart';
import 'package:sqflite_app/Widgets/shared_widget.dart';

class ProductListWidget extends StatefulWidget {
  int id;
  String title;
  String price;
  int quantity;
  String image;
  Function onPressed;
  Function deleteFun;
  Function updateFun;
  ProductListWidget(
      {this.id,
      this.title,
      this.price,
      this.quantity,
      this.image,
      this.onPressed,
      this.deleteFun,
      this.updateFun});
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  bool _expande = false;

  @override
  Widget build(BuildContext context) {
    // final expand = Provider.of<BoolProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                // leading: CircleAvatar(
                //   radius: 25,
                //   child: Utility.imageFromBase64String(widget.image),
                // ),
                leading: Container(
                  // alignment: Alignment.centerLeft,
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(45),
                    image: DecorationImage(
                        image: MemoryImage(base64Decode(widget.image),
                            scale: 1.5)),
                  ),
                  // child: Image.memory(
                  //   base64Decode(widget.image),
                  //   fit: BoxFit.fill,
                  // ),
                ),
                trailing: IconButton(
                  icon: Icon(_expande ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expande = !_expande;
                    });
                  },
                ),
                title: Text(
                  "Name : ${widget.title}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price : ${widget.price} EGP",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Quntity : x ${widget.quantity}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: widget.onPressed,
              ),
            ),
          ),
          _expande
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 8, left: 8, right: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.teal[100],
                        // color: Colors.green[200],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            title: 'Update',
                            onPressed: widget.updateFun,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ButtonWidget(
                            title: 'Delete',
                            onPressed: widget.deleteFun,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
