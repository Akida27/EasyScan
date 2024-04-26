import 'package:flutter/material.dart';
import 'add_product_view.dart';
import 'sample_item.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({
    super.key,
  });

  static const routeName = '/orders_view';

  @override
  Widget build(BuildContext context) {
    final Customer customer =
        ModalRoute.of(context)?.settings.arguments as Customer;
    final orders = customer.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders för ${customer.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Handle onPressed to navigate to the add product screen
              Navigator.pushNamed(context, AddProductScreen.routeName,
                  arguments: customer);
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
                    title: Text("${order.name} - ${order.quantity}"),
                    subtitle: Text(
                      "Artikelnummer: ${order.productNumber}",
                      style: const TextStyle(color: Color(0xff8E8A91)),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: const Color(0xffEEB53A), // background
                    foregroundColor: const Color(0xff39328F), // foreground
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Bekräfta',
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
                    backgroundColor: const Color(0xff39328F), // background
                    foregroundColor: const Color(0xffCAC4D0), // foreground
                  ),
                  onPressed: () {},
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
