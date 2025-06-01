import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  Network.internal();
  static Network _instance = new Network.internal();
  factory Network() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {required Map<String, String> headers, body, encoding}) {
    return http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (!([200, 201].contains(statusCode))) {
        throw new Exception(res);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getWithHeaders(String url,
      {required Map<String, String> headers, bool isResponse = true}) {
    return http
        .get(Uri.parse(url), headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (!([200, 201].contains(statusCode))) {
        throw new Exception("Error while fetching data");
      }
      if (isResponse)
        return _decoder.convert(res);
      else
        return null;
    });
  }
}
