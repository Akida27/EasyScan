import 'dart:convert';
import 'package:easyscan/src/views/order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'order_view.dart';
import '../settings/settings_view.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key, required this.accessToken});
  static const routeName = '/customers_view';
  final String accessToken;

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  List<dynamic> customers = [];
  final ScrollController scrollController = ScrollController();
  int currentOffset = 0;
  int limit = 50;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCustomers(widget.accessToken);

    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          fetchCustomers(widget.accessToken);
        }
      },
    );
  }

  Future<void> fetchCustomers(String accessToken) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (kDebugMode) {
      print('CustomersView accessToken: $accessToken');
    }
    String apiUrl =
        'https://api.fortnox.se/3/customers/?offset=$currentOffset&limit=$limit';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final newCustomers = json.decode(response.body)['Customers'];
        setState(() {
          customers.addAll(newCustomers);
          currentOffset += limit;
          isLoading = false;

          if (kDebugMode) {
            print("customers: ${customers.length}");
          }
        });
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                delegate: SearchBarDelegate(
                    customers, widget.accessToken, scrollController),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: customers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == customers.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final customer = customers[index];

          return ListTile(
            title: Text(customer['Name']),
            subtitle: Text(customer['Phone']),
            leading: CircleAvatar(
              child: Text(
                customer['Name'].toString().substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderView(
                    accessToken: widget.accessToken,
                    customer: customer,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  final List<dynamic> customers;
  final String accessToken;

  final scrollController;

  SearchBarDelegate(this.customers, this.accessToken, this.scrollController);

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
    List<dynamic> matchesQuery = [];
    for (var customer in customers) {
      if (customer['Name'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(customer);
      }
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: customers.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == customers.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final customer = matchesQuery[index];

        return ListTile(
          title: Text(customer['Name']),
          subtitle: Text(customer['Phone']),
          leading: CircleAvatar(
            child: Text(
              customer['Name'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderView(
                  accessToken: accessToken,
                  customer: customer,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> matchesQuery = [];
    for (var customer in customers) {
      if (customer['Name'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(customer);
      }
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: customers.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == customers.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final customer = matchesQuery[index];

        return ListTile(
          title: Text(customer['Name']),
          subtitle: Text(customer['Phone']),
          leading: CircleAvatar(
            child: Text(
              customer['Name'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderView(
                  accessToken: accessToken,
                  customer: customer,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
