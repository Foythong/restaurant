import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/common.dart';
import 'package:myapp/widget/checkout.dart';
// import 'package:myapp/widget/counter.dart';
import 'package:myapp/widget/counter_Order.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, this.item});

  final dynamic item;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    getTotalPrice();
  }

  getTotalPrice() {
    Common().totalPrice = 0;
    for (var product in Common().listProduct) {
      int total = product["total"];
      int price = product["item"]["price"];
      Common().totalPrice += (total * price);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Common>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.amber[700],
        elevation: 1,
        title: Text(
          "My order",
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (Common().listProduct.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: Common().listProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = Common().listProduct[index];
                  String name = product['item']['name'].toString();
                  String price = product['item']['price'].toString();
                  String pic = product['item']['pic'].toString();
                  String productId = product['item']['product_id'].toString();
                  String total = product['total'].toString();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        border: Border.all(
                          width: 3,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10, bottom: 10),
                                child: Image.network(
                                  pic,
                                  width: 100,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.prompt(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "by Foythong",
                                        style: GoogleFonts.prompt(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "${price} BTH",
                                        style: GoogleFonts.prompt(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CounterOrder(
                                  key: GlobalKey(),
                                  productId: productId,
                                  total: total,
                                  product: product,
                                  price: price),
                            ],
                          ),
                          Positioned(
                            left: 325,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                Common().update(() {
                                  Common().totalQuantity =
                                      Common().totalQuantity - int.parse(total);
                                  print(Common().totalQuantity);
                                  Common().listProduct.remove(product);
                                });
                                getTotalPrice();
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No order available',
                      style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.amber,
                    size: 100,
                  )
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Common().totalQuantity != 0 ? "total" : '',
                      style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500, fontSize: 20)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Common().totalQuantity != 0
                        ? Common().totalQuantity.toString()
                        : '',
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Common().totalQuantity != 0 ? "total price" : '',
                      style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500, fontSize: 20)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Common().totalPrice != 0
                        ? "${Common().totalPrice.toString()} THB"
                        : '',
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const bottomCheckout(),
    );
  }
}
