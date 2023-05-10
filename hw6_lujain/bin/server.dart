import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'models/model.dart';

Future<Response> postId(Request request, String id) async {
  try {
    File jsonFile = File('../posts.json');
    final Map content = json.decode(await jsonFile.readAsString());
    List<Posts> posts = [];
    content['posts']
        .map((value) => posts.add(Posts.fromJson(json: value)))
        .toList();

    Posts idPost = posts.firstWhere((element) => element.id == int.parse(id));

    return Response.ok(json.encode(idPost.toMap()),
        headers: {'Content-Type': 'Application/json'});
  } catch (error) {
    print(error);
  }
  return Response.notFound('sorry not found');
}

void main(List<String> args) async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = 'localhost';
  final router = Router()..get('/posts/<id>', postId);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(router, ip, port);

  print('http://${server.address.host}:${server.port}');

  return server;
}
