import 'dart:convert';
import 'package:easyscan/src/services/auth_service.dart';
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
  List<dynamic> orders = [];
  final AuthService authService = AuthService();

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
        }
        setState(() {
          orders = responseBody['Orders']
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
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> fetchArticles(String documentNumber) async {
    String? accessToken = await authService.getStoredToken('accessToken');
    String? refreshToken = await authService.getStoredToken('refreshToken');

    if (accessToken == null || !(await authService.isAccessTokenValid())) {
      if (refreshToken != null) {
        accessToken = await authService.refreshAccessToken(refreshToken);
      } else {
        // Handle the case where both tokens are invalid or missing
        throw Exception('No valid tokens available');
      }
    }

    final String apiUrl = 'https://api.fortnox.se/3/orders/$documentNumber';

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
        setState(() {
          orders = responseBody['Order']['OrderRows'];
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
        body: Center(
          child: orders.isEmpty
              ? const Text(
                  'Inga order än',
                  style: TextStyle(fontSize: 18),
                )
              : Column(
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
                                      /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddProductScreen(product: order),
                                  ),
                                ); */
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
                              title: Text(
                                  "${order['Description']} - ${order['Unit']} x ${order['Price']} "),
                              subtitle: Text(
                                "Artikelnummer: ${order['ArticleNumber']}",
                                style:
                                    const TextStyle(color: Color(0xff8E8A91)),
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
                                builder: (context) =>
                                    BottomSheetView(c: widget.customer),
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
                              Navigator.restorablePushNamed(
                                  context, ScanView.routeName);
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
        ),
      ),
    );
  }
}
