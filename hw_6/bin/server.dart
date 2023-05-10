import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'Models/Post.dart';

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
    ..get("/read_file/<id>", (Request req, String id) async {
      try {
        int idPosts = int.parse(id);
        File myFile = File('posts.json');
        final Map content = json.decode(await myFile.readAsString());
        List<Post> myPosts = [];

        content['posts']
            .map((value) => myPosts.add(Post.fromJson(json: value)))
            .toList();

        Post selectPosts =
            myPosts.firstWhere((element) => element.id == idPosts);

        return Response.ok(json.encode(selectPosts.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (error) {
        print(error);
        return Response.notFound("Sorry not found");
      }
    });
  final server = await serve(router, ip, port);
  print("server is work at http://${server.address.host}:${server.port}");
  return server;
}