import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/signin_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passenable = true;
  bool isButtonDisabled = true;

  void swithLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void gotologin() async {
    bool isValidated = true;
    if (isValidated) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Register success",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
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

  registerFirebase() async {
    try {
      String username = usernameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String type = "user";

      // ตรวจสอบว่ามีบัญชีอีเมล์นี้อยู่แล้วหรือไม่
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userData.docs.isNotEmpty) {
        print('บัญชีซ้ำ: อีเมล์นี้มีบัญชีอยู่แล้ว');
        Alert(
          context: context,
          type: AlertType.error,
          title: "This email already has an account.",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: 120,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ).show();
      } else {
        // ลงทะเบียนผู้ใช้ใน Firebase Authentication
        var userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print('Registration successful: ${userCredential.user!.uid}');

        // เพิ่มข้อมูลผู้ใช้ในคอลเลกชัน "users" ใน Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'user_id': userCredential.user!.uid,
          'email': email,
          'username': username,
          'type': type,
        });

        gotologin();

        print('Username added: $username');
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  Widget _buildUsername() {
    return Container(
      child: TextFormField(
        controller: usernameController,
        decoration: const InputDecoration(
          labelText: "Enter your username",
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
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "enter your username";
          }
          return null; // Return null when there are no validation errors
        },
      ),
    );
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
            return "enter your email";
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
          labelText: "Enter your password",
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
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Register",
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildUsername(),
                    const SizedBox(
                      height: 25,
                    ),
                    _buildEmail(),
                    const SizedBox(
                      height: 25,
                    ),
                    _buildPassword()
                  ],
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
                          await registerFirebase();
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
                  "Register",
                  style: GoogleFonts.prompt(fontSize: 17.0),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 15),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: swithLogin,
                        child: Text(
                          "do you have account?",
                          style: GoogleFonts.prompt(
                              fontSize: 18, color: Colors.amber[900]),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
