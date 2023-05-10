import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'moudle/posts_moudle.dart';


main() {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment["PORT"] ?? "8080");

  final router = Router()
    ..all('/', (Request req) {
      return Response.ok("server is working");
    })
    ..get("/posts_read/<id>", (Request req, String id) async {
      try {
        int idPost = int.parse(id);
        File myFile = File('jsonFile.json');
        final Map content = json.decode(await myFile.readAsString());
        List<post> mypost = [];

        content['posts']
            ..map((value) => mypost.add(post.formJson(json: value)))
            ..toList;

        post selectPost =
            mypost.firstWhere((element) => element.id == idPost);

        return Response.ok(json.encode(selectPost.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (errorindex) {
        print(errorindex);
        return Response.notFound("Sorry not found");
      }
    });

  final server = await serve(router, ip, port);
  print("server is work at http://${server.address.host}:${server.port}");
  return server;
}