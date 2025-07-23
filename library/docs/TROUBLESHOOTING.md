# 故障排除指南

本文档提供了集成问卷调查SDK时可能遇到的常见问题及其解决方案。

## 🔥 常见错误及解决方案

### 1. Java堆内存不足错误

**错误信息：**
```
Execution failed for JetifyTransform: ... Java heap space
```

**原因分析：**
- Gradle在处理Flutter AAR文件时需要大量内存
- 默认的JVM堆内存设置可能不足
- Jetify转换过程消耗大量内存

**解决方案：**

#### 方案1：增加Gradle JVM内存（推荐）

在项目根目录的 `gradle.properties` 文件中添加或修改：

```properties
# 增加JVM堆内存
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError

# 启用Gradle守护进程
org.gradle.daemon=true

# 启用并行构建
org.gradle.parallel=true

# 启用配置缓存
org.gradle.configureondemand=true

# 禁用Jetify（如果不需要AndroidX转换）
android.enableJetifier=false
android.useAndroidX=true
```

#### 方案2：优化build.gradle配置

在 `app/build.gradle` 中添加：

```gradle
android {
    // 启用DEX增量编译
    dexOptions {
        javaMaxHeapSize "4g"
        preDexLibraries true
        incremental true
    }
    
    // 优化编译选项
    compileOptions {
        incremental true
    }
    
    // 如果使用R8/ProGuard
    buildTypes {
        debug {
            minifyEnabled false
            // 禁用调试版本的代码压缩以节省内存
        }
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 方案3：分步构建

如果内存仍然不足，可以尝试分步构建：

```bash
# 清理项目
./gradlew clean

# 只构建debug版本
./gradlew assembleDebug

# 或者使用更多内存的命令
./gradlew assembleDebug -Xmx6g
```

### 2. Flutter AAR依赖解析失败

**错误信息：**
```
Could not find com.kunlun.android.questionnaire:flutter_debug:1.0
```

**解决方案：**

1. **检查Flutter AAR路径：**
```gradle
repositories {
    maven {
        url '../flutter_aar'  // 确保路径正确
    }
    // 或使用绝对路径
    maven {
        url '/absolute/path/to/flutter_aar'
    }
}
```

2. **验证Flutter AAR文件存在：**
```bash
# 检查文件是否存在
ls -la flutter_aar/com/kunlun/android/questionnaire/flutter_debug/1.0/
```

3. **重新生成Flutter AAR：**
```bash
cd questionnaire_sdk
flutter clean
flutter build aar
```

### 3. SDK初始化失败

**错误信息：**
```
java.lang.RuntimeException: SDK not initialized
```

**解决方案：**

1. **确保在Application中初始化：**
```java
public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        try {
            QuestionnairSdk.init(this);
            Log.d("SDK", "初始化成功");
        } catch (Exception e) {
            Log.e("SDK", "初始化失败", e);
        }
    }
}
```

2. **在AndroidManifest.xml中注册Application：**
```xml
<application
    android:name=".MyApplication"
    ...>
```

### 4. Function类型错误

**错误信息：**
```
type 'Null' is not a subtype of type 'Function'
```

**问题描述：** 这个错误通常发生在HTTP请求回调函数为null或者异步操作中回调函数丢失的情况下。

**解决方案：**
1. **检查回调函数传递**：确保在调用SDK方法时正确传递了回调函数
2. **更新SDK版本**：使用最新版本的SDK，已修复了回调函数空值检查问题
3. **重新初始化SDK**：如果问题持续存在，尝试重新初始化SDK

**代码示例：**
```java
// 正确的调用方式
questionnairSdk.showQuestionnaire(this, voteId, "CN", new QuestionnairSdk.QuestionnairListioner() {
    @Override
    public void onComplete(int i, String s) {
        Log.d(TAG, "完成问卷: " + i + ", " + s);
    }
});
```

**预防措施：**
- 确保回调函数不为null
- 在Activity销毁前正确处理SDK生命周期
- 避免在异步操作中使用已销毁的Context

### 5. 网络权限问题

**错误信息：**
```
java.net.UnknownHostException
java.security.SecurityException: Permission denied
```

**解决方案：**

在 `AndroidManifest.xml` 中添加权限：
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

### 5. 混淆配置问题

**错误信息：**
```
java.lang.ClassNotFoundException
java.lang.NoSuchMethodException
```

**解决方案：**

在 `proguard-rules.pro` 中添加：
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

# 保持反射调用的类和方法
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# 保持Gson序列化相关
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
```

### 6. 版本兼容性问题

**错误信息：**
```
Android resource compilation failed
Unsupported method: BaseConfig.getApplicationIdSuffix()
```

**解决方案：**

1. **更新Gradle版本：**
```gradle
// 在项目级build.gradle中
classpath 'com.android.tools.build:gradle:7.4.2'
```

2. **更新Gradle Wrapper：**
```bash
./gradlew wrapper --gradle-version 7.6
```

3. **检查compileSdk版本：**
```gradle
android {
    compileSdk 34
    targetSdk 34
}
```

### 7. 重复类错误（Duplicate class）

#### 7.1 Flutter插件重复类错误

**错误信息：**
```
Duplicate class io.flutter.plugins.GeneratedPluginRegistrant found in modules
flutter_debug-1.0.aar and questionnaire_sdk-release.aar
```

**原因分析：**
- Flutter AAR和SDK AAR中包含了相同的类
- 通常是Flutter插件注册类冲突
- 构建系统无法确定使用哪个版本

**解决方案：**

在 `app/build.gradle` 中排除SDK AAR中的重复类：

