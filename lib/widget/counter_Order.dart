import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/common.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CounterOrder extends StatefulWidget {
  const CounterOrder(
      {super.key, this.productId, this.total, this.product, this.price});

  final dynamic productId;
  final dynamic total;
  final dynamic product;
  final dynamic price;

  @override
  State<CounterOrder> createState() => _CounterOrderState();
}

class _CounterOrderState extends State<CounterOrder> {
  var counter = 1;
  @override
  void initState() {
    super.initState();

    if (widget.total != null) {
      counter = int.parse(widget.total);
    }
  }

  getTotalPrice() {
    Common().totalPrice = 0;
    for (var product in Common().listProduct) {
      int total = product["total"];
      int price = product["item"]["price"];
      Common().totalPrice += (total * price);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Common>();
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter++;
                });

                for (var product in Common().listProduct) {
                  if (product['item']['product_id'] == widget.productId) {
                    product['total'] = counter;
                    Common().update(() {
                      Common().totalQuantity = Common().totalQuantity + 1;
                    });
                  }
                }

                getTotalPrice();

                print(Common().listProduct);
              },
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
          Container(
            width: 40,
            child: Text(
              counter.toString(),
              style:
                  GoogleFonts.prompt(fontWeight: FontWeight.w400, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          // const SizedBox(width: 10.0),
          Container(
            width: 30,
            child: GestureDetector(
              onTap: () {
                if (counter > 1) {
                  setState(() {
                    counter--;
                  });
                  for (var product in Common().listProduct) {
                    if (product['item']['product_id'] == widget.productId) {
                      product['total'] = counter;
                      Common().update(() {
                        Common().totalQuantity = Common().totalQuantity - 1;
                      });
                    }
                  }

                  getTotalPrice();
                } else if (counter == 1) {
                  Common().update(() {
                    Common().totalQuantity -= int.parse(widget.total);
                    print(Common().totalQuantity);
                    Common().listProduct.remove(widget.product);
                    Common().totalPrice -= int.parse(widget.price);
                  });
                }

                print(Common().listProduct);
              },
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(),
                ),
                child: const Icon(Icons.remove),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
