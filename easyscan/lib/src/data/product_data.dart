import 'package:uuid/uuid.dart';

class Product {
  Product(this.name, this.productNumber, this.quantity)
      : id = const Uuid().v4(); // Generate a unique ID using uuid package

  final String id;
  final String name;
  final int productNumber;
  final String quantity;
}