```gradle
dependencies {
    // Flutter AAR依赖（保持不变）
    debugImplementation 'com.kunlun.android.questionnaire:flutter_debug:1.0'
    profileImplementation 'com.kunlun.android.questionnaire:flutter_profile:1.0'
    releaseImplementation 'com.kunlun.android.questionnaire:flutter_release:1.0'
    
    // SDK依赖，排除重复的Flutter相关类
    implementation(name: 'sdk-release', ext: 'aar') {
        exclude group: 'io.flutter', module: 'flutter_embedding_debug'
        exclude group: 'io.flutter', module: 'flutter_embedding_profile'
        exclude group: 'io.flutter', module: 'flutter_embedding_release'
    }
    
    // 外部库依赖
    implementation files('libs/kunlun.v6.012.1617-all.jar')
    implementation(name: 'kunlun_swift.v1.101.2811', ext: 'aar')
}
```

#### 7.2 SDK重复依赖错误（严重）

**错误信息：**
```
Duplicate class com.kunlun.platform.android.questionnair.QuestionnairSdk found in modules
questionnaire_sdk-release.aar -> jetified-questionnaire_sdk-release-runtime (:questionnaire_sdk-release:) 
and questionnaire_sdk-release.aar -> jetified-questionnaire_sdk-release-runtime (questionnaire_sdk-release.aar)
```

**原因分析：**
- 同一个SDK AAR被重复引入
- 可能同时使用了项目依赖和文件依赖
- 或者在不同的配置块中重复声明了依赖

**解决方案：**

##### 方案1：检查并清理重复依赖（推荐）

1. **检查app/build.gradle中的依赖声明：**
```gradle
dependencies {
    // ❌ 错误：重复声明SDK依赖
    implementation project(':sdk')  // 项目依赖
    implementation(name: 'sdk-release', ext: 'aar')  // 文件依赖
    
    // ✅ 正确：只使用一种方式
    implementation(name: 'sdk-release', ext: 'aar')  // 推荐使用文件依赖
}
```

2. **检查settings.gradle中的模块声明：**
```gradle
// 如果使用文件依赖，不要在settings.gradle中包含SDK模块
// include ':app'
// include ':sdk'  // ❌ 删除这行
```

3. **清理项目并重新构建：**
```bash
./gradlew clean
./gradlew assembleDebug
```

##### 方案2：使用依赖解析策略

在app/build.gradle中添加：
```gradle
configurations.all {
    resolutionStrategy {
        // 强制使用特定版本，解决冲突
        force 'com.kunlun.platform.android.questionnair:questionnaire_sdk:1.0'
        
        // 或者排除重复的模块
        exclude group: 'com.kunlun.platform.android.questionnair', module: 'questionnaire_sdk'
    }
}
```

##### 方案3：检查Gradle缓存

有时Gradle缓存会导致重复依赖问题：
```bash
# 清理Gradle缓存
./gradlew clean
rm -rf ~/.gradle/caches/
./gradlew assembleDebug
```

#### 7.3 通用解决方案

**使用configurations排除：**
```gradle
configurations {
    all {
        exclude group: 'io.flutter.plugins', module: 'GeneratedPluginRegistrant'
    }
}
```

**重新打包SDK（开发者选项）：**
```gradle
// 在SDK模块的build.gradle中
android {
    packagingOptions {
        exclude '**/GeneratedPluginRegistrant.class'
        exclude '**/io/flutter/plugins/**'
    }
}
```

### 8. 多DEX问题

**错误信息：**
```
com.android.dex.DexException: Multiple dex files define
```

**解决方案：**

1. **启用MultiDex：**
```gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

2. **在Application中配置：**
```java
public class MyApplication extends MultiDexApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        QuestionnairSdk.init(this);
    }
}
```

## 🔧 性能优化建议

### 1. 构建性能优化

```properties
# gradle.properties
org.gradle.jvmargs=-Xmx6g -XX:MaxMetaspaceSize=1g -XX:+UseG1GC
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
android.enableBuildCache=true
```

### 2. 依赖优化

```gradle
// 只在需要的构建类型中包含Flutter依赖
configurations {
    debugImplementation {
        exclude group: 'com.kunlun.android.questionnaire', module: 'flutter_profile'
        exclude group: 'com.kunlun.android.questionnaire', module: 'flutter_release'
    }
}
```

### 3. 内存使用优化

```gradle
android {
    dexOptions {
        javaMaxHeapSize "4g"
        preDexLibraries true
        incremental true
        jumboMode true
    }
}
```

## 📊 诊断工具

### 1. 内存使用监控

```bash
# 监控Gradle守护进程内存使用
./gradlew --status

# 生成构建扫描报告
./gradlew build --scan
```

### 2. 依赖分析

```bash
# 查看依赖树
./gradlew app:dependencies

# 查看冲突的依赖
./gradlew app:dependencyInsight --dependency flutter
```

### 3. 构建分析

```bash
# 详细构建日志
./gradlew assembleDebug --info

# 调试模式
./gradlew assembleDebug --debug
```

## 🆘 获取帮助

如果以上解决方案都无法解决您的问题，请提供以下信息：

1. **完整的错误日志**
2. **项目的build.gradle文件**
3. **gradle.properties文件内容**
4. **Android Studio版本**
5. **Gradle版本**
6. **设备/模拟器信息**

**联系方式：**
- 📧 技术支持：tech-support@example.com
- 🐛 问题反馈：GitHub Issues
- 📞 紧急支持：+86-xxx-xxxx-xxxx

## 📝 常用命令速查

```bash
# 清理项目
./gradlew clean

# 构建debug版本
./gradlew assembleDebug

# 增加内存构建
./gradlew assembleDebug -Xmx6g

# 查看Gradle版本
./gradlew --version

# 停止Gradle守护进程
./gradlew --stop

# 刷新依赖
./gradlew --refresh-dependencies
```