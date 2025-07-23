# 快速开始指南

本指南将帮助您在5分钟内完成问卷调查SDK的基本集成。

## 📋 前置要求

- Android Studio 4.0+
- Android项目最低SDK版本：API 21 (Android 5.0)
- 网络连接权限

## 🚀 快速集成（3步完成）

### 步骤1：自动安装（推荐）

```bash
# 在SDK目录下执行
./install.sh /path/to/your/android/project
```

### 步骤2：手动配置依赖

在您的 `app/build.gradle` 文件中添加：

```gradle
repositories {
    flatDir { dirs 'libs' }
    maven { url '../flutter_aar' }
    maven { url 'https://storage.googleapis.com/download.flutter.io' }
}

dependencies {
    // Flutter AAR
    debugImplementation 'com.kunlun.android.questionnaire:flutter_debug:1.0'
    releaseImplementation 'com.kunlun.android.questionnaire:flutter_release:1.0'
    
    // SDK
    implementation(name: 'sdk-release', ext: 'aar')
    implementation files('libs/kunlun.v6.012.1617-all.jar')
    implementation(name: 'kunlun_swift.v1.101.2811', ext: 'aar')
}
```

### 步骤3：初始化和使用

**在Application中初始化：**

```java
public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        QuestionnairSdk.init(this);
    }
}
```

**启动问卷调查：**

```java
// 配置参数
QuestionnairSdk.Builder builder = new QuestionnairSdk.Builder()
    .setUserId("user123")
    .setQuestionnaireId("questionnaire456")
    .setServerUrl("https://your-api.com");

// 启动问卷
QuestionnairActivity.start(this, builder.build());

// 监听结果
QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
    @Override
    public void onSuccess(String result) {
        // 问卷完成
    }
    
    @Override
    public void onError(String error) {
        // 处理错误
    }
    
    @Override
    public void onCancel() {
        // 用户取消
    }
});
```

## ✅ 验证集成

运行以下代码验证SDK是否正确集成：

```java
// 检查SDK是否可用
if (QuestionnairSdk.isInitialized()) {
    Log.d("SDK", "问卷调查SDK已就绪");
} else {
    Log.e("SDK", "SDK初始化失败");
}
```

## 🔧 常见问题

### 1. Java堆内存不足 (最常见)
**错误信息：** `Java heap space` 或 `JetifyTransform failed`

**解决方案：** 在项目根目录的 `gradle.properties` 中添加：
```properties
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
org.gradle.daemon=true
android.enableJetifier=false
android.useAndroidX=true
```

### 2. 重复类错误
**错误信息：** `Duplicate class io.flutter.plugins.GeneratedPluginRegistrant`

**解决方案：** 在 `app/build.gradle` 中修改SDK依赖：
```gradle
implementation(name: 'sdk-release', ext: 'aar') {
    exclude group: 'io.flutter', module: 'flutter_embedding_debug'
    exclude group: 'io.flutter', module: 'flutter_embedding_profile'
    exclude group: 'io.flutter', module: 'flutter_embedding_release'
}
```

### 3. SDK重复依赖错误（严重）
**错误信息：** `Duplicate class com.kunlun.platform.android.questionnair.QuestionnairSdk`

**解决方案：** 
1. 检查 `app/build.gradle` 和 `settings.gradle` 中的重复依赖
2. 清理项目：`./gradlew clean && ./gradlew assembleDebug`

### Q: 构建失败，提示找不到AAR文件
**A:** 确保AAR文件在 `app/libs/` 目录下，并检查build.gradle配置。

### Q: 运行时崩溃
**A:** 检查是否在Application中调用了 `QuestionnairSdk.init(this)`。

### Q: 网络请求失败
**A:** 确认AndroidManifest.xml中添加了网络权限：
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 📚 下一步

- 查看 [完整API文档](docs/API_REFERENCE.md)
- 参考 [集成示例](docs/INTEGRATION_EXAMPLE.md)
- 了解 [高级配置](docs/README.md#配置参数)

## 💬 获得帮助

- 📧 技术支持：tech-support@example.com
- 📖 完整文档：查看 `docs/` 目录
- 🐛 问题反馈：GitHub Issues

---

🎉 **恭喜！您已完成SDK的基本集成。现在可以开始创建您的第一个问卷调查了！**