import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/common.dart';
import 'package:myapp/description_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:myapp/order_page.dart';
import 'package:myapp/widget/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool isValidTypeAll = true;
  bool isFullList = true;

  @override
  void initState() {
    super.initState();
  }

  void _getType(String type) {
    print(type);
    Common().getType = type;
    setState(() {
      isValidTypeAll = false;
    });
  }

  void _getAllTypes(bool isValidAll) {
    print(isValidAll);
    setState(() {
      if (isValidAll == true) {
        isValidTypeAll = isValidAll;
      } else {
        isValidTypeAll = !isValidAll;
      }
      print(isValidTypeAll);
    });
  }

  List<dynamic> _searchResults = [];

  void _performSearch(String query) {
    print('_performSearch');
    _searchResults = [];
    final CollectionReference productRef =
        FirebaseFirestore.instance.collection('products');

    productRef
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size != 0) {
        setState(() {
          _searchResults.addAll(snapshot.docs);
          print(_searchResults[0].data()!['name']);
          print(_searchResults[0].data().runtimeType);
          isFullList = false;
        });
      }
    });
  }

  void order() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderPage()),
    );
  }

  void addItem(dynamic item) {
    debugPrint("add $item");
    Common().counter = 1;
    if (Common().counter > 0) {
      debugPrint("counter");
      var currentCounter = 0;
      for (var product in Common().listProduct) {
        if (product['item']['product_id'] == item["product_id"]) {
          currentCounter = product['total'];
        }
      }
      currentCounter += Common().counter;
      var data = {"total": currentCounter, "item": item};

      bool isExistingProduct = false;
      for (var product in Common().listProduct) {
        if (product["item"]['product_id'] == item["product_id"]) {
          product["total"] = currentCounter;
          isExistingProduct = true;
          break;
        }
      }

      if (!isExistingProduct) {
        Common().listProduct.add(data);
      }

      Common().totalQuantity = 0;
      for (var product in Common().listProduct) {
        Common().update(() {
          Common().totalQuantity += product["total"] as int;
        });
      }

      print(Common().listProduct);
      print(Common().totalQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Common>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.amber[700],
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: const Text("Foythong"),
            ),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 5),
              badgeAnimation: const badges.BadgeAnimation.scale(),
              badgeContent: Text(
                Common().totalQuantity.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  order();
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const SwitchDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Food Delivery",
              style:
                  GoogleFonts.prompt(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) => _performSearch(value),
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide:
                    BorderSide(width: 3, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide:
                    BorderSide(width: 3, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            onTap: () {
              //Go to the next screen
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "type of food",
                      style: GoogleFonts.prompt(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final products = snapshot.data!.docs;
                        Set<String> categorySet = Set<String>.from(
                            products.map((product) => product.get('type')));

                        List<Widget> categoryList = [];
                        for (var categoryName in categorySet) {
                          var categoryProducts = products
                              .where((product) =>
                                  product.get('type') == categoryName)
                              .toList();
                          if (categoryProducts.isNotEmpty) {
                            var iconUrl = categoryProducts[0].get('icon');

                            categoryList.add(
                              Container(
                                margin: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 10),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.amber[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    side: const BorderSide(
                                        width: 2, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    _getType(categoryName);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          iconUrl,
                                          width: 35,
                                          height: 35,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          categoryName,
                                          style: GoogleFonts.prompt(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        List<Widget> categoryAll = [
                          Container(
                            margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: 8),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.amber[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                side: const BorderSide(
                                    width: 2, color: Colors.black),
                              ),
                              onPressed: () {
                                _getAllTypes(isValidTypeAll);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/pizza1.png",
                                      width: 35,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "All",
                                      style: GoogleFonts.prompt(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ];

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          scrollDirection: Axis.horizontal,
                          children: categoryList.isEmpty
                              ? categoryAll
                              : [...categoryAll, ...categoryList],
                        );
                      }

                      return Container();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: isFullList
                      ? StreamBuilder(
                          stream: isValidTypeAll
                              ? FirebaseFirestore.instance
                                  .collection("products")
                                  .limit(10)
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection("products")
                                  .where("type", isEqualTo: Common().getType)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 7.0,
                                  ),
                                ),
                              );
                            }
                            final items = snapshot.data!.docs;
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: snapshot.data!.size,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(
                                                    item: items[index].data()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 250, 249, 244),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(2, 2),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: Image.network(
                                                items[index].data()["pic"],
                                                width: 75,
                                                height: 75,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            ListTile(
                                              title: Text(
                                                items[index].data()["name"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.prompt(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: Text(
                                                  "${items[index].data()["price"]} Bath",
                                                  style: GoogleFonts.prompt(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 35,
                                                ),
                                                onPressed: () {
                                                  addItem(items[index].data());
                                                },
                                                color: const Color.fromARGB(
                                                    255, 187, 13, 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DescriptionPage(
                                            item: _searchResults[index].data()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 250, 249, 244),
                                      borderRadius: BorderRadius.circular(50.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Image.network(
                                            _searchResults[index].data()["pic"],
                                            width: 75,
                                            height: 75,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        ListTile(
                                          title: Text(
                                            _searchResults[index]
                                                .data()["name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.prompt(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                              "${_searchResults[index].data()["price"]} Bath",
                                              style: GoogleFonts.prompt(
                                                  fontWeight: FontWeight.w500)),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.add_circle,
                                              size: 35,
                                            ),
                                            onPressed: () {
                                              addItem(
                                                  _searchResults[index].data());
                                            },
                                            color: const Color.fromARGB(
                                                255, 187, 13, 13),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
