

import 'package:unit_testing_example/core/services/network_services.dart';
import 'package:unit_testing_example/models/posts_model.dart';

abstract class RemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final NetworkService networkService;

  RemoteDataSourceImpl(this.networkService);

  @override
  Future<List<PostModel>> getPosts() async {
    const url = 'https://jsonplaceholder.typicode.com/posts';
    final response = await networkService.get(url);

    if (response.statusCode != 200) throw Exception();

    final result = response.data as List;
    final posts = result.map((postMap) => PostModel.fromMap(postMap)).toList();
    return posts;
  }
}