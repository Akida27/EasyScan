import 'package:flutter/material.dart';
import 'addProduct.dart';
import 'sample_item.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({
    Key? key,
    this.items = const [
      Product(1, "Name1", 14323, "10x5kg"),
      Product(2, "Name2", 14323, "10x20kg"),
      Product(3, "Name3", 14323, "15x5kg"),
      Product(4, "Name4", 14323, "10x5kg"),
      Product(5, "Name5", 14323, "10x5kg"),
      Product(6, "Name6", 14323, "10x5kg"),
      Product(7, "Name7", 14323, "10x5kg"),
      Product(8, "Name8", 14323, "10x5kg"),
      Product(9, "Name9", 14323, "10x5kg"),
      Product(10, "Name10", 14323, "10x5kg"),
      Product(11, "Name11", 14323, "10x5kg"),
      Product(12, "Name12", 14323, "10x5kg"),
    ],
  });

  static const routeName = '/orders_view';

  final List<Product> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders for Fatima"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle onPressed to navigate to the add product screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return ListTile(
                    title: Text("${item.name} - ${item.quantity}"),
                    subtitle: Text(
                      "Artikelnummer: ${item.productNumber}",
                      style: TextStyle(color: Color(0xff8E8A91)),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
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
                        color: Color(0xff8E8A91),
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
