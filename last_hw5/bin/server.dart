
import 'dart:io';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'PostModel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'model/modelpost.dart';
//import 'post/PostModel.dar';
//import 'Models/ProductModel.dart';
void main(List<String> args)async {
  withHotreload(() => createServer());
}
Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment["PORT"] ?? "8080");

  final router = Router()
    ..all('/', (Request req) {
      return Response.ok("server is working");
    })
              
    ..get("/read_1file/<id>", (Request req, String id) async {

      try {
        int idPost = int.parse(id);
        File myFile = File('/Users/fawzisaleh/Desktop/last_hw5/bin/posts.json');
        final Map content = json.decode(await myFile.readAsString());
        List<PostModel> mypodt = [];

        content['PostModel'].map(((value)
         => mypodt.add(PostModel.fromJson(json: value)))).toList();

        PostModel select = mypodt.firstWhere((element) => element.id == idPost);
        return Response.ok(json.encode(select.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (e) {
        //print(e);
        return Response.notFound("Sorry not found");
      }
    });

  final server = await serve(router, ip, port);
  print("server is work at http://${server.address.host}:${server.port}");
  return server;
}
