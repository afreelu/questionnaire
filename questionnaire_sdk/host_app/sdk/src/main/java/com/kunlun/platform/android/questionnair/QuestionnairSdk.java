package com.kunlun.platform.android.questionnair;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import java.lang.reflect.Method;

import io.flutter.FlutterInjector;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class QuestionnairSdk {
    private static final String TAG = "QuestionnairSdk";
    static int voteId;
    static Bundle param = new Bundle();
    static QuestionnairListioner listioner;
    private static QuestionnairSdk instance;
    static final String SDK_PRE = "sdk_";

    private QuestionnairSdk(final Activity activity){
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                FlutterInjector.instance().flutterLoader().startInitialization(activity);
            }
        });
    }
    private static void init(Activity activity){
        if (hasKunlunSdk()){
            try {
                Class c = Class.forName("com.kunlun.platform.android.questionnair.KunlunSdkUtil");
                Method initData = c.getMethod("initData", Context.class);
                initData.invoke(c,activity);
            } catch (Exception ignored) {
            }
        }else if (hasKunlunSwift()){
            try {
                Class c = Class.forName("com.kunlun.platform.android.questionnair.KunlunSwiftUtil");
                Method initData = c.getMethod("initData",Context.class);
                initData.invoke(c,activity);
            } catch (Exception ignored) {
            }
        }
    }

    public static QuestionnairSdk getInstance(Activity activity){
        init(activity);
        if (instance == null){
            instance = new QuestionnairSdk(activity);
        }
        return instance;
    }

    private static void setParam(String key,String value,boolean isSdk){
        String paramKey = isSdk ? (SDK_PRE + key) : key;
        param.putString(paramKey,value);
    }

    private static String getParam(String key){
        return TextUtils.isEmpty(param.getString(key,""))?param.getString(SDK_PRE+key):param.getString(key);
    }

    /**
     * 打开调查问卷窗口
     * @param activity 上下文环境
     * @param voteId  调查问卷的问卷id
     * @param lang  调查问卷的显示语言,如果传入非法编码，以默认英文显示，如果已经接入平台SDK，可以传入空串，会自动使用平台的语言
     * @param listioner 问卷窗口关闭时的回调，retcode为0表示成功，retcode为-1表示用户主动关闭窗口
     */
    public void showQuestionnaire(final Activity activity, int voteId, String lang, QuestionnairListioner listioner){
        QuestionnairSdk.voteId = voteId;
        QuestionnairSdk.listioner = listioner;
        if (!TextUtils.isEmpty(lang))  QuestionnairSdk.setLang(lang);

        if (activity != null) {
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Intent intent = new Intent(activity, QuestionnairActivity.class);
                    intent.putExtra("background_mode", FlutterActivityLaunchConfigs.BackgroundMode.transparent.toString());
                    activity.startActivity(intent);
                }
            });
        }else {
            if(QuestionnairSdk.getDebugMode()) Log.i(TAG,"Activity is null.");
        }
    }

    public static interface QuestionnairListioner{
        public void onComplete(int retcode, String retmsg);
    }

    public static void setTest(boolean isTest) {
        param.putBoolean("isTest",isTest);
    }

    public static boolean getTest() {
        return param.getBoolean("isTest",false);
    }

    public static int getVoteId() {
        return voteId;
    }

    public static void setVoteId(int voteId) {
        QuestionnairSdk.voteId = voteId;
    }

    public static String getUname() {
        return getParam("uname");
    }

    public static void setUname(String uname) {
        setUname(uname,false);
    }

    static void setUname(String uname,boolean isSdk) {
        setParam("uname",uname,isSdk);
    }

    public static String getUserId() {
        return getParam("userId");
    }

    public static void setUserId(String userId) {
        setUserId(userId,false);
    }

    static void setUserId(String userId,boolean isSdk){
        setParam("userId",userId,isSdk);
    }

    public static String getDeviceId() {
        return getParam("deviceId");
    }

    public static void setDeviceId(String deviceId) {
        setDeviceId(deviceId,false);
    }

    static void setDeviceId(String deviceId, boolean isSdk){
        setParam("deviceId",deviceId,isSdk);
    }

    public static String getProductId() {
        return getParam("productId");
    }

    public static void setProductId(String productId) {
        setProductId(productId,false);
    }

    static void setProductId(String productId, boolean isSdk){
        setParam("productId",productId,isSdk);
    }

    public static String getServerId() {
        return getParam("serverId");
    }

    public static void setServerId(String serverId) {
        setServerId(serverId,false);
    }

    static void setServerId(String serverId, boolean isSdk){
        setParam("serverId",serverId,isSdk);
    }

    public static String getLang() {
        return getParam("lang");
    }

    public static void setLang(String lang) {
        setLang(lang,false);
    }

    static void setLang(String lang,boolean isSdk){
        setParam("lang",lang,isSdk);
    }

    public static String getCountryCode() {
        return getParam("countryCode");
    }

    public static void setCountryCode(String countryCode) {
        setCountryCode(countryCode,false);
    }

    static void setCountryCode(String countryCode,boolean isSdk){
        setParam("countryCode",countryCode,isSdk);
    }

    public static String getIp() {
        return getParam("ip");
    }

    public static void setIp(String ip) {
        setIp(ip,false);
    }

    static void setIp(String ip,boolean isSdk){
        setParam("ip",ip,isSdk);
    }

    public static String getToken() {
        return getParam("token");
    }

    public static void setToken(String token) {
        setToken(token,false);
    }

    static void setToken(String token,boolean isSdk){
        setParam("token",token,isSdk);
    }

    public static String getExt1() {
        return param.getString("ext1");
    }

    public static void setExt1(String ext1) {
        param.putString("ext1",ext1);
    }

    public static String getExt2() {
        return param.getString("ext2");
    }

    public static void setExt2(String ext2) {
        param.putString("ext2",ext2);
    }

    public static String getExt3() {
        return param.getString("ext3");
    }

    public static void setExt3(String ext3) {
        param.putString("ext3",ext3);
    }

    public static String getEventName() {
        return param.getString("eventName");
    }

    public static void setEventName(String eventName) {
        param.putString("eventName",eventName);
    }

    public static String getEventValue() {
        return param.getString("eventValue");
    }

    public static void setEventValue(String eventValue) {
        param.putString("eventValue",eventValue);
    }

    public static boolean getDebugMode() {
        return param.getBoolean("isDebug");
    }

    public static void setDebugMode(boolean isDebug) {
        param.putBoolean("isDebug",isDebug);
    }

    static boolean hasKunlunSdk() {
        try {
            Class.forName("com.kunlun.platform.android.Kunlun");
            return true;
        }catch (Exception e){
            if(getDebugMode()) Log.i(TAG,"kunlun sdk is not exist");
            return false;
        }
    }

    static boolean hasKunlunSwift() {
        try {
            Class.forName("com.kunlunswift.platform.android.KunlunSwift");
            return true;
        }catch (Exception e){
            if(getDebugMode()) Log.i(TAG,"kunlunswift sdk is not exist");
            return false;
        }
    }
}
