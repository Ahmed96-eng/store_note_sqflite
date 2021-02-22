import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_app/Models/productModel.dart';
import 'package:sqflite_app/Providers/boolProvider.dart';
import 'package:sqflite_app/Services/DataBaseServices.dart';
import 'package:sqflite_app/Services/Utility.dart';
import 'package:sqflite_app/Widgets/ButtonWidget.dart';
import 'package:sqflite_app/Widgets/shared_widget.dart';
import 'package:sqflite_app/Widgets/testFormField_widget.dart';

class DashBoardScreen extends StatefulWidget {
  ProductModel product;
  DashBoardScreen(this.product);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  DataBaseServices dataBaseServices = DataBaseServices();
  final _priceFoucsNode = FocusNode();
  final _stockQuantityFoucsNode = FocusNode();
  // final _descriptionFoucsNode = FocusNode();
  final _nameFoucsNode = FocusNode();
  // final _categoryFoucsNode = FocusNode();
  TextEditingController titleController;
  TextEditingController priceController;
  TextEditingController quantityController;
  File _file;
  ImagePicker picker = ImagePicker();
  String image;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    image = widget.product.image.toString();
  }

  Future<void> _submit() async {
    final provider = Provider.of<BoolProvider>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    provider.changeLoadingValue(true);

    if (widget.product.id != null) {
      //update
      try {
        dataBaseServices
            .updateProduct(ProductModel.fromMap({
          "id": widget.product.id,
          "title": titleController.text.toString(),
          "price": priceController.text.toString(),
          "quantity": quantityController.text.toString(),
          "image": image,
        }))
            .then((_) {
          SharedWidget.showToastMsg('Update Success', time: 3);
          Navigator.pop(context, 'update');
        });
      } catch (e) {
        print('Error message is  $e');
      }
    } else {
      //add
      try {
        ProductModel product = ProductModel(titleController.text,
            priceController.text, quantityController.text, image);
        dataBaseServices.addProduct(product).then((_) {
          SharedWidget.showToastMsg('Add Success', time: 3);
          Navigator.pop(context, 'add');
        });
      } catch (e) {
        print('Error message is  $e');
      }

      provider.changeLoadingValue(false);
    }
  }

  // pickImageFromGallery() {
  //   ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
  //     String imgString = Utility.base64String(imgFile.readAsBytesSync());
  //   });
  // }

  Future<void> _showUploadDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("from where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () async {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((imgFile) {
                          image =
                              Utility.base64String(imgFile.readAsBytesSync());
                        });

                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text('Camera'),
                      onTap: () async {
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((imgFile) {
                          image =
                              Utility.base64String(imgFile.readAsBytesSync());
                        });

                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  @override
  void dispose() {
    _priceFoucsNode.dispose();
    _stockQuantityFoucsNode.dispose();
    // _descriptionFoucsNode.dispose();
    _nameFoucsNode.dispose();
    // _categoryFoucsNode.dispose();
    quantityController.dispose();
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DashBoard',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: SharedWidget.dialogDecoration(),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: image == null || image == ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: RaisedButton.icon(
                                      icon: Icon(Icons.file_upload),
                                      label: Text(
                                        "Select Image",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      ),
                                      onPressed: () async {
                                        setState(() {});
                                        _showUploadDialog(context);
                                      }),
                                )
                              : Container(
                                  // decoration: new BoxDecoration(color: Colors.white),
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[300],
                                      border: Border.all(
                                          color: Colors.redAccent
                                              .withOpacity(0.4))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: <Widget>[
                                        // Utility.imageFromBase64String(image),
                                        Image.memory(
                                          base64Decode(image),
                                          fit: BoxFit.fill,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        Positioned(
                                          top: 5,
                                          right:
                                              5, //give the values according to your requirement
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.grey[500],
                                                border: Border.all(
                                                    color: Colors.redAccent
                                                        .withOpacity(0.4))),
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    image = null;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      TextFormFieldWidget(
                        controller: titleController,
                        hintDecoration: 'product name',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the name Please!';
                          }
                        },
                        focusNode: _nameFoucsNode,
                        onSumbit: (_) {
                          FocusScope.of(context).requestFocus(_priceFoucsNode);
                        },
                      ),
                      TextFormFieldWidget(
                        controller: priceController,
                        // initialValue: _initialData[kProductPrice].toString(),
                        hintDecoration: 'product price',
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the price Please!';
                          }
                          if (priceController.text.contains('-')) {
                            return 'Enter the correct price Please!';
                          }
                        },
                        focusNode: _priceFoucsNode,
                        onSumbit: (_) {
                          FocusScope.of(context)
                              .requestFocus(_stockQuantityFoucsNode);
                        },
                      ),
                      widget.product.id == null
                          ? TextFormFieldWidget(
                              controller: quantityController,
                              // initialValue:
                              //     _initialData[kProductStockQuantity].toString(),
                              hintDecoration: 'product quantity',
                              keyboardType: TextInputType.numberWithOptions(),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter the quantity Please!';
                                }
                                if (quantityController.text.contains('-')) {
                                  return 'Enter the correct quantity Please!';
                                }
                              },
                              focusNode: _stockQuantityFoucsNode,
                              // onSumbit: (_) {
                              //   FocusScope.of(context)
                              //       .requestFocus(_descriptionFoucsNode);
                              // },
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          quantityController.text = (int.parse(
                                                      quantityController.text) +
                                                  1)
                                              .toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      quantityController.text.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (int.parse(
                                                  quantityController.text) >
                                              0) {
                                            quantityController.text =
                                                (int.parse(quantityController
                                                            .text) -
                                                        1)
                                                    .toString();
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                      // TextFormFieldWidget(
                      //   // initialValue: _initialData[kProductDescription],
                      //   hintDecoration: 'product description',
                      //   keyboardType: TextInputType.name,
                      //   textInputAction: TextInputAction.done,
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Enter the description Please!';
                      //     }
                      //   },
                      //   focusNode: _descriptionFoucsNode,

                      // ),
                      SizedBox(height: 30),
                      ButtonWidget(
                        title: widget.product.id != null
                            ? 'Update Product'
                            : 'Add Product',
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
