import 'package:easyscan/src/services/auth_service.dart';
import 'package:easyscan/src/services/order_storage.dart';
import 'package:easyscan/src/views/load_articles.dart';
import 'package:easyscan/src/views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_product_view.dart';
import 'bottom_sheet_view.dart';

class OrderView extends StatefulWidget {
  final String accessToken;
  final Map customer;

  const OrderView({
    super.key,
    required this.accessToken,
    required this.customer,
  });

  static const routeName = '/order_view';

  @override
  State<OrderView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrderView> {
  final AuthService authService = AuthService();
  List<Map<String, dynamic>> orders = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    orders = await loadOrdersFromPreferences(widget.customer['CustomerNumber']);
    calculateTotalPrice();
    setState(() {});
  }

  void addArticle(Map<String, dynamic> order) {
    setState(() {
      orders.add(order);
      saveOrdersToPreferences(widget.customer['CustomerNumber'], orders);
      calculateTotalPrice();
    });
  }

  void updateOrder(int index, Map<String, dynamic> updatedOrder) {
    setState(() {
      orders[index] = updatedOrder;
      saveOrdersToPreferences(widget.customer['CustomerNumber'], orders);
      calculateTotalPrice();
    });
  }

  void removeArticle(Map<String, dynamic> order) {
    setState(() {
      orders.remove(order);
      saveOrdersToPreferences(widget.customer['CustomerNumber'], orders);
      calculateTotalPrice();
    });
  }

  void clearOrders() {
    setState(() {
      orders.clear();
      clearOrdersFromPreferences(widget.customer['CustomerNumber']);
      totalPrice = 0.0;
    });
  }

  // calc each order price
  void calculateTotalPrice() {
    totalPrice = 0;
    for (var order in orders) {
      if (order['SalesPrice'] != null) {
        final price = double.parse(order['SalesPrice']) *
            double.parse(order['OrderedQuantity']);

        totalPrice += price;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'sv_SE',
      symbol: 'kr',
    ).format(totalPrice);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order för ${widget.customer['Name']}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ArticlesView(accessToken: widget.accessToken)
                      //const AddProductScreen(),
                      ),
                );

                if (result != null) {
                  addArticle(result);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: orders.isEmpty
                    ? const Center(child: Text('Inga order änn'))
                    : ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          final order = orders[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: order,
                                  onTap: () async {
                                    final updatedArticle = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddProductScreen(article: order),
                                      ),
                                    );

                                    if (updatedArticle != null) {
                                      updateOrder(index, updatedArticle);
                                    }
                                  },
                                  child: const Text('Redigera'),
                                ),
                                PopupMenuItem(
                                  value: order,
                                  onTap: () {
                                    removeArticle(order);
                                  },
                                  child: const Text('Ta bort'),
                                ),
                              ],
                            ),
                            title: Text(
                                "${order['Description']} - ${order['OrderedQuantity']} st."),
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
              padding: const EdgeInsets.only(
                  bottom: 30, top: 16, left: 22, right: 22),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        onPressed: orders.isEmpty
                            ? null
                            : () async {
                                final orderSent = await showModalBottomSheet(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) => BottomSheetView(
                                    customer: widget.customer,
                                    orders: orders,
                                    accessToken: widget.accessToken,
                                  ),
                                );

                                if (orderSent == true) {
                                  clearOrders();
                                }
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
                        onPressed: () async {
                          final scannedArticle = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScanView(accessToken: widget.accessToken),
                            ),
                          );

                          if (scannedArticle != null) {
                            addArticle(scannedArticle);
                          }
                        },
                        child: const ListTile(
                          contentPadding: EdgeInsets.only(left: 18),
                          title: Text(
                            softWrap: false,
                            'Skanna',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 216, 212, 212),
                            ),
                          ),
                          leading: Icon(
                            Icons.qr_code_scanner,
                            color: Color.fromARGB(255, 216, 212, 212),
                          ),
                          trailing: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
