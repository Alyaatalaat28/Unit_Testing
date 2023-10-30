import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:unit_testing_example/core/services/network_services.dart';
import 'package:unit_testing_example/dataSources/remote_data_sources.dart';
import 'package:unit_testing_example/models/posts_model.dart';

import 'remote_data_sources_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late RemoteDataSourceImpl remoteDataSource;
  late NetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    remoteDataSource = RemoteDataSourceImpl(mockNetworkService);
  });

  test('GetPosts should return posts without any exception', () async {
    // arrange
    final posts = List.generate(5, (index) => PostModel(
      id: index,
      userId: index,
      body: 'body $index',
      title: 'title $index',
    ));

    final postMap = posts.map((post) => post.toMap()).toList();

    when(mockNetworkService.get('https://jsonplaceholder.typicode.com/posts')).thenAnswer((realInvocation) => Future.value(
      Response(
        requestOptions: RequestOptions(
          path: 'https://jsonplaceholder.typicode.com/posts',
        ),
        data: postMap,
        statusCode: 200,
      ),
    ));

    // act
    final result = await remoteDataSource.getPosts();

    // assert
    expect(result, posts);
  });

   test('GetPosts should throw an Exception if the status code is not 200',()async{
    //arrange
    final expectedResult=throwsA(isA<Exception>());

    when(mockNetworkService.get('https://jsonplaceholder.typicode.com/posts')).thenAnswer((realInvocation) => Future.value(
      Response(
        requestOptions: RequestOptions(
          path: 'https://jsonplaceholder.typicode.com/posts',
        ),
        statusCode: 404,
      ),
    ));

    //act 
    result() async =>await remoteDataSource.getPosts();

    //assert
    expect(result, expectedResult);

   });
}