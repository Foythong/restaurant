import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/signin_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  Future<void> swithScreen() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninSignup()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userStatus = prefs.containsKey('uid');
    if (userStatus) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        ModalRoute.withName('/'),
      );
    }
    print("check login:");
    print(userStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("images/screen.png"),
          Text(
            "The Fastest Food",
            style:
                GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 28),
            textAlign: TextAlign.center,
          ),
          Text(
            "Deliverry App in Foythong",
            style: GoogleFonts.prompt(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Text(
              "Pick your desined food items from the menu there are more than 200 item",
              style: GoogleFonts.prompt(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black, width: 3),
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 20)),
            onPressed: swithScreen,
            child: Text(
              "Let's go",
              style: GoogleFonts.prompt(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
