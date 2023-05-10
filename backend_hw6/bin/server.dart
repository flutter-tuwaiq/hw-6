import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'Models/PostModel.dart';

void main() async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final router = Router()
    ..all('/', (Request req) {
      return Response.ok("Server is running");
    })

    //------- read specific id from posts.json with Model -------
    ..get('/post_id/<id>', (Request req, String id) async {
      try {
        File myFile = File('posts.json');

        final Map content = json.decode(await myFile.readAsString());

        int idPost = int.parse(id);
        List<Post> posts = [];

        // add each post information to (posts) list
        content["posts"]
            .map((item) => posts.add(Post.fromJson(json: (item))))
            .toList();

        // find the post by id givin from the endpoint
        Post postSelected = posts.firstWhere((element) => element.id == idPost);

        // send the (postSelected) information as a json
        return Response.ok(json.encode(postSelected.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (error) {
        return Response.notFound("There is no id $id, please try again!");
      }
    });
  ;

  final server = await serve(router, ip, port);

  print("server is starting at: http://${server.address.host}:${server.port}");

  return server;
}
