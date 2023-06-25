import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/common.dart';
import 'package:myapp/widget/counter.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({
    Key? key,
    this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addtoCart() {
    if (Common().counter > 0) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "add to cart success",
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              if (Common().counter > 0) {
                var currentCounter = 0;
                for (var product in Common().listProduct) {
                  if (product['item']['product_id'] ==
                      widget.item["product_id"]) {
                    currentCounter = product['total'];
                  }
                }
                currentCounter += Common().counter;
                var data = {"total": currentCounter, "item": widget.item};

                bool isExistingProduct = false;
                for (var product in Common().listProduct) {
                  if (product["item"]['product_id'] ==
                      widget.item["product_id"]) {
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

                Navigator.pop(context);
              }
            },
            color: Colors.amber[500],
          ),
        ],
      ).show();
    } else if (Common().counter == 0) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Please press to increase the number of products.",
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.amber[500],
          ),
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Common>();
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.amber[700],
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.network(
                  widget.item["pic"],
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    widget.item["name"],
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  )),
                  Text(
                    "${widget.item["price"]} Bath",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "By Foythong",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  Counter(
                    productId: widget.item['product_id'],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ReadMoreText(
                    widget.item["detail"],
                    trimLines: 3,
                    style:
                        GoogleFonts.prompt(color: Colors.black, fontSize: 13),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Read more',
                    trimExpandedText: ' Less',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(30),
                color: Colors.amber[600],
                child: InkWell(
                  onTap: addtoCart,
                  child: SizedBox(
                    height: kToolbarHeight,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Add to cart',
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
