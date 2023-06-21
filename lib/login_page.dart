import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/homepage_admin.dart';
import 'package:myapp/register_page.dart';
import 'package:myapp/signin_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passenable = true;
  String type = '';
  bool isButtonDisabled = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void swithRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _login() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Logged in: ${userCredential.user!.uid}');
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = userCredential.user!.uid;
        final userData = await firebase.FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (userData.exists) {
          final loginType = userData.data()!['type'];
          if (loginType == 'admin') {
            goLoginAdmin(uid);
          } else if (loginType == 'user') {
            goLoginUser(uid);
          }
        } else {
          print('User document does not exist');
        }
      } else {
        print("error");
      }
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Failed to login. Please try again.",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
            child: const Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
      print('Failed to login: $e');
    }
  }

  void goLoginUser(uid) async {
    bool isValidated = true;
    if (isValidated) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Login success",
        buttons: [
          DialogButton(
            onPressed: () {
              setLoginUser(uid);
            },
            width: 120,
            child: const Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  void goLoginAdmin(uid) async {
    bool isValidated = true;
    if (isValidated) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Login success",
        buttons: [
          DialogButton(
            onPressed: () {
              setLoginAdmin(uid);
            },
            width: 120,
            child: const Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  void setLoginUser(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      ModalRoute.withName('/'),
    );
  }

  void setLoginAdmin(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePageAdmin(),
      ),
      ModalRoute.withName('/'),
    );
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  Widget _buildEmail() {
    return Container(
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: "Enter your email",
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red, width: 2.0), // Customize error border width
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 1.0), // Customize border width
          ),
          prefixIcon: Icon(Icons.email),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your email";
          } else if (!isEmailValid(value)) {
            return "Enter a valid email address";
          }
          return null; // Return null when there are no validation errors
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      child: TextFormField(
        controller: passwordController,
        obscureText: passenable,
        decoration: InputDecoration(
          labelText: "Enter your Password",
          labelStyle: const TextStyle(color: Colors.black),
          errorStyle: const TextStyle(color: Colors.red),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red, width: 2.0), // Customize error border width
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 1.0), // Customize border width
          ),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              passenable == true ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                debugPrint("step1");
                passenable = !passenable;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "enter your password";
          } else if (value.length < 6) {
            return "Password more than 6 characters";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(top: 10, left: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: const BorderRadius.all(
                  Radius.circular(50) //                 <--- border radius here
                  ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SigninSignup(),
              )),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "images/pizza.png",
                  width: 230,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome to Restaurant",
                  style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildEmail(),
                    const SizedBox(
                      height: 25,
                    ),
                    _buildPassword()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: !isButtonDisabled
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isButtonDisabled = false;
                        });
                        await _login();
                        setState(() {
                          isButtonDisabled = true;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Colors.black, width: 3),
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.black,
                minimumSize: const Size(350, 50),
              ),
              child: Text(
                "Login",
                style: GoogleFonts.prompt(fontSize: 17.0),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: swithRegister,
                      child: Text(
                        "don't have an account?",
                        style: GoogleFonts.prompt(
                            fontSize: 18, color: Colors.amber[900]),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
