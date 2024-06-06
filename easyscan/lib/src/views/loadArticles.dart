import 'dart:convert';
import 'package:easyscan/src/views/add_product_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key, required this.accessToken});
  static const routeName = '/articles_view';
  final String accessToken;

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetcharticles(widget.accessToken);
  }

  void _handleArticleSelection(Map<String, String?> selectedArticle) {
    Navigator.pop(context, selectedArticle);
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
            onTap: () async {
              final updatedArticle = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(article: article),
                ),
              );
              if (kDebugMode) {
                print('ArticlesView: $updatedArticle');
              }
              if (updatedArticle != null) {
                _handleArticleSelection(updatedArticle);
              }
            },
          );
        },
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  final List<dynamic> articles;
  final String accessToken;
  final Function(Map<String, String?>) _handleArticleSelection;

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
      if (article['Description']
          .toLowerCase()
          .startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final article = matchesQuery[index];

        return ListTile(
          title: Text(article['Description']),
          subtitle: Text(article['ArticleNumber']),
          leading: CircleAvatar(
            child: Text(
              article['Description'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () async {
            final updatedArticle = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductScreen(article: article),
              ),
            );
            if (kDebugMode) {
              print('ArticlesView: $updatedArticle');
            }
            if (updatedArticle != null) {
              _handleArticleSelection(updatedArticle);
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> matchesQuery = [];
    for (var article in articles) {
      if (article['Description']
          .toLowerCase()
          .startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        final article = matchesQuery[index];

        return ListTile(
          title: Text(article['Description']),
          subtitle: Text(article['ArticleNumber']),
          leading: CircleAvatar(
            child: Text(
              article['Description'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () async {
            final updatedArticle = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductScreen(article: article),
              ),
            );
            if (kDebugMode) {
              print('ArticlesView: $updatedArticle');
            }
            if (updatedArticle != null) {
              _handleArticleSelection(updatedArticle);
            }
          },
        );
      },
    );
  }
}
