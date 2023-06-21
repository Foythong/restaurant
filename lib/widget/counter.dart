import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/common.dart';
import 'package:provider/provider.dart';

class Counter extends StatefulWidget {
  const Counter({super.key, this.productId, this.product_id,this.total});

  final dynamic productId;
  final dynamic product_id;
  final dynamic total;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  void initState() {
    super.initState();
    Common().counter = 0;

    if(widget.total != null){
      Common().counter = int.parse(widget.total);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Common>();
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Common().update(() {
                Common().counter++;
              });
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
          const SizedBox(width: 15.0),
          Text(
            Common().counter.toString(),
            style:
                GoogleFonts.prompt(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          const SizedBox(width: 15.0),
          GestureDetector(
            onTap: () {
              if (Common().counter > 0) {
                Common().update(() {
                  Common().counter--;
                });
              }
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
        ],
      ),
    );
  }
}
