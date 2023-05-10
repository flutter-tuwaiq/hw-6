import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment["PORT"] ?? "6666");

  final router = Router();

  final server = await serve(router, ip, port);
  print("Server is working at http://${server.address.host}:${server.port}");
  return server;
}




// import 'dart:io';
// import 'dart:convert';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart';
// import 'package:shelf_hotreload/shelf_hotreload.dart';
// import 'package:shelf_router/shelf_router.dart';

// import 'Models/ProductModel.dart';

// void main(List<String> args) {
//   withHotreload(() => createServer());
// }

// Future<HttpServer> createServer() async {
//   final ip = InternetAddress.anyIPv4;
//   final port = int.parse(Platform.environment["PORT"] ?? "9090");

//   final router = Router()
//     ..all('/', (Request req) {
//       return Response.ok("Server is working");
//     })
//     ..get('/readfile', (Request req) async {
//       File myFile = File('jsonFile.json');
//       final content = await myFile.readAsString();

//       print(content);
//       return Response.ok(content);
//     })
//     ..get('/readfile/<id>', (Request req, String id) async {
//       try {
//         int idProduct = int.parse(id);
//         File myFile = File('jsonFile.json');
//         final Map content = json.decode(await myFile.readAsString());
//         List<Product> myProducts = [];

//         content['products']
//             .map((value) => myProducts.add(Product.fromJson(json: value)))
//             .toList();

//         Product selectProduct =
//             myProducts.firstWhere((element) => element.id == idProduct);

//         // return Response.ok(json.encode({"id": selectProduct.id}),
//         return Response.ok(json.encode(selectProduct.toMap()),
//             headers: {'Content-Type': 'Application/json'});
//       } catch (error) {
//         print(error);
//         return Response.notFound("Not found");
//       }
//     });

//   final server = await serve(router, ip, port);
//   print("Server is working at http://${server.address.host}:${server.port}");
//   return server;
// }