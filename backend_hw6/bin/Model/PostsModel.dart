class Post {
  int? id;
  String? title;
  String? body;
  int? userId;
  List? tags;
  int? reactions;

  Post(
      {this.id, this.title, this.body, this.userId, this.tags, this.reactions});

  factory Post.fromjson({required Map json}) {
    return Post(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        userId: json['userId'],
        tags: json['tags'],
        reactions: json['reactions']);
  }

  toMap() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "userId": userId,
      "tags": tags,
      "reactions": reactions
    };
  }
}
