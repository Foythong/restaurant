import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({
    Key? key,
    required this.items,
  }) : super(key: key);

  final dynamic items;

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: const Text("Order detail"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  widget.items.length > 0 ? widget.items['detail'].length : 0,
              itemBuilder: (BuildContext context, int index) {
                var detail = widget.items['detail'][index];

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  child: Card(
                    color: Colors.amber[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Image.network(
                                      detail['pic'].toString(),
                                      width: 100,
                                      height: 90,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail['name'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.prompt(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${detail['price'].toString()} THB",
                                        style: GoogleFonts.prompt(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${detail['total'].toString()} total",
                                        style: GoogleFonts.prompt(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("total",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500, fontSize: 20)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.items['total']?.toString() ?? '',
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
                Text("total price",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w500, fontSize: 20)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.items['total_price']?.toString() ?? '',
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
      bottomNavigationBar: Container(
        height: 56,
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.amber,
                child: Text("SUBMIT",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
