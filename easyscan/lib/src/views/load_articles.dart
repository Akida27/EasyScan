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
  final ScrollController scrollController = ScrollController();
  int currentOffset = 0;
  int limit = 50;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetcharticles(widget.accessToken);

    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (hasMoreData) {
            fetcharticles(widget.accessToken);
          }
        }
      },
    );
  }

  void _handleArticleSelection(Map<String, String?> selectedArticle) {
    Navigator.pop(context, selectedArticle);
  }

  Future<void> fetcharticles(String accessToken) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (kDebugMode) {
      print('ArticlesView accessToken: $accessToken');
    }
    String apiUrl = 'https://api.fortnox.se/3/articles/?offset=$currentOffset&limit=$limit';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final newArticles = json.decode(response.body)['Articles'];

        if (kDebugMode) {
          print(newArticles);
        }

        setState(() {
          articles.addAll(newArticles);
          currentOffset += limit;
          isLoading = false;
          if (newArticles.length < limit) {
            // If fewer articles are fetched than the limit, no more data
            hasMoreData = false;
          }
        });
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
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
                    articles, widget.accessToken, _handleArticleSelection, scrollController),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: articles.length + (hasMoreData ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == articles.length) {
            return const Center(
              heightFactor: 15,
              child: CircularProgressIndicator(),
            );
          }
          final article = articles[index];

          if (kDebugMode) {
            print(article);
          }

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

  final ScrollController scrollController;

  SearchBarDelegate(
      this.articles, this.accessToken, this._handleArticleSelection, this.scrollController);

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
      if (article['Description'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == articles.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final article = matchesQuery[index];

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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> matchesQuery = [];
    for (var article in articles) {
      if (article['Description'].toLowerCase().startsWith(query.toLowerCase())) {
        matchesQuery.add(article);
      }
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: matchesQuery.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == articles.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final article = matchesQuery[index];

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
    );
  }
}
