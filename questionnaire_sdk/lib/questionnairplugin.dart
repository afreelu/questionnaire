import 'package:flutter/services.dart';

class QuestionnairPlugin{
  static const channel = const MethodChannel('com.kunlun.platform.flutterplugins/questionnaire');

  /// 向原生获取问卷调查服务器地址
  static Future<String> getRequestUrl() async {
    return await channel.invokeMethod('getRequestUrl');
  }

  /// 向原生获取问卷调查服务器地址
  static Future<String> getSubmitUrl() async {
    return await channel.invokeMethod('getSubmitUrl');
  }

  ///通知原生关闭页面，并回调参数
  static void finishWithCallback(int retcode,String retmsg){
    Map map = new Map();
    map['retcode']=retcode;
    map['retmsg']=retmsg;
    channel.invokeMethod('finish',map);
  }

  ///获取要显示的字符对应的map
  static Future<String> getText() async {
    return await channel.invokeMethod('getText');
  }

  ///通知原生弹出提示
  static void showToast(String msg){
    Map map = new Map();
    map['message']=msg;
    channel.invokeMethod('showToast',map);
  }

  ///是否是debug模式
  static Future<String> isDebug() async {
    return await channel.invokeMethod('isDebug');
  }
}
