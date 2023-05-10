// 4- The server should contain at least one model that represents the data being queried.
// 5- The model should include all the necessary properties and methods to accurately represent the data being queried.
class Post {
  int? id;
  String? title;
  String? body;
  int? userId;
  List? tags;
  int? reactions;

  Post(
      {this.id,
      this.title,
      this.body,
      this.userId,
      this.tags,
      this.reactions});

  factory Post.fromJson({required Map json}) {
    return Post(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      userId: json["userId"],
      tags: json["tags"],
      reactions: json["reactions"],
    );
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
