class Post {
  int userId;
  int id;
  String title;
  String body;
  Post.fromJson(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});
}
