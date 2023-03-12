import 'dart:async';

import 'package:article_finder/data/article.dart';
import 'package:article_finder/data/rw_client.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class ArticleDetailBloc implements Bloc {
  final String id;
  final _refreshController = StreamController<void>();
  final _client = RWClient();

  late Stream<Article?> articleStream;

  Future refresh() {
    final future = articleStream.first;
    _refreshController.sink.add({});
    return future;
  }

  ArticleDetailBloc({required this.id}){
    articleStream = _refreshController.stream
        .startWith({})
        .mapTo(id)
        .switchMap(
        (id) => _client.getDetailArticle(id).asStream(),
    ).asBroadcastStream();
  }

  @override
  void dispose(){
    _refreshController.close();
  }
}