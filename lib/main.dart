import 'package:flutter/material.dart';
import 'package:myapp/common.dart';
import 'package:myapp/restaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final common = Common();
  runApp(
    ChangeNotifierProvider(
      create: (context) => common,
      child: const Restaurant(),
    ),
  );
}
