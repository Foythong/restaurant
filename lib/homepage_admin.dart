import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/admin_detailOrder.dart';
import 'package:myapp/widget/drawer_admin.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  Widget build(BuildContext context) {
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
              child: const Text("Admin"),
            ),
          ],
        ),
      ),
      drawer: const SwitchDrawerAdmin(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
            child: Text(
              "Order List",
              style:
                  GoogleFonts.prompt(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("orders").snapshots(),
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
                  return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        int itemIndex = index + 1;
                        return ListTile(
                          onTap: () {
                            // var item = items[index].data();
                            // debugPrint(item.toString());
                            // var detailLength = item['detail'].length;
                            // debugPrint(detailLength.toString());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailOrder(items: items[index].data()),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 241, 199, 106),
                            child: Text("$itemIndex",
                                style: const TextStyle(color: Colors.black)),
                          ),
                          title: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(items[index].data()["user_id"])
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const SizedBox();
                              }
                              final userData = userSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              final userName =
                                  userData["username"] as String? ?? "Unknown";
                              return Text(userName);
                            },
                          ),
                          subtitle: Text(items[index]
                              .data()["detail"]
                              .map((item) => item["name"].toString())
                              .join(', ')),
                          trailing: Icon(Icons.arrow_right),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
