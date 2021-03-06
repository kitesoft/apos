import 'dart:convert';

import 'package:apos/src/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TambahMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(),
      child: TambahKelolaMenu(),
    );
  }
}

class TambahKelolaMenu extends StatefulWidget {
  @override
  _TambahKelolaMenuState createState() => _TambahKelolaMenuState();
}

class _TambahKelolaMenuState extends State<TambahKelolaMenu> {
  bool isStock = false;
  File _image;
  final picker = ImagePicker();
  String base64image;
  Category selectedCategory;
  List<Category> category = [Category("Makanan"), Category("Minuman")];
  Widget stockForm = Card();

  final namemenuController = TextEditingController();
  final priceController = TextEditingController();
  final cogController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();

  List<DropdownMenuItem> generateItems(List<Category> category) {
    List<DropdownMenuItem> items = [];
    for (var item in category) {
      items.add(DropdownMenuItem(
        child: Text(item.name),
        value: item,
      ));
    }
    return items;
  }

  Future getImageCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      base64image = base64Encode(_image.readAsBytesSync());
    });
  }

  Future getImageGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      base64image = base64Encode(_image.readAsBytesSync());
    });
  }

  void _showAlertImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Text("Ambil foto melalui?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'CircularStd-Bold')),
            actions: <Widget>[
              Row(children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                    color: Color.fromRGBO(54, 58, 155, 1),
                    elevation: 5,
                    onPressed: getImageGallery,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    child: Text("Galeri",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
                SizedBox(width: 10),
                RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                    color: Color.fromRGBO(54, 58, 155, 1),
                    elevation: 5,
                    onPressed: getImageCamera,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    child: Text("Kamera",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ])
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onAddMenuFormPressed() {
      if (cogController.text == "") {
        cogController.text = '0';
      }
      if (isStock == false) {
        stockController.text = '0';
      }

      BlocProvider.of<MenuBloc>(context).add(AddMenuButtonFormPressed(
          name_menu: namemenuController.text,
          category: selectedCategory.name,
          description: descriptionController.text,
          price: priceController.text,
          cog: cogController.text,
          is_stock: isStock,
          stock: stockController.text,
          imgBase64: base64image));
    }

    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state is MenuAddSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context);
          });
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Tambah Menu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: 'CircularStd-Bold'),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            extendBodyBehindAppBar: true,
            body: ModalProgressHUD(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: _image == null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(234, 234, 234, 1),
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.fastfood,
                                    color: Colors.white,
                                    size: 80,
                                  )),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2.2,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height /2.2,
                              width: MediaQuery.of(context).size.width,
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 35),
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: FloatingActionButton(
                                    backgroundColor:
                                        Color.fromRGBO(54, 58, 155, 1),
                                    onPressed: () {
                                      _showAlertImage();
                                    },
                                    tooltip: 'Ambil Gambar',
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                              ]),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60.0),
                                  topRight: Radius.circular(60.0),
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(252, 195, 108, 1),
                                      Color.fromRGBO(253, 166, 125, 1),
                                    ])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 40),
                                    child: Column(
                                      children: <Widget>[
                                        // Nama Menu
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: TextField(
                                            controller: namemenuController,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.fastfood,
                                                  color: Color.fromRGBO(
                                                      179, 179, 183, 1),
                                                ),
                                                hintText: "Nama Menu",
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        179, 179, 183, 1),
                                                    fontSize: 13.0,
                                                    fontFamily:
                                                        'CircularStd-Book'),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 16.0)),
                                          ),
                                        ),
                                        // Harga Menu
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.account_balance_wallet,
                                                  color: Color.fromRGBO(
                                                      179, 179, 183, 1),
                                                ),
                                                hintText: "Harga Menu",
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        179, 179, 183, 1),
                                                    fontSize: 13.0,
                                                    fontFamily:
                                                        'CircularStd-Book'),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 16.0)),
                                          ),
                                        ),
                                        // Harga Dasar
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: TextField(
                                            controller: cogController,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.account_balance_wallet,
                                                  color: Color.fromRGBO(
                                                      179, 179, 183, 1),
                                                ),
                                                hintText:
                                                    "Harga Dasar (Tidak Wajib Diisi)",
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        179, 179, 183, 1),
                                                    fontSize: 13.0,
                                                    fontFamily:
                                                        'CircularStd-Book'),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 16.0)),
                                          ),
                                        ),
                                        // Kategori Menu
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 20),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: DropdownButtonFormField(
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: 'Kategori Menu',
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        179, 179, 183, 1),
                                                    fontSize: 13.0,
                                                    fontFamily:
                                                        'CircularStd-Book'),
                                              ),
                                              isExpanded: true,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0,
                                                  fontFamily:
                                                      'CircularStd-Book'),
                                              value: selectedCategory,
                                              items: generateItems(category),
                                              onChanged: (item) {
                                                setState(() {
                                                  selectedCategory = item;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        // Deskripsi Menu
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: TextField(
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.description,
                                                  color: Color.fromRGBO(
                                                      179, 179, 183, 1),
                                                ),
                                                hintText: "Deskripsi Menu",
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        179, 179, 183, 1),
                                                    fontSize: 13.0,
                                                    fontFamily:
                                                        'CircularStd-Book'),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 16.0)),
                                          ),
                                        ),
                                        //Switch Stok
                                        Container(
                                          child: Row(children: <Widget>[
                                            Text(
                                              "Aktifkan Stok Menu",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontFamily:
                                                      'CircularStd-Bold'),
                                            ),
                                            SizedBox(width: 10),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                  activeColor: Colors.white,
                                                  value: isStock,
                                                  onChanged: (newValue) {
                                                    isStock = newValue;
                                                    setState(() {
                                                      if (isStock)
                                                        stockForm = Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
                                                          child: TextField(
                                                            controller:
                                                                stockController,
                                                            decoration:
                                                                InputDecoration(
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .card_giftcard,
                                                                      color: Color.fromRGBO(
                                                                          179,
                                                                          179,
                                                                          183,
                                                                          1),
                                                                    ),
                                                                    hintText:
                                                                        "Stok Menu",
                                                                    hintStyle: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            179,
                                                                            179,
                                                                            183,
                                                                            1),
                                                                        fontSize:
                                                                            13.0,
                                                                        fontFamily:
                                                                            'CircularStd-Book'),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide
                                                                            .none,
                                                                        borderRadius: BorderRadius.all(Radius.circular(
                                                                            20))),
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20.0,
                                                                        vertical:
                                                                            16.0)),
                                                          ),
                                                        );
                                                      else {
                                                        stockForm = Card();
                                                      }
                                                    });
                                                  }),
                                            ),
                                            SizedBox(width: 10),
                                            // stockForm,
                                          ]),
                                        ),
                                        // Stok Menu
                                        AnimatedSwitcher(
                                            child: stockForm,
                                            duration: Duration(seconds: 2)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 15),
                                          child: RaisedButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              color: Color.fromRGBO(
                                                  54, 58, 155, 1),
                                              elevation: 5,
                                              onPressed: () async {
                                                state is! MenuAddLoading
                                                    ? await _onAddMenuFormPressed()
                                                    : null;
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100.0))),
                                              child: Text("Tambah",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              inAsyncCall: state is MenuAddLoading,
              opacity: 0.7,
              color: Color.fromRGBO(54, 58, 155, 1),
            ));
      },
    );
  }

  Widget getImage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
                alignment: Alignment.center,
                child: ButtonTheme(
                  height: 50,
                  padding: EdgeInsets.all(15),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Color.fromRGBO(54, 58, 155, 1),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "2 pesanan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontFamily: 'CircularStd-Book'),
                              ),
                            ],
                          ),
                          Text(
                            "Rp 10.000",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'CircularStd-Bold'),
                          ),
                        ]),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 7,
                height: 50,
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(54, 58, 155, 1),
                    borderRadius: BorderRadius.circular(19)),
                child: IconButton(
                  icon: Icon(Icons.view_list),
                  iconSize: 25,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Category {
  String name;
  Category(this.name);
}
