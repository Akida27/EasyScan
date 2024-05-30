import 'package:easyscan/src/data/product_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.customer, this.article});

  static const routeName = '/add_product_screen';
  final dynamic article;
  final dynamic customer;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  String? productName;
  String? productNumber;
  String? quantity;
  String? weight;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      productName = widget.article['Description'];
      productNumber = widget.article['ArticleNumber'];
      quantity = widget.article['Quantity'];
      weight = widget.article['Weight'];
    }
  }

  void _saveForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final newArticle = {
        'Description': productName,
        'ArticleNumber': productNumber,
        'Quantity': quantity,
        'Weight': weight,
      };
      Navigator.pop(context, newArticle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: widget.article != null
            ? const Text('Ändra artikel')
            : const Text('Lägg till artikel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: productName,
                  decoration: const InputDecoration(
                    labelText: 'Produkt Namn',
                    hintText: 'Rostade Melonfrön(Masri) 20x200(g)',
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
                  initialValue: productNumber?.toString(),
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
                  onSaved: (value) =>
                      productNumber = int.tryParse(value!).toString(),
                  maxLength: 6,
                ),
                //SizedBox(height: height * 0.01),
                // TextFormField(
                //   initialValue: quantity?.toString(),
                //   decoration: const InputDecoration(
                //     labelText: 'Antal',
                //     hintText: 'Ex 10',
                //   ),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Antal är obligatoriskt';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) =>
                //       quantity = int.tryParse(value!).toString(),
                //   maxLength: 5,
                // ),
                // SizedBox(height: height * 0.01),
                // TextFormField(
                //   initialValue: weight?.toString(),
                //   decoration: const InputDecoration(
                //     labelText: 'Vikt (kg)',
                //     hintText: 'Ex 20',
                //   ),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Vikt är obligatoriskt';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) => weight = int.tryParse(value!).toString(),
                //   maxLength: 3,
                // ),
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
                  onPressed: _saveForm,
                  child: widget.article != null
                      ? const Text(
                          'Ändra',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      : const Text(
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
      ),
    );
  }
}
