import 'package:uuid/uuid.dart';

class SampleItem {
  const SampleItem(this.id);

  final int id;
}

class Customer {
  Customer(this.name, this.phoneNumber, this.orders) : id = const Uuid().v4();

  final String id;
  final String name;
  final String phoneNumber;
  List<Product> orders = [];

  void addOrder(Product product) {
    orders.add(product);
  }

  void removeOrder(Product product) {
    orders.remove(product);
  }
}

class Product {
  Product(this.name, this.productNumber, this.quantity)
      : id = const Uuid().v4(); // Generate a unique ID using uuid package

  final String id;
  final String name;
  final int productNumber;
  final String quantity;
}
