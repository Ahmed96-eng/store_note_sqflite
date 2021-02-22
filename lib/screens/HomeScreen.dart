import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_app/Models/productModel.dart';
import 'package:sqflite_app/Services/DataBaseServices.dart';
import 'package:sqflite_app/Widgets/ProductListWidget.dart';
import 'package:sqflite_app/Widgets/shared_widget.dart';
import 'package:sqflite_app/screens/dashBoard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataBaseServices dataBaseServices = DataBaseServices();
  List<ProductModel> productsList = List();
  TextEditingController searchCont;
  String _searchValue = "";
  showProducts() {
    dataBaseServices.showProducts().then((products) {
      products.forEach((product) {
        productsList.add(ProductModel.fromMap(product));
      });
    });
  }

  bool _expande = false;
  @override
  void initState() {
    super.initState();
    showProducts();
    searchCont = TextEditingController();
  }

  Future<bool> _onWillPop1() async {
    return await SharedWidget.showAlertDailog(
          context: context,
          titlle: "Exit Application",
          message: "Are You Sure?",
          labelNo: "No",
          labelYes: "Yes",
          onPressNo: () => Navigator.of(context).pop(),
          onPressYes: () => exit(0),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.width / 3),
          child: Container(
            decoration: SharedWidget.dialogDecoration(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'My Products',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          border: Border.all(
                            color: Colors.amber,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: searchCont,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                            ),
                            color: Colors.black54,
                            onPressed: () {
                              searchCont.clear();
                              setState(() {
                                _searchValue = "";
                              });
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _searchValue = value;
                          });
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: dataBaseServices.showProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: productsList.length,
                        itemBuilder: (context, index) {
                          // print(
                          //     "rrrrrrrrrrrrrrrrrrrrrrrrrrr ID  ${productsList[index].id}");
                          // print(
                          //     "rrrrrrrrrrrrrrrrrrrrrrrrrrr TITlE ${productsList[index].title}");
                          // print(
                          //     "rrrrrrrrrrrrrrrrrrrrrrrrrrr IMAGE ${productsList[index].image}");
                          // print(
                          //     "rrrrrrrrrrrrrrrrrrrrrrrrrrr PRICE ${productsList[index].price}");
                          // print(
                          //     "rrrrrrrrrrrrrrrrrrrrrrrrrrr QUANTITY ${productsList[index].quantity}");
                          return productsList[index]
                                  .title
                                  .toLowerCase()
                                  .contains(searchCont.text)
                              ? ProductListWidget(
                                  title: productsList[index].title,
                                  image: productsList[index].image,
                                  price: productsList[index].price,
                                  quantity:
                                      int.parse(productsList[index].quantity),
                                  id: productsList[index].id,
                                  onPressed: () {},
                                  deleteFun: () async {
                                    SharedWidget.showAlertDailog(
                                      context: context,
                                      titlle: "Delete Product",
                                      message: "Are You Sure ?",
                                      labelNo: "No",
                                      labelYes: "Yes",
                                      onPressNo: () =>
                                          Navigator.of(context).pop(),
                                      onPressYes: () {
                                        setState(() {
                                          dataBaseServices
                                              .deleteProduct(
                                                  productsList[index].id)
                                              .then((product) =>
                                                  productsList.removeAt(index));
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  updateFun: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen(
                                                    productsList[index])));

                                    if (result == 'update') {
                                      dataBaseServices
                                          .showProducts()
                                          .then((products) {
                                        setState(() {
                                          productsList.clear();
                                          products.forEach((product) {
                                            productsList.add(
                                                ProductModel.fromMap(product));
                                          });
                                        });
                                      });
                                    }
                                  },
                                )
                              // Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //               border: Border.all(
                              //                 color: Colors.amber,
                              //                 width: 2,
                              //               ),
                              //               color: Colors.teal[100],
                              //               borderRadius:
                              //                   BorderRadius.circular(15)),
                              //           child: Padding(
                              //             padding: const EdgeInsets.symmetric(
                              //                 vertical: 10),
                              //             child: ListTile(
                              //               // leading: CircleAvatar(
                              //               //   radius: 25,
                              //               //   child:
                              //               //       Utility.imageFromBase64String(
                              //               //           productsList[index]
                              //               //               .image),
                              //               // ),
                              //               leading: Container(
                              //                 width: 100,
                              //                 height: 100,
                              //                 child: Image.memory(
                              //                   base64Decode(
                              //                       productsList[index].image ??
                              //                           null),
                              //                   fit: BoxFit.cover,
                              //                 ),
                              //               ),
                              //               trailing: IconButton(
                              //                 icon: Icon(_expande
                              //                     ? Icons.expand_less
                              //                     : Icons.expand_more),
                              //                 onPressed: () {
                              //                   setState(() {
                              //                     _expande = !_expande;
                              //                   });
                              //                 },
                              //               ),
                              //               title: Text(
                              //                 "Name : ${productsList[index].title}",
                              //                 style: TextStyle(
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.bold),
                              //               ),
                              //               subtitle: Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     "Price : ${productsList[index].price} EGP",
                              //                     style: TextStyle(
                              //                         fontSize: 18,
                              //                         fontWeight:
                              //                             FontWeight.bold),
                              //                   ),
                              //                   Text(
                              //                     "Quntity : x ${productsList[index].quantity}",
                              //                     style: TextStyle(
                              //                         fontSize: 18,
                              //                         fontWeight:
                              //                             FontWeight.bold),
                              //                   ),
                              //                 ],
                              //               ),
                              //               // onTap: widget.onPressed,
                              //             ),
                              //           ),
                              //         ),
                              //         _expande
                              //             ? Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     top: 0,
                              //                     bottom: 8,
                              //                     left: 8,
                              //                     right: 8),
                              //                 child: Container(
                              //                   padding: EdgeInsets.symmetric(
                              //                       horizontal: 15,
                              //                       vertical: 5),
                              //                   height: MediaQuery.of(context)
                              //                           .size
                              //                           .height *
                              //                       0.09,
                              //                   decoration: BoxDecoration(
                              //                       color: Colors.teal[100],
                              //                       // color: Colors.green[200],
                              //                       borderRadius:
                              //                           BorderRadius.only(
                              //                               bottomLeft: Radius
                              //                                   .circular(15),
                              //                               bottomRight:
                              //                                   Radius.circular(
                              //                                       15))),
                              //                   child: Row(
                              //                     children: [
                              //                       Expanded(
                              //                         child: ButtonWidget(
                              //                           title: 'Update',
                              //                           // onPressed: widget.updateFun,
                              //                         ),
                              //                       ),
                              //                       SizedBox(width: 15),
                              //                       Expanded(
                              //                         child: ButtonWidget(
                              //                           title: 'Delete',
                              //                           // onPressed: widget.deleteFun,
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               )
                              //           : Container(),
                              //     ],
                              //   ),
                              // )
                              : Container();
                        },
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ));
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DashBoardScreen(ProductModel('', '', '', ''))));
            if (result == 'add') {
              dataBaseServices.showProducts().then((products) {
                setState(() {
                  productsList.clear();
                  products.forEach((product) {
                    productsList.add(ProductModel.fromMap(product));
                  });
                });
              });
            }
          },
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }

  // deleteProductFun(
  //     BuildContext context, ProductModel product, int index) async {
  //   await dataBaseServices
  //       .deleteProduct(product.id)
  //       .then((product) => productsList.removeAt(index));
  // }

  // updateFunNavigator(BuildContext context, ProductModel product) async {
  //   var result = await Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => DashBoardScreen(product)));
  //   if (result == 'update') {
  //     dataBaseServices.showProducts().then((products) {
  //       productsList.clear();
  //       products.forEach((product) {
  //         productsList.add(ProductModel.fromMap(product));
  //       });
  //     });
  //   }
  // }

  // addFunNavigator(BuildContext context) async {
  //   var result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DashBoardScreen(ProductModel('', '', ''))));
  //   if (result == 'add') {
  //     dataBaseServices.showProducts().then((products) {
  //       productsList.clear();
  //       products.forEach((product) {
  //         productsList.add(ProductModel.fromMap(product));
  //       });
  //     });
  //   }
  // }
}

