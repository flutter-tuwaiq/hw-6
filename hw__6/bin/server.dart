import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

import 'Models/PostsModel.dart';

// Configure routes.


void main(List<String> args){
withHotreload(() => Creatserver());
}

Future<HttpServer> Creatserver()async{
    final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final router = Router()
  
// to ensur the server are working
..all("/", (Request req){
    return Response.ok("the server are working");
})

..get("/readfile/<id>", (Request req , String id )async{
      
  try{
      int numberOfIndex = int.parse(id);
      File mayfile = File("posts.json");
      final Map content = json.decode(await mayfile.readAsString());
      List <Posts> myposts = [];

      content["posts"].map((value)=>myposts.add(Posts.fromjson(json:value))).toList();

      Posts selectposts = myposts.firstWhere((element) => element.id == numberOfIndex);
      return Response(json.encode(selectposts.toMap()) as int, headers:{"Contrnt-Type": "Applecation/json"});


  }catch (error){
    print(error);
      return Response.ok("sory not found");
  }

});


  
  final server = await serve(router, ip, port);
  print('Server listening on port ${server.port}');
}
