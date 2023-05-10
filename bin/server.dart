import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

import 'Models/PostModel.dart';

void main(List<String> args) async {
  withHotreload(() => createServer());
}

//1- The server should be created using the Shelf and Dart.
Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment["PORT"] ?? "6666");

  final router = Router()
    ..all("/", (Request req) => Response.ok("Server is working"))
    ..get('/readfile', (Request req) async {
      //2- Use the data from the included file `posts.json`
      File myFile = File('posts.json');
      final content = await myFile.readAsString();
      return Response.ok(content);
    })
    //3- The server should have an endpoint that queries the posts by entering the post's `id`.
    ..get('/readfile/<id>', (Request req, String id) async {
      try {
        File myFile = File('posts.json');
        final Map content = json.decode(await myFile.readAsString());

        // 4- The server should contain at least one model that represents the data being queried.
        // 5- The model should include all the necessary properties and methods to accurately represent the data being queried.
        List<Post> myPosts = [];

        content['posts']
            .map((value) => myPosts.add(Post.fromJson(json: value)))
            .toList();

        Post selectProduct =
            myPosts.firstWhere((element) => element.id == int.parse(id));
        //6- The server should be able to receive requests, process them, and return a response in JSON format.
        return Response.ok(json.encode(selectProduct.toMap()),
            headers: {'Content-Type': 'Application/json'});
      }
      //7- The server should handle errors appropriately, returning meaningful error messages to the client.
      catch (error) {
        print(error);
        return Response.notFound("Not found");
      }
    });

  final server = await serve(router, ip, port);
  print("Server is working at http://${server.address.host}:${server.port}");
  return server;
}

//8- You should use appropriate coding conventions and best practices.
//9- Your code should be well-organized and easy to read.