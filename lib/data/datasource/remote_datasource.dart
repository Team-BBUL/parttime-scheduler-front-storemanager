/*
import 'package:sidam/data/model/store_management.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

class RemoteDataSource {
  getStore() {}

  getUser() {}

  getStoreManagement() {}
}

class MockServer {
  static Future<void> start() async {
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((request) async {
      if (request.uri.path == '/users') {
        var response = await Response.ok({
          'users': [
            {
              'id': 1,
              'name': 'John Doe',
            },
            {
              'id': 2,
              'name': 'Jane Doe',
            },
          ],
        });
        await response.writeTo(request.response);
      } else {
        await request.response.write('404 Not Found');
      }
    });
  }

  static Future<void> stop() async {
    var server = await HttpServer.lookup('localhost', 8080);
    await server.close();
  }
}*/
