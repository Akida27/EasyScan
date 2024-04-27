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
  late List<bool>
      isCheckedList; // List to store checked-status for each item

  @override
  void initState() {
    super.initState();
// Initiate isCheckedList med true for each order
    isCheckedList = List<bool>.filled(widget.c.orders.length, true);
  }

  @override
  Widget build(BuildContext context) {
    final orders = widget.c.orders;
    return Column(
      children: [
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
                  value: isCheckedList[
                      index], // Använd isCheckedList för varje objekt
                  onChanged: (bool? newValue) {
                    setState(() {
                      isCheckedList[index] = newValue ?? false; // Uppdatera isCheckedList för aktuellt index
                    });
                  },
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(175, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: const Color(0xff39328F), // background
              foregroundColor: const Color(0xffCAC4D0), // foreground
            ),
            onPressed: () {
// Här kan du hantera bekräftelselogik baserat på isCheckedList
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
    );
  }
}
