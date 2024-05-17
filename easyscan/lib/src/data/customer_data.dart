import 'package:easyscan/src/data/product_data.dart';
import 'package:uuid/uuid.dart';

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
