import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:unit_testing_example/dataSources/remote_data_sources.dart';
import 'package:unit_testing_example/models/posts_model.dart';
import 'package:unit_testing_example/repository/posts_repository.dart';

import 'posts_repository_test.mocks.dart';


//flutter pub run  build_runner build --delete-conflicting-outputs

@GenerateMocks([RemoteDataSource])
void main(){
  late PostsRepository postsRepository;
  late RemoteDataSource mockRemoteDataSource;
  
  setUp((){
     mockRemoteDataSource = MockRemoteDataSource();
     postsRepository=PostsRepositoryImpl(mockRemoteDataSource);
    });

  test('GetPosts should return a list of posts without any exceptions',()async{
      //arrange
          final posts = List.generate(
        5,
        (index) => PostModel(
            id: index,
            userId: index,
            title: 'title $index',
            body: 'body $index'));

        when(mockRemoteDataSource.getPosts()).thenAnswer((realInvocation) => Future.value(posts));
        //act
        final result=await postsRepository.getPosts();

        //assert
        expect(result,posts);



  });


}