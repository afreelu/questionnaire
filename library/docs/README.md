# 问卷调查SDK接入文档

## 概述

本SDK提供了完整的问卷调查功能，基于Flutter技术开发，支持Android平台集成。SDK包含以下组件：

- **Flutter AAR**: 问卷调查核心功能模块
- **Android SDK**: 封装了Flutter集成逻辑的Android库
- **外部依赖**: Kunlun和KunlunSwift第三方库

## 目录结构

```
library/
├── flutter_aar/          # Flutter AAR文件
│   └── com/kunlun/android/questionnaire/
├── android_sdk/           # Android SDK AAR文件
│   └── sdk-release.aar
├── external_libs/         # 外部依赖库
│   ├── kunlun.v6.012.1617-all.jar
│   └── kunlun_swift.v1.101.2811.aar
└── docs/                  # 文档目录
    ├── README.md
    └── API_REFERENCE.md
```

## 集成步骤

### 1. 添加依赖库

将以下文件复制到您的Android项目的 `app/libs/` 目录下：

- `android_sdk/sdk-release.aar`
- `external_libs/kunlun.v6.012.1617-all.jar`
- `external_libs/kunlun_swift.v1.101.2811.aar`

### 2. 配置Flutter AAR仓库

将 `flutter_aar` 目录复制到您的项目根目录，然后在 `app/build.gradle` 中添加仓库配置：

```gradle
android {
    compileSdk 34
    
    buildTypes {
        debug {
            // debug配置
        }
        profile {
            initWith debug
        }
        release {
            // release配置
        }
    }
}

repositories {
    flatDir {
        dirs 'libs'
    }
    maven {
        url '../flutter_aar'  // 指向Flutter AAR目录
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
}

dependencies {
    // Flutter AAR依赖
    debugImplementation 'com.kunlun.android.questionnaire:flutter_debug:1.0'
    profileImplementation 'com.kunlun.android.questionnaire:flutter_profile:1.0'
    releaseImplementation 'com.kunlun.android.questionnaire:flutter_release:1.0'
    
    // SDK和外部库依赖
    implementation(name: 'sdk-release', ext: 'aar')
    implementation files('libs/kunlun.v6.012.1617-all.jar')
    implementation(name: 'kunlun_swift.v1.101.2811', ext: 'aar')
    
    // Flutter相关依赖
    implementation 'io.flutter:flutter_embedding_debug:1.0.0-4f9d92fbbdf1391d0b9b4e3a1b5e8b5c5e5e5e5e'
}
```

### 3. 添加权限

在 `AndroidManifest.xml` 中添加必要权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 4. 初始化SDK

在您的Application类中初始化SDK：

```java
import com.kunlun.platform.android.questionnair.QuestionnairSdk;

public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        QuestionnairSdk.init(this);
    }
}
```

## 基本使用

### 启动问卷调查

```java
import com.kunlun.platform.android.questionnair.QuestionnairSdk;
import com.kunlun.platform.android.questionnair.QuestionnairActivity;

// 在Activity中启动问卷调查
public void startQuestionnaire() {
    QuestionnairSdk.Builder builder = new QuestionnairSdk.Builder()
        .setUserId("user123")
        .setQuestionnaireId("questionnaire456")
        .setServerUrl("https://your-server.com/api")
        .setLanguage("zh-CN");
    
    QuestionnairActivity.start(this, builder.build());
}
```

### 监听回调

```java
// 设置结果监听器
QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
    @Override
    public void onSuccess(String result) {
        // 问卷完成
        Log.d("Questionnaire", "Result: " + result);
    }
    
    @Override
    public void onError(String error) {
        // 发生错误
        Log.e("Questionnaire", "Error: " + error);
    }
    
    @Override
    public void onCancel() {
        // 用户取消
        Log.d("Questionnaire", "User cancelled");
    }
});
```

## 配置参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| userId | String | 是 | 用户唯一标识 |
| questionnaireId | String | 是 | 问卷ID |
| serverUrl | String | 是 | 服务器API地址 |
| language | String | 否 | 语言设置，默认zh-CN |
| theme | String | 否 | 主题设置 |
| timeout | int | 否 | 网络超时时间(秒)，默认30 |

## 注意事项

1. **最低Android版本**: API Level 21 (Android 5.0)
2. **网络权限**: 确保应用有网络访问权限
3. **混淆配置**: 如果使用代码混淆，请添加相应的keep规则
4. **内存管理**: SDK会自动管理Flutter引擎的生命周期
5. **构建内存**: 如遇到"Java heap space"错误，请参考故障排除指南

## 🔧 故障排除

### 自动诊断工具
运行诊断脚本自动检测和修复常见问题：
```bash
./diagnose.sh /path/to/your/android/project
```

该工具可以：
- 自动检测Gradle内存配置问题
- 识别重复依赖声明
- 验证AAR文件完整性
- 检查权限配置
- 自动修复常见配置问题
- 生成详细的诊断报告

### 常见问题快速修复

### Java堆内存不足错误

如果遇到以下错误：
```
Execution failed for JetifyTransform: ... Java heap space
```

**快速解决方案：**

在项目根目录的 `gradle.properties` 文件中添加：
```properties
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
org.gradle.daemon=true
android.enableJetifier=false
android.useAndroidX=true
```

### 重复类错误

#### Flutter插件重复类
如果遇到以下错误：
```
Duplicate class io.flutter.plugins.GeneratedPluginRegistrant found in modules
```

**快速解决方案：**
在 `app/build.gradle` 中修改SDK依赖：
```gradle
implementation(name: 'sdk-release', ext: 'aar') {
    exclude group: 'io.flutter', module: 'flutter_embedding_debug'
    exclude group: 'io.flutter', module: 'flutter_embedding_profile'
    exclude group: 'io.flutter', module: 'flutter_embedding_release'
}
```

#### SDK重复依赖（严重）
如果遇到以下错误：
```
Duplicate class com.kunlun.platform.android.questionnair.QuestionnairSdk found in modules
```

**快速解决方案：**
1. 检查 `app/build.gradle` 中是否重复声明了SDK依赖
2. 检查 `settings.gradle` 中是否包含了 `:sdk` 模块
3. 清理项目：
```bash
./gradlew clean
./gradlew assembleDebug
```

更多问题解决方案请查看：[故障排除指南](TROUBLESHOOTING.md)

## 混淆配置

如果您的项目启用了代码混淆，请在 `proguard-rules.pro` 中添加：

```proguard
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
```

## 技术支持

如有问题，请联系技术支持团队或查看API参考文档。

## 版本信息

- SDK版本: 1.0.0
- Flutter版本: 3.x
- 最低Android版本: API 21
- 编译Android版本: API 34