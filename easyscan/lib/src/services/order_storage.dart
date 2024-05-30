import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOrdersToPreferences(
    String customerNumber, List<Map<String, dynamic>> orders) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('orders_$customerNumber', jsonEncode(orders));
}

Future<List<Map<String, dynamic>>> loadOrdersFromPreferences(
    String customerNumber) async {
  final prefs = await SharedPreferences.getInstance();
  final String? ordersString = prefs.getString('orders_$customerNumber');
  if (ordersString != null) {
    return List<Map<String, dynamic>>.from(jsonDecode(ordersString));
  } else {
    return [];
  }
}

Future<void> clearOrdersFromPreferences(String customerNumber) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('orders_$customerNumber');
}
