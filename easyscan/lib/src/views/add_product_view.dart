import 'package:easyscan/src/data/product_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class AddProductScreen extends StatelessWidget {
//   const AddProductScreen(
//       {super.key, this.product, this.customer, this.article});

//   static const routeName = '/add_product_screen';
//   final Product? product;
//   final dynamic article;
//   final dynamic customer;
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     final formKey = GlobalKey<FormState>();
//     // String? productName;
//     // int? productNumber;
//     // int? quantity;
//     // String? weight;

//     // final pro = product?.quantity.split('x');

//     return Scaffold(
//       appBar: AppBar(
//         title: article != null
//             ? const Text('Ändra artikel')
//             : const Text('Lägg till artikel'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(22.0),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   initialValue: article?['Description'],
//                   decoration: const InputDecoration(
//                     labelText: 'Produkt Namn',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Produktnamn är obligatoriskt';
//                     } else if (value.length > 23) {
//                       return 'Produktnamn får inte vara längre än 23 tecken';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => article?['Description'] = value,
//                   maxLength: 23,
//                 ),
//                 SizedBox(height: height * 0.01),
//                 article == null
//                     ? TextFormField(
//                         initialValue: article?['ArticleNumber'],
//                         decoration: const InputDecoration(
//                           labelText: 'Artikelnummer',
//                         ),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Artikelnummer är obligatoriskt';
//                           } else if (value.length > 6) {
//                             return 'Artikelnummer får inte vara längre än 6 tecken';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           if (kDebugMode) {
//                             print(
//                                 "valueeeeeeee**************************: $value");
//                           }
//                           if (value != null && value != "") {
//                             article?['Description'] = value;
//                           }
//                         },
//                         maxLength: 6,
//                       )
//                     : const SizedBox(),

//                 // SizedBox(height: height * 0.01),
//                 // TextFormField(
//                 //   initialValue: article['Unit'],
//                 //   decoration: const InputDecoration(
//                 //     labelText: 'Antal',
//                 //     hintText: 'Ex 10',
//                 //   ),
//                 //   keyboardType: TextInputType.number,
//                 //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Antal är obligatoriskt';
//                 //     }
//                 //     return null;
//                 //   },
//                 //   onSaved: (value) {
//                 //     if (value != null && value != "") {
//                 //       quantity = int.parse(value);
//                 //     }
//                 //   },
//                 //   maxLength: 5,
//                 // ),
//                 // SizedBox(height: height * 0.01),
//                 // TextFormField(
//                 //   initialValue: article['Price'].toString(),
//                 //   decoration: const InputDecoration(
//                 //     labelText: 'Vikt (kg)',
//                 //     hintText: 'Ex 20',
//                 //   ),
//                 //   keyboardType: TextInputType.number,
//                 //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 //   maxLength: 3,
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Vikt är obligatoriskt';
//                 //     }
//                 //     return null;
//                 //   },
//                 //   onSaved: (value) => weight = 'x',
//                 // ),
//                 SizedBox(height: height * 0.03),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: const Size(180, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     backgroundColor: const Color(0xff39328F), // background
//                     foregroundColor: const Color(0xffCAC4D0), // foreground
//                   ),
//                   onPressed: () {
//                     // if (formKey.currentState!.validate()) {
//                     //   formKey.currentState!.save();
//                     //   Navigator.of(context).pop();
//                     // }
//                     Navigator.of(context).pop();
//                   },
//                   child: article != null
//                       ? const Text(
//                           'Ändra',
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         )
//                       : const Text(
//                           'Lägg till',
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class AddProductScreen extends StatefulWidget {
  const AddProductScreen(
      {super.key, this.product, this.customer, this.article});

  static const routeName = '/add_product_screen';
  final dynamic product;
  final dynamic article;
  final dynamic customer;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  String? productName;
  int? productNumber;
  int? quantity;
  int? weight;

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
        'Price': quantity != null && weight != null ? quantity! * weight! : 0,
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
                  onSaved: (value) => productNumber = int.tryParse(value!),
                  maxLength: 6,
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  initialValue: quantity?.toString(),
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
                  onSaved: (value) => quantity = int.tryParse(value!),
                  maxLength: 5,
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  initialValue: weight?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Vikt (kg)',
                    hintText: 'Ex 20',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vikt är obligatoriskt';
                    }
                    return null;
                  },
                  onSaved: (value) => weight = int.tryParse(value!),
                  maxLength: 3,
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
