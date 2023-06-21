import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/order_page.dart';
import 'package:myapp/signin_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchDrawerAdmin extends StatefulWidget {
  const SwitchDrawerAdmin({super.key});

  @override
  State<SwitchDrawerAdmin> createState() => _SwitchDrawerAdminState();
}

class _SwitchDrawerAdminState extends State<SwitchDrawerAdmin> {
  String adminEmail = '';
  String adminName = '';
  String? userId;

  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid');
    debugPrint('User ID: $userId');
    setState(() {});
  }

  void logOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');

      await FirebaseAuth.instance.signOut();
      print('ออกจากระบบแล้ว');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SigninSignup(),
        ),
        (route) => false,
      );
    } catch (e) {
      print('เกิดข้อผิดพลาดในการออกจากระบบ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.red),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('เกิดข้อผิดพลาดในการดึงข้อมูล');
                  }

                  //  if (!snapshot.hasData) {
                  //   return const
                  // }

                  if (snapshot.connectionState == ConnectionState.waiting) {
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

                  if (snapshot.hasData) {
                    var user = snapshot.data!.data() as Map<String, dynamic>?;
                    if (user != null) {
                      var userEmail = user['email'] as String?;
                      var userName = user['username'] as String?;
                      debugPrint('User email: $userEmail');
                      debugPrint('User name: $userName');

                      return UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 228, 158, 30),
                        ),
                        accountName: Text(userName ?? ''),
                        accountEmail: Text(userEmail ?? ''),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            userName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.prompt(
                              color: Color.fromARGB(255, 60, 46, 6),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  return Text('ไม่พบข้อมูลผู้ใช้งาน');
                },
              ),
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout),
                onTap: logOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
