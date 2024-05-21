import 'dart:convert';
import 'package:easyscan/src/services/auth_service.dart';
import 'package:easyscan/src/views/scan_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> fetchOrders(String customerNumber) async {
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

        List<dynamic> orders = responseBody['Orders']
            .where((order) =>
                order['CustomerNumber'] == customerNumber &&
                order['Sent'] == false)
            .toList();

        int totalPrice = 0;
        if (orders.isNotEmpty) {
          // Fetch articles for the first order as an example
          Map<String, dynamic> orderDetails =
              await fetchArticles(orders[0]['DocumentNumber']);
          orders = orderDetails['OrderRows'];
          totalPrice = orderDetails['Total'];
        }

        return {'orders': orders, 'totalPrice': totalPrice};
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
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchArticles(String documentNumber) async {
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
        return {
          'OrderRows': responseBody['Order']['OrderRows'],
          'Total': responseBody['Order']['Total'],
        };
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order för ${widget.customer['Name']}'),
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchOrders(widget.customer['CustomerNumber']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final orders = snapshot.data!['orders'] as List<dynamic>;
              final totalPrice = snapshot.data!['totalPrice'] as int;

              // Format the total price
              final formattedPrice = NumberFormat.currency(
                locale: 'sv_SE', // Use the appropriate locale
                symbol: 'kr', // Use the appropriate currency symbol
              ).format(totalPrice);

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Center(
                        child: orders.isEmpty
                            ? const Text(
                                'Inga order än',
                                style: TextStyle(fontSize: 18),
                              )
                            : ListView.builder(
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
                                            // Edit order
                                          },
                                          child: const Text('Redigera'),
                                        ),
                                        PopupMenuItem(
                                          value: order,
                                          onTap: () {
                                            setState(() {
                                              orders.removeAt(index);
                                              //totalPrice -= order['Price'];
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
                                      style: const TextStyle(
                                          color: Color(0xff8E8A91)),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 27.0, right: 27, bottom: 10, top: 10),
                    child: orders.isNotEmpty
                        ? Row(
                            children: [
                              Text(
                                'Pris: $formattedPrice',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(4),
                                fixedSize: const Size(170, 65),
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
                                padding: const EdgeInsets.all(4),
                                fixedSize: const Size(170, 65),
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
                              child: const ListTile(
                                contentPadding: EdgeInsets.only(left: 18),
                                title: Text(
                                  softWrap: false,
                                  'Skanna',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.qr_code_scanner,
                                  color: Color.fromARGB(255, 216, 212, 212),
                                ),
                                trailing: null,
                              ),
                              /* Icon(
                                Icons.qr_code_scanner,
                                color: Color.fromARGB(255, 216, 212, 212),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Skanna',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ), */
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
