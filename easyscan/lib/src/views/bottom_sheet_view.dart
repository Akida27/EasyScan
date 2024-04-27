import 'package:flutter/material.dart';
import 'sample_item.dart';

class BottomSheetView extends StatefulWidget {
  const BottomSheetView({super.key, required this.c});
  static const routeName = '/bottomSheet_view';
  final Customer c;

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  late List<bool> isCheckedList; // List to store checked-status for each item

  @override
  void initState() {
    super.initState();
    // Initiate isCheckedList med true for each order
    isCheckedList = List<bool>.filled(widget.c.orders.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final orders = widget.c.orders;
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
                  return CheckboxListTile(
                    title: Text("${order.name} - ${order.quantity}"),
                    subtitle: Text(
                      "Artikelnummer: ${order.productNumber}",
                      style: const TextStyle(color: Color(0xff8E8A91)),
                    ),
                    // Använd isCheckedList för varje objekt
                    value: isCheckedList[index],
                    onChanged: (bool? newValue) {
                      setState(() {
                        // Uppdatera isCheckedList för aktuellt index
                        isCheckedList[index] = newValue ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 15),
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
