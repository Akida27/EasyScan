import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}


// class OrdersView extends StatefulWidget {
//   final String accessToken;
//   final Map customer;

//   const OrdersView({super.key, required this.accessToken, required this.customer});
//   static const routeName = '/orders_view';


//   @override
//   State<OrdersView> createState() => _OrdersViewState();
// }

// class _OrdersViewState extends State<OrdersView> {
//   List<dynamic> orders = [];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     fetchOrders(widget.customer['CustomerNumber']);
//   }

//   Future<void> fetchOrders(String customerNumber) async {
//     const String apiUrl = 'https://api.fortnox.se/3/orders';
//     final String accessToken = widget.accessToken; // Retrieve from parent widget

//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           orders = json.decode(response.body)['Orders']
//               .where((order) => order['CustomerNumber'] == customerNumber && !order['Sent'])
//               .toList();
//         });
//       } else {
//         throw Exception('Failed to load orders');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders for ${widget.customer['Name']}'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => AddProductScreen(customer: widget.customer),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (BuildContext context, int index) {
//           final order = orders[index];
//           return ListTile(
//             title: Text(order['OrderNumber']),
//             subtitle: Text(order['OrderDate']),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => OrderDetailView(order: order),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderDetailView extends StatelessWidget {
//   final dynamic order;

//   const OrderDetailView({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order ${order['OrderNumber']} Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Order Number: ${order['OrderNumber']}'),
//             Text('Customer Number: ${order['CustomerNumber']}'),
//             Text('Order Date: ${order['OrderDate']}'),
//             // Display other order details as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddProductScreen extends StatelessWidget {
//   final dynamic customer;

//   const AddProductScreen({super.key, required this.customer});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product for ${customer['Name']}'),
//       ),
//       body: Center(
//         child: Text('Add product form goes here'),
//       ),
//     );
//   }
// }
