package com.kunlun.platform.android.questionnair;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.net.URLEncoder;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class QuestionnairPlugin implements MethodChannel.MethodCallHandler {
    static final String CHANNEL = "com.kunlun.platform.flutterplugins/questionnaire";
    private static final String TAG = "QuestionnairPlugin";
    private Activity activity;
    private static long time;

    private QuestionnairPlugin(Activity activity){
        this.activity = activity;
    }

    public static void registerWith(Activity activity, FlutterEngine flutterEngine) {
        QuestionnairPlugin instance = new QuestionnairPlugin(activity);
        //flutter调用原生
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
        time = ((QuestionnairActivity)activity).time;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Bundle param = null;
//        https:///?act=vote.submit
        String headUrl = QuestionnairSdk.getTest()?"http://test.vote.gameark.cn/?":"https://vote.game-ark.com/?"; //海外
//        String headUrl = QuestionnairSdk.getTest()?"http://test.vote.gameark.cn/?":"https://vote.arkgames.com/?"; //国内
        switch (call.method){
            case "getRequestUrl":
                param = getParamBundle();
                param.putString("act","vote.get");
                String requestString = encodeUrl(param);
                result.success(headUrl+requestString);
                break;
            case "getSubmitUrl":
                param = getParamBundle();
                param.putString("act","vote.submit");
                String submitString = encodeUrl(param);
                result.success(headUrl+submitString);
                break;
            case "finish":
                int retcode = call.argument("retcode");
                String retmsg = call.argument("retmsg");
                QuestionnairSdk.listioner.onComplete(retcode,retmsg);
                activity.finish();
                break;
            case "showToast":
                String message = call.argument("message");
                Toast.makeText(activity,message,Toast.LENGTH_LONG).show();
                break;
            case "getText":
                result.success(QuestionnairSdk.getLang());
                break;
            case "isDebug":
                result.success(String.valueOf(QuestionnairSdk.getDebugMode()));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private Bundle getParamBundle() {
        Bundle param = new Bundle();
        param.putString("uname", QuestionnairSdk.getUname());
        param.putString("uid", QuestionnairSdk.getUserId());
        param.putString("device_id", QuestionnairSdk.getDeviceId());
        param.putString("pid", QuestionnairSdk.getProductId());
        param.putString("rid", QuestionnairSdk.getServerId());
        param.putString("country_code", QuestionnairSdk.getCountryCode());
        param.putString("ip", QuestionnairSdk.getIp());
        param.putString("token", QuestionnairSdk.getToken());
        param.putString("language", TextUtils.isEmpty(QuestionnairSdk.getLang())?"us":QuestionnairSdk.getLang());
        param.putString("vote_id", QuestionnairSdk.voteId+"");
        param.putString("ext1", QuestionnairSdk.getExt1());
        param.putString("ext2", QuestionnairSdk.getExt2());
        param.putString("ext3", QuestionnairSdk.getExt3());
        param.putString("vote_result", "");
        param.putString("base_info", "");
        param.putString("event_name", QuestionnairSdk.getEventName());
        param.putString("event_value", QuestionnairSdk.getEventValue());
        param.putString("device_mode", "android");
        param.putString("session_id", time + param.getString("uid"));
        return param;
    }

    private String encodeUrl(Bundle param) {
        if (param == null) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (String key : param.keySet()) {
            Object parameter = param.get(key);
            if (!(parameter instanceof String)) {
                continue;
            }

            if (first) first = false; else sb.append("&");

            sb.append(URLEncoder.encode(key)).append("=")
                    .append(URLEncoder.encode((String)parameter));
        }
        return sb.toString();
    }
}
