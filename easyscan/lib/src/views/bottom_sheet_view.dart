// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({
    super.key,
    required this.customer,
    required this.orders,
    required this.accessToken,
  });
  static const routeName = '/bottomSheet_view';
  final Map customer;
  final List<Map<String, dynamic>> orders;
  final String accessToken;

  Future<void> postOrders(BuildContext context) async {
    const String apiUrl = 'https://api.fortnox.se/3/orders';

    //for (var order in orders) {
    try {
      final orderPayload = {
        "Order": {
          "CustomerName": customer['Name'],
          "CustomerNumber": customer['CustomerNumber'],
          "OrderRows": [
            for (var order in orders)
              {
                "ArticleNumber": order['ArticleNumber'],
                "Description": order['Description'],
              }
          ],
        }
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(orderPayload),
      );

      if (response.statusCode == 201) {
        debugPrint('Order for ${customer['Name']} sent successfully');
      } else {
        throw Exception(
            'Failed to post order for ${customer['Name']}. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error when posting order for ${customer['Name']}: $e');

      // Handle the error here:
      // 1. Show a snackbar or dialog to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting order for ${customer['Name']}')),
      );
      // 2. Optionally retry the failed order
      // 3. Log the error for further analysis
      // ...
    }

    // All orders processed, even if some failed
    if (!context.mounted) return; // Check if context is still valid
    Navigator.pop(context, true); // Indicate that the process is complete
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order processed successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final orders = customer.orders;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Bekräfta order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text("${order['Description']} "),
                    subtitle: Text(
                      "Artikelnummer: ${order['ArticleNumber']}",
                      style: const TextStyle(color: Color(0xff8E8A91)),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(175, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: const Color(0xffEEB53A),
                foregroundColor: const Color(0xff39328F),
              ),
              // Här kan du hantera bekräftelselogik baserat på isCheckedList
              onPressed: () {
                postOrders(context);
              },
              child: const Text(
                'Bekräfta',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
