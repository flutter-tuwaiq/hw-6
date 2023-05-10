import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

import 'Models/PostsModel.dart';

void main(List<String> args) async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final router = Router()
    ..get("/posts/<id>", (Request req, String id) async {
      try {
        int idPost = int.parse(id);
        File myFile = File("posts.json");
        final Map content = json.decode(await myFile.readAsString());

        List<Posts> myPost = [];

        content["posts"]
            .map(((value) => myPost.add(Posts.fromJson(value))))
            .toList();

        Posts postSelect = myPost.firstWhere((element) => element.id == idPost);

        return Response.ok(json.encode(postSelect.toMap()),
            headers: {"Content-Type": "Application/json"});
      } catch (error) {
        return Response.notFound("Sorry... id not found");
      }
    });

  final server = await serve(router, ip, port);
  print('Server listening on port http://${server.address.host}:${server.port}');
  return server;
}
