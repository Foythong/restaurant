import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common extends ChangeNotifier {
  static final Common _instance = Common._internal();
  factory Common() {
    return _instance;
  }

  Common._internal() {
    initializePersistedState();
  }

  Future<void> initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _temporaryMessage = '';
  String get temporaryMessage => _temporaryMessage;
  set temporaryMessage(String _value) {
    _temporaryMessage = _value;
  }

  List<Map<String, dynamic>> _listProduct = [];
  List<Map<String, dynamic>> get listProduct => _listProduct;
  set listProduct(List<Map<String, dynamic>> _value) {
    _listProduct = _value;
  }

  late int _totalQuantity = 0;
  int get totalQuantity => _totalQuantity;
  set totalQuantity(int value) {
    _totalQuantity = value;
  }

  late int _counter = 0;
  int get counter => _counter;
  set counter(int value) {
    _counter = value;
  }

  late int _totalPrice = 0;
  int get totalPrice => _totalPrice;
  set totalPrice(int value) {
    _totalPrice = value;
  }

  late String _getType = '';
  String get getType => _getType;
  set getType(String value) {
    _getType = value;
  }
}
