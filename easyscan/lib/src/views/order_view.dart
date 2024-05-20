import 'dart:convert';
import 'package:easyscan/src/data/customer_data.dart';
import 'package:easyscan/src/views/scan_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'add_product_view.dart';
import 'bottom_sheet_view.dart';
import 'package:http/http.dart' as http;

class OrdersView extends StatefulWidget {
  final String accessToken;
  final Map customer;

  const OrdersView({
    super.key,
    required this.accessToken,
    required this.customer,
  });

  static const routeName = '/orders_view';

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  dynamic orders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchOrders(widget.customer['CustomerNumber']);
  }

  Future<void> fetchOrders(String customerNumber) async {
    const String apiUrl = 'https://api.fortnox.se/3/orders';
    final String accessToken = widget.accessToken;

    if (kDebugMode) {
      print('OrdersView accessToken: $accessToken');
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (kDebugMode) {
          print('Response body: $responseBody');
          print('Response body fetchOrders : ${responseBody['OrderRows']}');
        }
        setState(() {
          orders = (responseBody['Orders'] as List)
              .where((order) => order['CustomerNumber'] == customerNumber)
              .toList();
        });

        if (orders.isNotEmpty) {
          // Fetch articles for the first order as an example
          fetchArticles(orders[0]['DocumentNumber']);
        }
      } else {
        if (kDebugMode) {
          print('Failed to load orders: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchArticles(String documentNumber) async {
    if (kDebugMode) {
      print('Response body: fetchArticles');
    }
    final String apiUrl = 'https://api.fortnox.se/3/orders/$documentNumber';
    final String accessToken = widget.accessToken;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (kDebugMode) {
          print('Response body: $responseBody');
          print('Response body: ${responseBody['OrderRows']}');
        }
        setState(() {
          orders = responseBody['OrderRows'];
        });
      } else {
        if (kDebugMode) {
          print('Failed to load orders: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error: $e');
    }
    if (kDebugMode) {
      print('fetchArticles orders: $orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders for ${widget.customer['Name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddProductScreen(customer: widget.customer),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];

                  return ListTile(
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: order,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddProductScreen(product: order),
                              ),
                            );
                          },
                          child: const Text('Redigera'),
                        ),
                        PopupMenuItem(
                          value: order,
                          onTap: () {
                            setState(() {
                              orders.remove(order);
                            });
                          },
                          child: const Text('Ta bort'),
                        ),
                      ],
                    ),
                    title: Text("${order['sent']} - ${order['quantity']} kg"),
                    subtitle: Text(
                      "Artikelnummer: ${order['productNumber']}",
                      style: const TextStyle(color: Color(0xff8E8A91)),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: const Color(0xffEEB53A),
                    foregroundColor: const Color(0xff39328F),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      context: context,
                      builder: (context) => BottomSheetView(c: widget.customer),
                    );
                  },
                  child: const Text(
                    'Beställ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(175, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: const Color(0xff39328F),
                    foregroundColor: const Color(0xffCAC4D0),
                  ),
                  onPressed: () {
                    Navigator.restorablePushNamed(context, ScanView.routeName);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Color.fromARGB(255, 216, 212, 212),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Skanna',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
