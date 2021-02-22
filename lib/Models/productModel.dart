import 'dart:io';

class ProductModel {
  int _id;
  String _title;
  String _price;
  String _quantity;
  String _image;
  ProductModel(this._title, this._price, this._quantity, this._image);

  int get id => _id;
  String get title => _title;
  String get price => _price;
  String get quantity => _quantity;
  String get image => _image;

  ProductModel.map(dynamic map) {
    this._id = map['id'];
    this._title = map['title'];

    this._price = map['price'];
    this._quantity = map['quantity'];
    this._image = map['image'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    // map['id'] = _id;
    map['title'] = _title;

    map['price'] = _price.toString();
    map['quantity'] = _quantity.toString();
    map['image'] = _image.toString();

    return map;
  }

  ProductModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'].toString();

    this._price = map['price'].toString();
    this._quantity = map['quantity'].toString();
    this._image = map['image'].toString();
  }
}
