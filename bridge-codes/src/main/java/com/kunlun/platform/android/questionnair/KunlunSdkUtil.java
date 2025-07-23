package com.kunlun.platform.android.questionnair;

import android.content.Context;
import android.text.TextUtils;

import com.kunlun.platform.android.Kunlun;
import com.kunlun.platform.android.KunlunConf;
import com.kunlun.platform.android.KunlunUtil;

class KunlunSdkUtil {

    public static void initData(Context context){
        QuestionnairSdk.setUname(Kunlun.getUname(),true);
        QuestionnairSdk.setUserId(Kunlun.getUserId(),true);
        QuestionnairSdk.setDeviceId(KunlunConf.getParam("openUDID"),true);
        QuestionnairSdk.setProductId(Kunlun.getProductId(),true);
        QuestionnairSdk.setServerId(Kunlun.getServerId(),true);
        QuestionnairSdk.setCountryCode(TextUtils.isEmpty(Kunlun.getSystemLocation(context))?Kunlun.getLocation():Kunlun.getSystemLocation(context),true);
        QuestionnairSdk.setIp(KunlunUtil.getLocalIpV6(),true);
        QuestionnairSdk.setToken(Kunlun.getKLSSO(),true);
        QuestionnairSdk.setDebugMode(Kunlun.isDebug());
        QuestionnairSdk.setLang(Kunlun.getLang(),true);
    }
}
