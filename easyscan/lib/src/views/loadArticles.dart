import 'dart:convert';
import 'package:easyscan/src/views/order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'order_view.dart';
import '../settings/settings_view.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key, required this.accessToken});
  static const routeName = '/articles_view';
  final String accessToken;

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  List<dynamic> articles = [];
  final formKey = GlobalKey<FormState>();
  String? productName;
  String? productNumber;
  String? quantity;
  String? weight;

  @override
  void initState() {
    super.initState();
    fetcharticles(widget.accessToken);
  }

  void _handleArticleSelection() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final newArticle = {
        'Description': productName,
        'ArticleNumber': productNumber,
        'Quantity': quantity,
        'Weight': weight,
      };
      Navigator.pop(context, newArticle);
    }
  }

  Future<void> fetcharticles(String accessToken) async {
    if (kDebugMode) {
      print('ArticlesView accessToken: $accessToken');
    }
    const String apiUrl = 'https://api.fortnox.se/3/articles';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          articles = json.decode(response.body)['Articles'];
        });
      } else {
        throw Exception('Failed to load articles');
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
        title: const Text('Välj artikel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBarDelegate(
                    articles, widget.accessToken, _handleArticleSelection),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          final article = articles[index];

          return ListTile(
              title: Text(article['Description']),
              subtitle: Text(article['ArticleNumber']),
              onTap: _handleArticleSelection);
        },
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  final List<dynamic> articles;
  final String accessToken;
  final VoidCallback _handleArticleSelection;

  SearchBarDelegate(
      this.articles, this.accessToken, this._handleArticleSelection);

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
    for (var article in articles) {
      if (article['Name'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final article = matchesQuery[index];

        return ListTile(
          title: Text(article['Name']),
          subtitle: Text(article['Phone']),
          leading: CircleAvatar(
            child: Text(
              article['Name'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: _handleArticleSelection,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> matchesQuery = [];
    for (var article in articles) {
      if (article['Name'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final article = matchesQuery[index];

        return ListTile(
            title: Text(article['Name']),
            subtitle: Text(article['Phone']),
            leading: CircleAvatar(
              child: Text(
                article['Name'].toString().substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: _handleArticleSelection);
      },
    );
  }
}
