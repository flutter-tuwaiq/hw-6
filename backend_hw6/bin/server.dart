import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'Model/PostsModel.dart';

main() async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment["PORT"] ?? '8080');

  final router = Router()
    ..all('/', (Request req) {
      return Response.ok("server is working");
    })
    ..get('/readfile/<id>', (Request req, String id) async {
      try {
        int idPost = int.parse(id);
        File myFile = File('posts.json');
        final Map content = json.decode(await myFile.readAsString());
        List<Post> mypost = [];

        content['posts']
            .map((value) => mypost.add(Post.fromjson(json: value)))
            .toList();

        Post selectPost = mypost.firstWhere((element) => element.id == idPost);

        return Response.ok(json.encode(selectPost.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (error) {
        print(error);
        return Response.notFound("Sorry not found ");
      }
    });

  final server = await serve(router, ip, port);

  print("Server starting at http://${server.address.host}:${server.port}");
  return server;
}
