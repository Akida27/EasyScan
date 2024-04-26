import 'dart:math';

import 'package:easyscan/src/views/sample_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key});

  static const routeName = '/add_product_screen';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Customer customer =
        ModalRoute.of(context)!.settings.arguments as Customer;

    final formKey = GlobalKey<FormState>();
    String? productName;
    int? productNumber;
    int? quantity;
    String? weight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lägg till artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Produkt Namn',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Produktnamn är obligatoriskt';
                  } else if (value.length > 23) {
                    return 'Produktnamn får inte vara längre än 23 tecken';
                  }
                  return null;
                },
                onSaved: (value) => productName = value,
                maxLength: 23,
              ),
              SizedBox(height: height * 0.01),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Artikelnummer',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Artikelnummer är obligatoriskt';
                  } else if (value.length > 6) {
                    return 'Artikelnummer får inte vara längre än 6 tecken';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value != "") {
                    productNumber = int.parse(value);
                  }
                },
                maxLength: 6,
              ),
              SizedBox(height: height * 0.01),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Antal',
                  hintText: 'Ex 10',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Antal är obligatoriskt';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value != "") {
                    quantity = int.parse(value);
                  }
                },
                maxLength: 5,
              ),
              SizedBox(height: height * 0.01),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Vikt',
                  hintText: 'Ex 20 kg',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vikt är obligatoriskt';
                  }
                  return null;
                },
                onSaved: (value) => weight = 'x$value kg',
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color(0xff39328F), // background
                  foregroundColor: const Color(0xffCAC4D0), // foreground
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    customer.addOrder(Product(
                      Random().nextInt(1000000),
                      productName!,
                      productNumber!,
                      (quantity!.toString() + weight!.toString()),
                    ));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Lägg till',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
