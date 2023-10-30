

import 'package:unit_testing_example/dataSources/remote_data_sources.dart';
import 'package:unit_testing_example/models/posts_model.dart';

abstract class PostsRepository {
  Future<List<PostModel>> getPosts();
}

class PostsRepositoryImpl implements PostsRepository {
  final RemoteDataSource _remoteDataSource;

  PostsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PostModel>> getPosts() {
    return _remoteDataSource.getPosts();
  }
}
