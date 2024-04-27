/// A placeholder class that represents an entity or model.
class SampleItem {
  const SampleItem(this.id);

  final int id;
}

class Customer {
  Customer(this.id, this.name, this.phoneNumber, this.orders);

  final int id;
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
  const Product(this.id, this.name, this.productNumber, this.quantity);
  final int id;
  final String name;
  final int productNumber;
  final String quantity;
}
