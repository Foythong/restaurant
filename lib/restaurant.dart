import 'package:flutter/material.dart';
import 'package:myapp/restaurant_screen.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({super.key});

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 250, 246, 229),
                Color.fromARGB(255, 249, 247, 241),
                Color.fromARGB(255, 255, 255, 255),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: const RestaurantScreen(),
          ),
        ));
  }
}
