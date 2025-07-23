package com.kunlun.platform.android.questionnair;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

class KunlunSdkUtil {
    private static final String TAG = "KunlunSdkUtil";

    public static void initData(Context context){
        try {
            // Use reflection to safely access Kunlun SDK if available
            Class<?> kunlunClass = Class.forName("com.kunlun.platform.android.Kunlun");
            Class<?> kunlunConfClass = Class.forName("com.kunlun.platform.android.KunlunConf");
            Class<?> kunlunUtilClass = Class.forName("com.kunlun.platform.android.KunlunUtil");
            
            // Get methods using reflection
            String uname = (String) kunlunClass.getMethod("getUname").invoke(null);
            String userId = (String) kunlunClass.getMethod("getUserId").invoke(null);
            String deviceId = (String) kunlunConfClass.getMethod("getParam", String.class).invoke(null, "openUDID");
            String productId = (String) kunlunClass.getMethod("getProductId").invoke(null);
            String serverId = (String) kunlunClass.getMethod("getServerId").invoke(null);
            String systemLocation = (String) kunlunClass.getMethod("getSystemLocation", Context.class).invoke(null, context);
            String location = (String) kunlunClass.getMethod("getLocation").invoke(null);
            String ip = (String) kunlunUtilClass.getMethod("getLocalIpV6").invoke(null);
            String token = (String) kunlunClass.getMethod("getKLSSO").invoke(null);
            Boolean isDebug = (Boolean) kunlunClass.getMethod("isDebug").invoke(null);
            String lang = (String) kunlunClass.getMethod("getLang").invoke(null);
            
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
                Log.i(TAG, "Kunlun SDK integration successful");
            }
        } catch (Exception e) {
            if (QuestionnairSdk.getDebugMode()) {
                Log.w(TAG, "Kunlun SDK not available or failed to initialize: " + e.getMessage());
            }
            // Provide default values when Kunlun SDK is not available
            // These can be overridden by manual calls to QuestionnairSdk setters
        }
    }
}
