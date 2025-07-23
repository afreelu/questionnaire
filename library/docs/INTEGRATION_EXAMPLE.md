# SDK集成示例

本文档提供了完整的SDK集成示例，展示如何在Android项目中集成问卷调查SDK。

## 示例项目结构

```
MyApp/
├── app/
│   ├── src/main/
│   │   ├── java/com/example/myapp/
│   │   │   ├── MyApplication.java
│   │   │   ├── MainActivity.java
│   │   │   └── QuestionnaireManager.java
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   └── activity_main.xml
│   │   │   └── values/
│   │   │       └── strings.xml
│   │   └── AndroidManifest.xml
│   ├── libs/
│   │   ├── sdk-release.aar
│   │   ├── kunlun.v6.012.1617-all.jar
│   │   └── kunlun_swift.v1.101.2811.aar
│   └── build.gradle
├── flutter_aar/
│   └── com/kunlun/android/questionnaire/
└── build.gradle
```

## 1. 项目级build.gradle配置

```gradle
// 项目根目录的build.gradle
buildscript {
    ext.kotlin_version = "1.8.20"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:7.4.2"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

## 2. 应用级build.gradle配置

```gradle
// app/build.gradle
apply plugin: 'com.android.application'

android {
    namespace 'com.example.myapp'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.myapp"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        debug {
            debuggable true
            minifyEnabled false
        }
        profile {
            initWith debug
            debuggable false
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

repositories {
    flatDir {
        dirs 'libs'
    }
    maven {
        url '../flutter_aar'
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    // Flutter AAR依赖
    debugImplementation 'com.kunlun.android.questionnaire:flutter_debug:1.0'
    profileImplementation 'com.kunlun.android.questionnaire:flutter_profile:1.0'
    releaseImplementation 'com.kunlun.android.questionnaire:flutter_release:1.0'
    
    // SDK和外部库依赖（排除重复类以避免冲突）
    implementation(name: 'sdk-release', ext: 'aar') {
        exclude group: 'io.flutter', module: 'flutter_embedding_debug'
        exclude group: 'io.flutter', module: 'flutter_embedding_profile'
        exclude group: 'io.flutter', module: 'flutter_embedding_release'
    }
    implementation files('libs/kunlun.v6.012.1617-all.jar')
    implementation(name: 'kunlun_swift.v1.101.2811', ext: 'aar')
    
    // 测试依赖
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
```

## 3. AndroidManifest.xml配置

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- 网络权限 -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- 可选权限 -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
        android:maxSdkVersion="28" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
        android:maxSdkVersion="32" />

    <application
        android:name=".MyApplication"
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.MyApp"
        tools:targetApi="31">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.MyApp">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
    </application>

</manifest>
```

## 4. Application类实现

```java
// MyApplication.java
package com.example.myapp;

import android.app.Application;
import android.util.Log;

import com.kunlun.platform.android.questionnair.QuestionnairSdk;

public class MyApplication extends Application {
    private static final String TAG = "MyApplication";
    
    @Override
    public void onCreate() {
        super.onCreate();
        
        // 初始化问卷调查SDK
        try {
            QuestionnairSdk.init(this);
            Log.d(TAG, "Questionnaire SDK initialized successfully");
        } catch (Exception e) {
            Log.e(TAG, "Failed to initialize Questionnaire SDK", e);
        }
    }
}
```

## 5. MainActivity实现

```java
// MainActivity.java
package com.example.myapp;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.kunlun.platform.android.questionnair.QuestionnairSdk;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    private QuestionnaireManager questionnaireManager;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // 初始化问卷管理器
        questionnaireManager = new QuestionnaireManager(this);
        
        // 设置按钮点击事件
        Button btnStartQuestionnaire = findViewById(R.id.btn_start_questionnaire);
        btnStartQuestionnaire.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startQuestionnaire();
            }
        });
        
        // 设置结果监听器
        setupResultListener();
    }
    
    private void startQuestionnaire() {
        // 示例配置
        String userId = "user_" + System.currentTimeMillis();
        String questionnaireId = "sample_questionnaire_001";
        String serverUrl = "https://api.example.com/questionnaire";
        
        questionnaireManager.startQuestionnaire(userId, questionnaireId, serverUrl);
    }
    
    private void setupResultListener() {
        QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
            @Override
            public void onSuccess(String result) {
                Log.d(TAG, "Questionnaire completed: " + result);
                runOnUiThread(() -> {
                    Toast.makeText(MainActivity.this, "问卷完成！", Toast.LENGTH_SHORT).show();
                    // 处理问卷结果
                    questionnaireManager.handleQuestionnaireResult(result);
                });
            }
            
            @Override
            public void onError(String error) {
                Log.e(TAG, "Questionnaire error: " + error);
                runOnUiThread(() -> {
                    Toast.makeText(MainActivity.this, "问卷出错：" + error, Toast.LENGTH_LONG).show();
                });
            }
            
            @Override
            public void onCancel() {
                Log.d(TAG, "Questionnaire cancelled");
                runOnUiThread(() -> {
                    Toast.makeText(MainActivity.this, "问卷已取消", Toast.LENGTH_SHORT).show();
                });
            }
        });
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 清理资源
        QuestionnairSdk.setResultListener(null);
    }
}
```

## 6. 问卷管理器实现

```java
// QuestionnaireManager.java
package com.example.myapp;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;

import com.kunlun.platform.android.questionnair.QuestionnairActivity;
import com.kunlun.platform.android.questionnair.QuestionnairSdk;

import org.json.JSONException;
import org.json.JSONObject;

public class QuestionnaireManager {
    private static final String TAG = "QuestionnaireManager";
    private static final String PREFS_NAME = "questionnaire_prefs";
    private static final String KEY_LAST_RESULT = "last_result";
    
    private Context context;
    private SharedPreferences prefs;
    
    public QuestionnaireManager(Context context) {
        this.context = context;
        this.prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
    }
    
    /**
     * 启动问卷调查
     */
    public void startQuestionnaire(String userId, String questionnaireId, String serverUrl) {
        if (!validateParameters(userId, questionnaireId, serverUrl)) {
            Log.e(TAG, "Invalid parameters for questionnaire");
            return;
        }
        
        try {
            QuestionnairSdk.Builder builder = new QuestionnairSdk.Builder()
                .setUserId(userId)
                .setQuestionnaireId(questionnaireId)
                .setServerUrl(serverUrl)
                .setLanguage("zh-CN")
                .setTimeout(60);
            
            QuestionnairActivity.start(context, builder.build());
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to start questionnaire", e);
        }
    }
    
    /**
     * 启动带自定义配置的问卷调查
     */
    public void startQuestionnaireWithConfig(String userId, String questionnaireId, 
                                           String serverUrl, String language, String theme) {
        if (!validateParameters(userId, questionnaireId, serverUrl)) {
            Log.e(TAG, "Invalid parameters for questionnaire");
            return;
        }
        
        try {
            QuestionnairSdk.Builder builder = new QuestionnairSdk.Builder()
                .setUserId(userId)
                .setQuestionnaireId(questionnaireId)
                .setServerUrl(serverUrl)
                .setLanguage(language)
                .setTheme(theme)
                .setTimeout(90);
            
            QuestionnairActivity.start(context, builder.build());
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to start questionnaire with config", e);
        }
    }
    
    /**
     * 处理问卷结果
     */
    public void handleQuestionnaireResult(String result) {
        if (TextUtils.isEmpty(result)) {
            Log.w(TAG, "Empty questionnaire result");
            return;
        }
        
        try {
            JSONObject resultObj = new JSONObject(result);
            
            // 保存结果到本地
            saveResultToLocal(result);
            
            // 解析结果
            String questionnaireId = resultObj.optString("questionnaireId");
            String userId = resultObj.optString("userId");
            int score = resultObj.optInt("score", 0);
            long duration = resultObj.optLong("duration", 0);
            
            Log.d(TAG, String.format("Questionnaire result - ID: %s, User: %s, Score: %d, Duration: %d", 
                questionnaireId, userId, score, duration));
            
            // 可以在这里添加结果上传到服务器的逻辑
            // uploadResultToServer(result);
            
        } catch (JSONException e) {
            Log.e(TAG, "Failed to parse questionnaire result", e);
        }
    }
    
    /**
     * 验证参数
     */
    private boolean validateParameters(String userId, String questionnaireId, String serverUrl) {
        if (TextUtils.isEmpty(userId)) {
            Log.e(TAG, "User ID is required");
            return false;
        }
        
        if (TextUtils.isEmpty(questionnaireId)) {
            Log.e(TAG, "Questionnaire ID is required");
            return false;
        }
        
        if (TextUtils.isEmpty(serverUrl)) {
            Log.e(TAG, "Server URL is required");
            return false;
        }
        
        if (!serverUrl.startsWith("http://") && !serverUrl.startsWith("https://")) {
            Log.e(TAG, "Invalid server URL format");
            return false;
        }
        
        return true;
    }
    
    /**
     * 保存结果到本地
     */
    private void saveResultToLocal(String result) {
        prefs.edit()
            .putString(KEY_LAST_RESULT, result)
            .putLong("last_save_time", System.currentTimeMillis())
            .apply();
        
        Log.d(TAG, "Questionnaire result saved to local storage");
    }
    
    /**
     * 获取上次的问卷结果
     */
    public String getLastResult() {
        return prefs.getString(KEY_LAST_RESULT, null);
    }
    
    /**
     * 清除本地保存的结果
     */
    public void clearLocalResults() {
        prefs.edit().clear().apply();
        Log.d(TAG, "Local questionnaire results cleared");
    }
}
```

## 7. 布局文件

```xml
<!-- res/layout/activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout 
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <TextView
        android:id="@+id/tv_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="问卷调查SDK示例"
        android:textSize="24sp"
        android:textStyle="bold"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintVertical_bias="0.3" />

    <Button
        android:id="@+id/btn_start_questionnaire"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="32dp"
        android:text="开始问卷调查"
        android:textSize="18sp"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_title" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

## 8. 字符串资源

```xml
<!-- res/values/strings.xml -->
<resources>
    <string name="app_name">问卷调查示例</string>
    <string name="start_questionnaire">开始问卷调查</string>
    <string name="questionnaire_completed">问卷完成！</string>
    <string name="questionnaire_cancelled">问卷已取消</string>
    <string name="questionnaire_error">问卷出错</string>
</resources>
```

## 9. 混淆配置

```proguard
# app/proguard-rules.pro

# 保持SDK相关类
-keep class com.kunlun.platform.android.questionnair.** { *; }
-keep class io.flutter.** { *; }
-keep class com.kunlun.** { *; }

# 保持Flutter相关
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# 保持应用自身的类
-keep class com.example.myapp.** { *; }

# 保持Gson相关（如果使用）
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# 保持网络请求相关
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
```

## 10. 运行和测试

### 构建项目

```bash
# 清理项目
./gradlew clean

# 构建Debug版本
./gradlew assembleDebug

# 构建Release版本
./gradlew assembleRelease
```

### 安装和运行

```bash
# 安装Debug APK
./gradlew installDebug

# 启动应用
adb shell am start -n com.example.myapp/.MainActivity
```

### 日志查看

```bash
# 查看应用日志
adb logcat -s MyApplication MainActivity QuestionnaireManager

# 查看SDK日志
adb logcat -s QuestionnairSdk QuestionnairActivity
```

## 常见问题解决

### 1. 构建失败

- 检查AAR文件是否正确放置在`app/libs/`目录
- 确认Flutter AAR路径配置正确
- 检查依赖版本兼容性

### 2. 运行时崩溃

- 确认SDK已在Application中正确初始化
- 检查网络权限是否添加
- 查看日志确定具体错误原因

### 3. 问卷无法启动

- 验证传入参数是否正确
- 检查网络连接
- 确认服务器地址可访问

这个示例展示了完整的SDK集成流程，您可以根据实际需求进行调整和扩展。