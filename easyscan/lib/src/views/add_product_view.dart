import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.article});

  static const routeName = '/add_product_screen';
  final dynamic article;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();

  String? productName;
  String? productNumber;
  String? orderedQuantity;
  String? deliveredQuantity;
  String? price;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      productName = widget.article['Description'];
      productNumber = widget.article['ArticleNumber'];
      orderedQuantity = widget.article['OrderedQuantity'];
      deliveredQuantity = widget.article['DeliveredQuantity'];
      price = widget.article['SalesPrice'];
    }
  }

  void _saveForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final newArticle = {
        'Description': productName,
        'ArticleNumber': productNumber,
        'OrderedQuantity': orderedQuantity,
        'DeliveredQuantity': deliveredQuantity,
        'SalesPrice': price,
      };
      if (kDebugMode) {
        print('AddProductScreen: $newArticle');
      }
      Navigator.pop(context, newArticle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:
            widget.article != null ? const Text('Ändra artikel') : const Text('Lägg till artikel'),
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
                  maxLines: 1,
                  initialValue: productName,
                  decoration: const InputDecoration(
                    labelText: 'Produkt Namn',
                    hintText: 'Rostade Melonfrön(Masri) 20x200(g)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Produktnamn är obligatoriskt';
                    } else if (value.length > 67) {
                      return 'Produktnamn får inte vara längre än 67 tecken';
                    }
                    return null;
                  },
                  onSaved: (value) => productName = value,
                  maxLength: 67,
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  initialValue: productNumber?.toString(),
                  readOnly: true,
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  maxLines: 1,
                  initialValue: orderedQuantity,
                  decoration: const InputDecoration(
                    labelText: 'BEST. ANTAL	',
                    hintText: '10',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Antal är obligatoriskt';
                    } else if (int.tryParse(value) == null) {
                      return 'Antal måste vara ett heltal';
                    }
                    return null;
                  },
                  onSaved: (value) => orderedQuantity = value,
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  maxLines: 1,
                  initialValue: deliveredQuantity,
                  decoration: const InputDecoration(
                    labelText: 'LEV. ANTAL',
                    hintText: '10',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Antal är obligatoriskt';
                    } else if (int.tryParse(value) == null) {
                      return 'Antal måste vara ett heltal';
                    }
                    return null;
                  },
                  onSaved: (value) => deliveredQuantity = value,
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
                  onPressed: _saveForm,
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
      ),
    );
  }
}
