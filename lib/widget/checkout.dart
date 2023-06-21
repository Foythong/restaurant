import 'package:flutter/material.dart';
import 'package:myapp/common.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomCheckout extends StatefulWidget {
  const bottomCheckout({super.key});

  @override
  State<bottomCheckout> createState() => _bottomCheckoutState();
}

class _bottomCheckoutState extends State<bottomCheckout> {
  String? uid;

  void initState() {
    super.initState();
    getUser();
    CheckOrder();
  }

  void CheckOrder() {
    for (var product in Common().listProduct) {
      var item = product['product_id'];
    }
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    debugPrint('User ID: $uid');
    setState(() {});
  }

  void addOrder() async {
    var total = Common().totalQuantity;
    var totalPrice = Common().totalPrice;
    var orderId = FirebaseFirestore.instance.collection('orders').doc().id;

    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    final users = snapshot.docs;
    final userid = uid;
    var data = [];

    for (var product in Common().listProduct) {
      var name = product['item']['name'];
      var price = product['item']['price'];
      var total = product['total'];
      var pic = product['item']['pic'];

      data.add({"name": name, "price": price, "total": total, "pic": pic});
    }

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'order_id': orderId,
        'user_id': userid,
        'detail': data,
        'total': total,
        'total_price': totalPrice,
      });

      print('Data successfully written to Firestore!');
    } catch (error) {
      print('Failed to write data to Firestore: $error');
    }

    Common().update(() {
      Common().totalPrice = 0;
      Common().totalQuantity = 0;
      Common().listProduct.clear();
    });
  }

  void Error() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "You haven't placed an order yet.",
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  void Cart() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "checkout success",
      buttons: [
        DialogButton(
          onPressed: () async {
            addOrder();
            Navigator.of(context).pop();
          },
          width: 120,
          child: const Text(
            "SUCCESS",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              color: Colors.amber[600],
              child: InkWell(
                onTap: () {
                  if (Common().listProduct.isNotEmpty) {
                    Cart();
                  } else {
                    Error();
                  }
                },
                child: SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Checkout',
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
    );
  }
}
