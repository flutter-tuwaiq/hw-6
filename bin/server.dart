import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import '../Models/PostsModel.dart';



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

            int idPost = int.parse(id);
            List<Posts> posts = [];
            File myFile = File('posts.json');
            final Map content = json.decode(await myFile.readAsString());

            content['posts']
            .map((value) => posts.add(Posts.fromJson(json: value))).toList();
            
            Posts selectPost =
              posts.firstWhere((e) => e.id == idPost);
            return Response.ok(json.encode(selectPost.toMap()),
              headers: {'Content-Type': 'Application/json'});

              
        } catch (e) {
           return Response.forbidden("Please check the entries....");
        }
      
    });

  final server = await serve(router, ip, port);
  print("server is work at http://${server.address.host}:${server.port}");
  return server;
}
