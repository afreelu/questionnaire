package com.kunlun.platform.android.questionnair;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class QuestionnairActivity extends FlutterActivity {
    public Long time = null;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        if (Build.VERSION.SDK_INT >= 28) {
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            getWindow().setAttributes(lp);
        }

        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
        super.onCreate(savedInstanceState);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.windowAnimations = android.R.style.Animation_Dialog;
        getWindow().setAttributes(params);
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine){
        if (time == null) time = System.currentTimeMillis();
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        QuestionnairPlugin.registerWith(this,flutterEngine);
    }

    @Override
    protected void onDestroy() {
        if (time!=null) time = null;
        super.onDestroy();
    }
}
