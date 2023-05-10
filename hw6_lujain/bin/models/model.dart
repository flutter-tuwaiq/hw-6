class Posts {
  int? id;
  String? title;
  String? body;
  int? userId;
  List? tags;
  int? reactions;

  Posts(
      {this.id, this.title, this.body, this.userId, this.tags, this.reactions});

  factory Posts.fromJson({required Map json}) {
    return Posts(
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
      "reactions": reactions,
    };
  }
}
