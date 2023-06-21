import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/register_page.dart';

class SigninSignup extends StatelessWidget {
  const SigninSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Food delivery app",
                style: GoogleFonts.prompt(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            Text("Foythong",
                style: GoogleFonts.prompt(
                  color: Colors.black54,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 10.0,
            ),
            Image.asset(
              "images/logo.png",
              width: 350,
            ),
            const SizedBox(
              height: 10.0,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Colors.black, width: 3),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(300, 50),
              ),
              child: Text(
                "Login",
                style: GoogleFonts.prompt(fontSize: 17.0),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Colors.black, width: 3),
                backgroundColor: Colors.amber[500],
                foregroundColor: Colors.black,
                minimumSize: const Size(300, 50),
              ),
              child: Text(
                "Register",
                style: GoogleFonts.prompt(fontSize: 17.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
