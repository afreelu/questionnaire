package com.kunlun.platform.android.questionnair;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

class KunlunSwiftUtil {
    private static final String TAG = "KunlunSwiftUtil";

    public static void initData(Context context){
        try {
            // Use reflection to safely access KunlunSwift SDK if available
            Class<?> kunlunSwiftClass = Class.forName("com.kunlunswift.platform.android.KunlunSwift");
            Class<?> kunlunConfClass = Class.forName("com.kunlunswift.platform.android.KunlunConf");
            Class<?> kunlunUtilClass = Class.forName("com.kunlunswift.platform.android.KunlunUtil");
            
            // Get methods using reflection
            String uname = (String) kunlunSwiftClass.getMethod("getUname").invoke(null);
            String userId = (String) kunlunConfClass.getMethod("getParam", String.class).invoke(null, "uid");
            String deviceId = (String) kunlunConfClass.getMethod("getParam", String.class).invoke(null, "openUDID");
            String productId = (String) kunlunSwiftClass.getMethod("getProductId").invoke(null);
            String serverId = (String) kunlunSwiftClass.getMethod("getServerId").invoke(null);
            String systemLocation = (String) kunlunSwiftClass.getMethod("getSystemLocation", Context.class).invoke(null, context);
            String location = (String) kunlunSwiftClass.getMethod("getLocation").invoke(null);
            String ip = (String) kunlunUtilClass.getMethod("getLocalIpV6").invoke(null);
            String token = (String) kunlunSwiftClass.getMethod("getAccessToken").invoke(null);
            Boolean isDebug = (Boolean) kunlunSwiftClass.getMethod("isDebug").invoke(null);
            String lang = (String) kunlunSwiftClass.getMethod("getLang").invoke(null);
            
            // Set values using reflection results
            QuestionnairSdk.setUname(uname, true);
            QuestionnairSdk.setUserId(userId, true);
            QuestionnairSdk.setDeviceId(deviceId, true);
            QuestionnairSdk.setProductId(productId, true);
            QuestionnairSdk.setServerId(serverId, true);
            QuestionnairSdk.setCountryCode(TextUtils.isEmpty(systemLocation) ? location : systemLocation, true);
            QuestionnairSdk.setIp(ip, true);
            QuestionnairSdk.setToken(token, true);
            QuestionnairSdk.setDebugMode(isDebug != null ? isDebug : false);
            QuestionnairSdk.setLang(lang, true);
            
            if (QuestionnairSdk.getDebugMode()) {
                Log.i(TAG, "KunlunSwift SDK integration successful");
            }
        } catch (Exception e) {
            if (QuestionnairSdk.getDebugMode()) {
                Log.w(TAG, "KunlunSwift SDK not available or failed to initialize: " + e.getMessage());
            }
            // Provide default values when KunlunSwift SDK is not available
            // These can be overridden by manual calls to QuestionnairSdk setters
        }
    }
}
