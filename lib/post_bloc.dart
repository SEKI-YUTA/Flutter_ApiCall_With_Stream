import 'dart:async';
import 'dart:convert';

import 'package:my_api_call_test/models/postModel.dart';
import 'package:http/http.dart' as http;

enum PostAction { Get, Reset }

class PostBloc {
  final String apiEndPoint = "https://jsonplaceholder.typicode.com/posts";
  List<Post> posts = [];

  final _stateStreamController = StreamController<List<Post>>();
  StreamSink<List<Post>> get postSink => _stateStreamController.sink;
  Stream<List<Post>> get postStream => _stateStreamController.stream;

  final _eventStreamContoller = StreamController<PostAction>();
  StreamSink<PostAction> get eventSink => _eventStreamContoller.sink;
  Stream<PostAction> get eventStream => _eventStreamContoller.stream;

  PostBloc() {
    posts = [];
    List<Post> postObjs = [];
    eventStream.listen((event) async {
      print("some event");
      if (event == PostAction.Get) {
        // awaitを付けないとレスポンスが返ってくる前に次の処理にいってしまうので
        // 何も表示されない
        await http.get(Uri.parse(apiEndPoint)).then((res) {
          var responseBody = utf8.decode(res.bodyBytes);
          var jsonResponse = json.decode(responseBody).toList();
          for (var i = 0; i < jsonResponse.length; i++) {
            // print("loop no $i");
            postObjs.add(Post.fromJson(
                userId: jsonResponse[i]["userId"],
                id: jsonResponse[i]["id"],
                title: jsonResponse[i]["title"],
                body: jsonResponse[i]["body"]));
          }
        });

        // --------------------------------

        // var res = await http.get(Uri.parse(apiEndPoint));
        // var responseBody = utf8.decode(res.bodyBytes);
        // var jsonResponse = json.decode(responseBody).toList();
        // for (var i = 0; i < jsonResponse.length; i++) {
        //   // print("loop no $i");
        //   postObjs.add(Post.fromJson(
        //       userId: jsonResponse[i]["userId"],
        //       id: jsonResponse[i]["id"],
        //       title: jsonResponse[i]["title"],
        //       body: jsonResponse[i]["body"]));
        // }

        // ---------------------------------

        posts = postObjs;
      }
      if (event == PostAction.Reset) {
        posts = [];
      }

      postSink.add(posts);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamContoller.close();
  }
}
