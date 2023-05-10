import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'Models/PostsModel.dart';


void main(List<String> args)async {
  withHotreload(() => createServer());
 
}
Future<HttpServer> createServer() async{
 final ip =InternetAddress.anyIPv4; 

 final port = int.parse(Platform.environment["PORT"] ?? "8080"); 

 final router = Router()
 ..get('/readfile', (Request req)async{ 
  File myfile = File('posts.json');
  final content = await myfile.readAsString();
  print(content); 
 return Response.ok("check console");
 })..get('/readfile/<id>', (Request req, String id)async{ 
  try{
  int idPost= int.parse(id);
  File myfile = File('posts.json');
  final Map content =json.decode(await myfile.readAsString());
  List<Posts> MyPost=[];
  content['posts'].map((value)=>MyPost.add(Posts.fromJson(json:value))).toList();
  Posts selectPost= MyPost.firstWhere((element) => element.id == idPost);

  return Response.ok(json.encode(selectPost.toMap()),headers: {'Content-Type': 'Application/'});
  }catch(error){
    print(error);
    return Response.notFound("Something went wrong..try another Id");
  }
 });

 final server =await serve(router, ip, port);

 print("server is starting at http:${server.address.host}:${server.port}");
 return server;
}
