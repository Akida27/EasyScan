/// A placeholder class that represents an entity or model.
class SampleItem {
  const SampleItem(this.id);

  final int id;
}

class Customer {
  const Customer(this.id, this.name, this.phone);
  final int id;
  final String name;
  final String phone;
  
}

class Product {
  const Product(this.id, this.name, this.productNumber, this.quantity);
  final int id;
  final String name;
  final int productNumber;
  final String quantity;

}