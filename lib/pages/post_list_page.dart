import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_api_call_test/models/postModel.dart';
import 'package:my_api_call_test/post_bloc.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  // final String apiEndPoint = "https://jsonplaceholder.typicode.com/posts";
  // List<Post> posts = [];
  final PostBloc postBloc = PostBloc();
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    // getPosts();
    postBloc.eventSink.add(PostAction.Get);
  }

  @override
  void dispose() {
    postBloc.dispose();
    super.dispose();
  }

  // void getPosts() async {
  //   List<Post> postObjs = [];
  //   http.get(Uri.parse(apiEndPoint)).then((res) {
  //     var responseBody = utf8.decode(res.bodyBytes);
  //     var jsonResponse = json.decode(responseBody).toList();
  //     for (var i = 0; i < jsonResponse.length; i++) {
  //       postObjs.add(Post.fromJson(
  //           userId: jsonResponse[i]["userId"],
  //           id: jsonResponse[i]["id"],
  //           title: jsonResponse[i]["title"],
  //           body: jsonResponse[i]["body"]));
  //     }
  //     setState(() {
  //       posts = postObjs;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post list"),
      ),
      body: StreamBuilder<List<Post>>(
        stream: postBloc.postStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].body),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // postBloc.eventSink.add(PostAction.Get);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
