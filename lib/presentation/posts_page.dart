import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_testing_example/bloc/cubit/posts_cubit.dart';
import 'package:unit_testing_example/bloc/cubit/posts_states.dart';
import 'package:unit_testing_example/core/services/network_services.dart';
import 'package:unit_testing_example/dataSources/remote_data_sources.dart';
import 'package:unit_testing_example/models/posts_model.dart';
import 'package:unit_testing_example/repository/posts_repository.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(
        PostsRepositoryImpl(
          RemoteDataSourceImpl(NetworkServiceImpl()),
        ),
      )..loadPosts(),
      child: Scaffold(body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      listener: (context, state) {
        if (state is PostsError) _showErrorDialog(context);
      },
      builder: (context, state) {
        if (state is PostsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostsLoaded) {
          return _buildPostsList(state);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPostsList(PostsLoaded state) {
    return ListView.builder(
      itemCount: state.posts.length,
      itemBuilder: (_, index) {
        final post = state.posts[index];
        return _PostItem(post);
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('An error occurred!'),
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  final PostModel _post;
  const _PostItem(this._post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(_post.id.toString()),
      title: Text(_post.title),
      subtitle: Text(_post.body),
    );
  }
}