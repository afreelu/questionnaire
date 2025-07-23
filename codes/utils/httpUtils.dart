import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'dataUtils.dart';

class HttpUtils {
  var client = http.Client();

  httpGet(String url, Function callback(int code, String retmsg)) async {
    client
        .get(Uri.parse(url))
        .then((http.Response response) {
          if (response.statusCode == 200) {
            callback(0, response.body);
          } else {
            callback(-100, response.body);
          }
        })
        .timeout(Duration(seconds: 10))
        .catchError((e, s) {
          DataUtils.printMsg("Get请求发生了异常:" + e.toString() + s.toString());
          if (e is SocketException) {
            callback(-101, "Network error");
          } else {
            if (e.toString().contains('Function')) {
              DataUtils.printMsg("Get请求发生了异常:" +
                  e.toString() +
                  "无法排查出来该Function在什么位置，因此不处理回调");
            } else {
              callback(-102, e.toString());
            }
          }
        });
  }

  httpPost(String url, Map<String, String> params,
      Function callback(int code, String msg)) async {
    Map<String, String> headersMap = new Map();
    headersMap["content-type"] = "application/x-www-form-urlencoded";
    client
        .post(Uri.parse(url),
            headers: headersMap, body: params, encoding: Utf8Codec())
        .then((http.Response response) {
          if (response.statusCode == 200) {
            callback(0, response.body);
          } else {
            callback(-100, response.body);
          }
        })
        .timeout(Duration(seconds: 10))
        .catchError((e) {
          DataUtils.printMsg("Post请求发生了异常:" + e.toString());
          if (e is SocketException)
            callback(-101, "Network error");
          else {
            if (e.toString().contains('Function')) {
              DataUtils.printMsg("Get请求发生了异常:" +
                  e.toString() +
                  "无法排查出来该Function在什么位置，因此不处理回调");
            } else {
              callback(-102, e.toString());
            }
          }
        });
  }
}
