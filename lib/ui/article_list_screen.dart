


import 'package:article_finder/bloc/article_list_bloc.dart';
import 'package:article_finder/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

import '../bloc/article_detail_bloc.dart';
import '../data/article.dart';
import 'article_detail_screen.dart';
import 'article_list_item.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ArticleListBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body:
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search...'
                ),
                onChanged: bloc.searchQuery.add,
              ),
            ),
            Expanded(child: _buildResults(bloc)),
          ],
        ),
    );
  }
}

Widget _buildResults (ArticleListBloc bloc){
  return StreamBuilder<List<Article>?>(
    stream: bloc.articlesStream,
    builder: (context, snapshot){
      final results = snapshot.data;
      if (results == null){
        return const Center(child: Text('Loading...'));
      } else if (results.isEmpty){
        return const Center(child: Text('No results'));
      } return _buildSearchResults(results);
    },
  );
}

Widget _buildSearchResults (List<Article> results){
  return ListView.builder(
    itemCount: results.length,
    itemBuilder: (context, index) {
      final article = results[index];
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ArticleListItem(article: article),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                bloc: ArticleDetailBloc(id: article.id),
                child: const ArticleDetailScreen(),
              ),
            ),
          );
        },
      );
    },
  );
}