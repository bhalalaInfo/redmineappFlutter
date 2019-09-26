import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Network {
  Network.internal();
  static Network _instance = new Network.internal();
  factory Network() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.encodeFull(url)).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(Uri.encodeFull(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (!([200, 201].contains(statusCode)) || response == null) {
        throw new Exception(res);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getWithHeaders(String url,
      {@required Map headers, bool isResponse = true}) {
    return http.get(Uri.encodeFull(url), headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (!([200, 201].contains(statusCode)) || response == null) {
        throw new Exception("Error while fetching data");
      }
      if (isResponse)
        return _decoder.convert(res);
      else
        return null;
    });
  }
}
