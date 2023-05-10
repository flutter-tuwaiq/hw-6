import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'Model/models.dart';

void main() {
  withHotreload(()=> createServer());
}

Future<HttpServer> createServer()async{
final ip = InternetAddress.anyIPv4;
 final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Configure a pipeline that logs requests.
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // Use any available host or container IP (usually `0.0.0.0`).
  final router = Router()
  ..all('/', (Request req ){
    
      return Response.ok("server is working");
  })
 ..get("/posts/<id>", (Request req, String id)async{
    try{

    int idPosts = int.parse(id);

    File myFile = File('jsonFile.json');

    final Map content = json.decode(await myFile.readAsString() );

     List <Posts> myPosts=[];

     content['posts'].map((value)=> 
     myPosts.add(Posts.fromJson(json:value))).toList();


     Posts postsSelect= myPosts.firstWhere((element)=> element.id== idPosts);
    
    return Response.ok(json.encode(postsSelect.toMap()),
     headers: {'Content-Type': 'Application/json'});
    }catch(error){
      print(error);
   

   
    return Response.notFound("sorry post not found");
   }});
  // Configure a pipeline that logs requests.
  //inal handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
 
  final server = await serve(router, ip, port);
  print('Server listening on port ${server.address.host}:${server.port}');
  return server;
}