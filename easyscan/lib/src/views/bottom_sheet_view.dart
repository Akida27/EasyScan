import 'package:easyscan/src/data/customer_data.dart';
import 'package:flutter/material.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({super.key, required this.c});
  static const routeName = '/bottomSheet_view';
  final dynamic c;

  @override
  Widget build(BuildContext context) {
    final orders = c.orders;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Bekräfta varor',
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
            padding: const EdgeInsets.only(bottom: 30, top: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(175, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: const Color(0xff39328F), // background
                foregroundColor: const Color(0xffCAC4D0), // foreground
              ),
              // Här kan du hantera bekräftelselogik baserat på isCheckedList
              onPressed: () {},
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
