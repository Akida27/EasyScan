import 'package:flutter/material.dart';
//import 'package:easy_search_bar/easy_search_bar.dart';

import '../settings/settings_view.dart';
import 'Login_view.dart';
import 'sample_item.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});
  static const routeName = '/customers_view';

  @override
  State<CustomersView> createState() => _CustomersViewwState();
}

class _CustomersViewwState extends State<CustomersView> {
  // String searchValue = '';
  final List<Customer> customers = [
    const Customer(1, "Jossef", "+46923213213"),
    const Customer(2, "Adam", "+46923413213"),
    const Customer(3, "Yones", "+46923213213"),
    const Customer(4, "Sandra", "+46923213213"),
    const Customer(5, "Aron", "+46923213213"),
    const Customer(6, "Anton", "+46923213213"),
    const Customer(7, "Amina", "+46923213213"),
    const Customer(8, "Ahmed", "+46923213213"),
    const Customer(9, "Fatima", "+46923213213"),
  ];

  // List<Customer> filteredCustomers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Kunder'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBarDelegate(customers),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (BuildContext context, int index) {
          final customer = customers[index];

          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.phone),
            leading: CircleAvatar(
              child: Text(
                customer.name[0],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                LoginView.routeName,
              );
            },
          );
        },
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  final List<Customer> customers;
  SearchBarDelegate(this.customers);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Customer> matchesQuery = [];
    for (var customer in customers) {
      if (customer.name.toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(customer);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final customer = matchesQuery[index];

        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.phone),
          leading: CircleAvatar(
            child: Text(
              customer.name[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.restorablePushNamed(
              context,
              LoginView
                  .routeName, // change to order screen ********************************
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Customer> matchesQuery = [];
    for (var customer in customers) {
      if (customer.name.toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(customer);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final customer = matchesQuery[index];

        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.phone),
          leading: CircleAvatar(
            child: Text(
              customer.name[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.restorablePushNamed(
              context,
              LoginView
                  .routeName, // change to order screen ********************************
            );
          },
        );
      },
    );
  }
}
