//从服务器获取的数据的封装类
import 'dart:convert';

import 'package:questionnaire_sdk/utils/dataUtils.dart';

class Response {
  int? retcode;
  String? retmsg;
  String? data;

  Response({this.retcode, this.retmsg, this.data});

  Response.fromJson(Map<String, dynamic> map) {
    retcode = map['retcode'];
    retmsg = map['retmsg'];
    data = map['data'] != null ? json.encode(map["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retcode'] = this.retcode;
    data['retmsg'] = this.retmsg;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
