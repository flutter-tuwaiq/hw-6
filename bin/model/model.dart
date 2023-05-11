class Prodict {
  var id;
  var title;
  var body;
  var userId;
  var tags;
  var reactions;

  Prodict({
    this.id,
    this.title,
    this.body,
    this.userId,
    this.tags,
    this.reactions,
  });

  factory Prodict.fromJson({required Map json}) {
    return Prodict(
      id: json["id"],
      title: json["titel"],
      body: json["body"],
      userId: json["broms"],
      tags: json["tags"],
      reactions: json["reactions"],
    );
  }
  toMap() {
    return {
      "id": id,
      "titel": title,
      "body": body,
      "userId": userId,
      "tags": tags,
      "reactions": reactions,
    };
  }
}