// return Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Column(
//     children: [
//       Card(
//         color: Colors.amber[300],
//         // margin: EdgeInsets.all(8.0),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListTile(
//             trailing: IconButton(
//               icon: Icon(_expande
//                   ? Icons.expand_less
//                   : Icons.expand_more),
//               onPressed: () {
//                 setState(() {
//                   _expande = !_expande;
//                 });
//               },
//             ),
//             title: Text(
//                 "Name : ${productsList[index].title}"),
//             subtitle: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                     "Price : ${productsList[index].price}"),
//                 Text(
//                     "Quntity : ${productsList[index].quantity} x"),
//               ],
//             ),
//             onTap: () {},
//           ),
//         ),
//       ),
//       _expande
//           ? Padding(
//               padding: const EdgeInsets.only(
//                   top: 0, bottom: 8, left: 8, right: 8),
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 15, vertical: 5),
//                 height:
//                     MediaQuery.of(context).size.height *
//                         0.1,
//                 color: Colors.green[200],
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ButtonWidget(
//                         title: 'Update',
//                         onPressed: () async {
//                           var result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       DashBoardScreen(
//                                           productsList[
//                                               index])));
//                           if (result == 'update') {
//                             dataBaseServices
//                                 .showProducts()
//                                 .then((products) {
//                               setState(() {
//                                 productsList.clear();
//                                 products
//                                     .forEach((product) {
//                                   productsList.add(
//                                       ProductModel
//                                           .fromMap(
//                                               product));
//                                 });
//                               });
//                             });
//                           }
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: ButtonWidget(
//                         title: 'Delete',
//                         onPressed: () async {
//                           setState(() {
//                             dataBaseServices
//                                 .deleteProduct(
//                                     productsList[index]
//                                         .id)
//                                 .then((product) {
//                               productsList
//                                   .removeAt(index);
//                             });
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : Container(),
//     ],
//   ),
// );
