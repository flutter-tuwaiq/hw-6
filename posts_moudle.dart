class post{
  int? id;
  String? title;
  String? body;
  int? userId;
  List? tags;
  int? reactions;

  post({
   this.id,
    this.title,
    this.body,
    this.reactions,
    this.tags,
    this.userId
    });
    factory post.formJson({required Map json}){
      return post(
        id: json['id'] ,
        title: json['title'],
        body: json['body'],
        userId: json['userId'],
        tags: json['tags'],
        reactions: json['reactions']
      );
    }//fun for map 
      toMap(){
        return{
          "id": id,
          "title": title,
          "body": body,
          "userId": userId,
          "tags": tags,
          "reactions": reactions};

      }
        }
      
    
      
    
  
