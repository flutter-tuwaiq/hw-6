import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

import 'model/model.dart';

// List: to store the values from server (database)
List<Map<String, dynamic>> userInfo = [];
// Counter id

void main(List<String> args) async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');

  final Router router = Router()
    ..all('/', (Request req) async {
      try {
        return Response.ok('Server is running...');
      } catch (error) {
        return Response.notFound(
            'There is a Problem with the connection, please try later');
      }
    })

    // __________________GET: Display all Posts_________________________
    ..get('/read_file', (Request req) async {
      try {
        File myfile = File("posts.json");
        final Map content = json.decode(await myfile.readAsString());

        return Response.ok(json.encode(content['posts']),
            headers: {'Content-Type': 'Application/json'});
      } catch (error) {
        return Response.notFound("Posts are not reachable at this moment");
      }
    })

    // __________________GET: Display Posts By Index_________________________
    ..get('/read_file/<id>', (Request req, String id) async {
      try {
        File myfile = File("posts.json");
        final Map content = json.decode(await myfile.readAsString());
        List<Prodict> myPosts = [];

        content["posts"]
            .map((value) => myPosts.add(Prodict.fromJson(json: value)))
            .toList();

        Prodict selectPost =
            myPosts.firstWhere((item) => item.id == int.parse(id));
        return Response.ok(json.encode(selectPost.toMap()),
            headers: {'Content-Type': 'Application/json'});
      } catch (error) {
        return Response.notFound("Id not found, please enter a correct ID");
      }
    });

  final server = await serve(router, ip, port);

  print("Server starting at http://${server.address.host}:${server.port}");

  return server;
}
