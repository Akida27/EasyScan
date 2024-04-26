import 'package:easyscan/src/views/sample_item.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  static const routeName = '/add_product_screen';

  @override
  Widget build(BuildContext context) {
    final Customer customer =
        ModalRoute.of(context)?.settings.arguments as Customer;

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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                onSaved: (value) => productName = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Artikelnummer',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => productNumber = int.parse(value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Ex 10',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => quantity = int.parse(value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Ex 20 kg',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => weight = 'x$value kg',
              ),
              const SizedBox(height: 30.0),
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
                  formKey.currentState?.save();
                  customer.addOrder(Product(
                    1,
                    productName!,
                    productNumber!,
                    (quantity!.toString() + weight!.toString()),
                  ));
                  Navigator.of(context).pop();
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
