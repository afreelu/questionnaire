package com.kunlun.platform.android.questionnair;

import android.content.Context;
import android.text.TextUtils;

import com.kunlunswift.platform.android.KunlunConf;
import com.kunlunswift.platform.android.KunlunSwift;
import com.kunlunswift.platform.android.KunlunUtil;

class KunlunSwiftUtil {

    public static void initData(Context context){
        QuestionnairSdk.setUname(KunlunSwift.getUname(),true);
        QuestionnairSdk.setUserId(KunlunConf.getParam("uid"),true);
        QuestionnairSdk.setDeviceId(KunlunConf.getParam("openUDID"),true);
        QuestionnairSdk.setProductId(KunlunSwift.getProductId(),true);
        QuestionnairSdk.setServerId(KunlunSwift.getServerId(),true);
        QuestionnairSdk.setCountryCode(TextUtils.isEmpty(KunlunSwift.getSystemLocation(context))?KunlunSwift.getLocation():KunlunSwift.getSystemLocation(context),true);
        QuestionnairSdk.setIp(KunlunUtil.getLocalIpV6(),true);
        QuestionnairSdk.setToken(KunlunSwift.getAccessToken(),true);
        QuestionnairSdk.setDebugMode(KunlunSwift.isDebug());
        QuestionnairSdk.setLang(KunlunSwift.getLang(),true);
    }
}
