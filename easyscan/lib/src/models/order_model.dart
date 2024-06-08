import '../services/order_storage.dart';

class OrderModel {
  List<Map<String, dynamic>> orders = [];

  List<Map<String, dynamic>> getOrders() {
    return orders;
  }

  Future<void> loadOrders(Map<dynamic, dynamic> customer) async {
    orders = await loadOrdersFromPreferences(customer['CustomerNumber']);
  }

  void addArticle(Map<String, dynamic> order, Map<dynamic, dynamic> customer) {
    orders.add(order);
    saveOrdersToPreferences(customer['CustomerNumber'], orders);
  }

  void removeArticle(
      Map<String, dynamic> order, Map<dynamic, dynamic> customer) {
    orders.remove(order);
    saveOrdersToPreferences(customer['CustomerNumber'], orders);
  }

  void clearOrders(Map<dynamic, dynamic> customer) {
    orders.clear();
    clearOrdersFromPreferences(customer['CustomerNumber']);
  }
}
