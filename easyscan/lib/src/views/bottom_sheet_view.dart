import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// class BottomSheetView extends StatelessWidget {
//   const BottomSheetView({
//     super.key,
//     required this.customer,
//     required this.orders,
//     required this.accessToken,
//   });
//   static const routeName = '/bottomSheet_view';
//   final Map customer;
//   final List<Map<String, dynamic>> orders;
//   final String accessToken;

//   Future<void> postOrders() async {
//     const String apiUrl = 'https://api.fortnox.se/3/orders';
//     try {
//       for (var order in orders) {
//         final orderPayload = {
//           "Order": {
//             "CustomerName": customer['Name'],
//             "CustomerNumber": customer['CustomerNumber'],
//             "OrderRows": [
//               {
//                 "ArticleNumber": order['ArticleNumber'],
//                 "Description": order['Description'],
//                 // Add other fields as necessary
//               }
//             ],
//             // Add other fields as necessary
//           }
//         };

//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//             'Content-Type': 'application/json',
//           },
//           body: json.encode(orderPayload),
//         );
//         if (kDebugMode) {
//           print('Order sent');
//           print('response body: ${response.body}');
//         }

//         if (response.statusCode != 201) {
//           throw Exception('Failed to post order for ${customer['Name']}');
//         } else {
//           debugPrint('Order sent');
//           debugPrint(response.body);
//           orders.clear();
//         }
//       }
//     } catch (e) {
//       debugPrint('Error when posting order: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final orders = customer.orders;
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               'Bekräfta order',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 6.0),
//               child: ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final order = orders[index];
//                   return ListTile(
//                     title: Text("${order['Description']} "),
//                     subtitle: Text(
//                       "Artikelnummer: ${order['ArticleNumber']}",
//                       style: const TextStyle(color: Color(0xff8E8A91)),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 30, top: 15),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(175, 60),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 backgroundColor: const Color(0xffEEB53A),
//                 foregroundColor: const Color(0xff39328F),
//               ),
//               // Här kan du hantera bekräftelselogik baserat på isCheckedList
//               onPressed: () {
//                 postOrders();
//               },
//               child: const Text(
//                 'Bekräfta',
//                 style: TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
    bool orderSent = false;
    const String apiUrl = 'https://api.fortnox.se/3/orders';
    try {
      for (var order in orders) {
        final orderPayload = {
          "Order": {
            "CustomerName": customer['Name'],
            "CustomerNumber": customer['CustomerNumber'],
            "OrderRows": [
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

        if (response.statusCode != 201) {
          throw Exception('Failed to post order for ${customer['Name']}');
        } else {
          debugPrint('Order sent sucessfully');
          debugPrint(response.body);
          orderSent = true;
          if (!context.mounted) return;
          Navigator.pop(context, orderSent);
        }
      }
    } catch (e) {
      debugPrint('Error when posting order: $e');
    }
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
