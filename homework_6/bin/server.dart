import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'models/Post.dart';

final _router = Router()
  ..all('/', _rootHandler)
  ..get('/find_post/<id>', _findPostHandler);

Response _rootHandler(Request req) {
  return Response.ok('server is working!');
}

Future<Response> _findPostHandler(Request req, String id) async {
  try {
    File jsonFile = File('../posts.json');
    final Map content = json.decode(await jsonFile.readAsString());
    List<Post> myPosts = [];
    content['posts']
        .map((value) => myPosts.add(Post.fromJson(json: value)))
        .toList();

    Post selectedPosts = myPosts.firstWhere((post) => post.id == int.parse(id));

    return Response.ok(json.encode(selectedPosts.toMap()),
        headers: {'Content-Type': 'Application/json'});
  } catch (e) {
    return Response.notFound('Post not found!');
  }
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_router, ip, port);
  print('Server listening on http://${server.address.host}:${server.port}');
}
