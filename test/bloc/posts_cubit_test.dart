import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:unit_testing_example/bloc/cubit/posts_cubit.dart';
import 'package:unit_testing_example/bloc/cubit/posts_states.dart';
import 'package:unit_testing_example/models/posts_model.dart';
import 'package:unit_testing_example/repository/posts_repository.dart';

import 'posts_cubit_test.mocks.dart';

@GenerateMocks([PostsRepository])
void main(){
  late PostsCubit postsCubit;
  late PostsRepository mockPostsRepository;

  setUp((){
      mockPostsRepository=MockPostsRepository();
      postsCubit=PostsCubit(mockPostsRepository);
  });

  test('PostsCubit should emit PostsLoading then PostsLoaded State with a list of posts when calling loadPosts method',()async{
    final posts=List.generate(5, (index) => PostModel(
        id: index,
        userId: index,
        title: 'title $index',
        body: 'body $index'));

    when(mockPostsRepository.getPosts()).thenAnswer((realInvocation) =>Future.value(posts) );
    
    //assert
    final expectedStatus=[
      const PostsLoading(),
      PostsLoaded(posts),
    ];

    expectLater(postsCubit.stream,emitsInAnyOrder(expectedStatus) );

    //act 
     postsCubit.loadPosts();
  });

  test('''PostsCubit should emit PostsLoading then PostsError State
   when calling loadPosts method if repository throw an Exception''',()async{

   when(mockPostsRepository.getPosts())
          .thenAnswer((_) async =>throw Exception());

          //assert
      final expectedStates = [
        const PostsLoading(),
        const PostsError(),
      ];

      expectLater(postsCubit.stream, emitsInAnyOrder(expectedStates));

      //act
      postsCubit.loadPosts();

  });

}