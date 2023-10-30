

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_testing_example/bloc/cubit/posts_states.dart';
import 'package:unit_testing_example/repository/posts_repository.dart';


class PostsCubit extends Cubit<PostsState> {
  final PostsRepository _postsRepository;
  PostsCubit(this._postsRepository) : super(PostsInitial());

  Future<void> loadPosts() async {
    emit(const PostsLoading());
    try {
      final posts = await _postsRepository.getPosts();
      emit(PostsLoaded(posts));
    } on Exception catch (e) {
        if (kDebugMode) {
          print( e.toString());
        }
      emit(const PostsError());
    }
  }
}