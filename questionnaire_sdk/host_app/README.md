# 问卷调查宿主应用

这是一个Android宿主应用，用于集成Flutter问卷调查模块的AAR包。

## 项目结构

```
host_app/
├── app/
│   ├── src/main/
│   │   ├── java/com/kunlun/android/hostapp/
│   │   │   └── MainActivity.java          # 主Activity，集成Flutter模块
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   └── activity_main.xml      # 主界面布局
│   │   │   ├── values/
│   │   │   │   ├── strings.xml            # 字符串资源
│   │   │   │   ├── colors.xml             # 颜色资源
│   │   │   │   └── themes.xml             # 主题样式
│   │   │   └── mipmap-*/                  # 应用图标
│   │   └── AndroidManifest.xml            # Android清单文件
│   ├── build.gradle                       # 应用模块构建配置
│   └── proguard-rules.pro                 # ProGuard规则
├── gradle/wrapper/
│   └── gradle-wrapper.properties          # Gradle Wrapper配置
├── build.gradle                           # 项目根构建配置
├── settings.gradle                        # 项目设置
├── gradle.properties                      # Gradle属性
├── gradlew                               # Gradle Wrapper脚本(Unix)
└── README.md                             # 项目说明文档
```

## 功能特性

- ✅ 集成Flutter问卷调查模块AAR
- ✅ 支持Debug、Profile、Release三种构建类型
- ✅ 简洁的用户界面
- ✅ 一键启动Flutter问卷调查功能

## 构建和运行

### 前置条件

1. 确保已经构建了Flutter模块的AAR文件
2. Android SDK已正确安装
3. Java 8或更高版本

### 构建步骤

1. 进入宿主应用目录：
   ```bash
   cd host_app
   ```

2. 构建项目：
   ```bash
   ./gradlew build
   ```

3. 安装到设备：
   ```bash
   ./gradlew installDebug
   ```

### 运行应用

1. 在Android设备或模拟器上启动应用
2. 点击"打开问卷调查"按钮
3. 开始使用Flutter问卷调查功能

## AAR集成说明

本项目已经配置好了Flutter AAR的集成：

- **仓库配置**：指向Flutter模块构建输出的repo目录
- **依赖配置**：包含Debug、Profile、Release三个版本的AAR
- **Flutter引擎**：在MainActivity中初始化和管理Flutter引擎

## 自定义配置

如需修改配置，请编辑以下文件：

- `app/build.gradle` - 修改依赖版本或添加新的依赖
- `app/src/main/java/com/kunlun/android/hostapp/MainActivity.java` - 修改Flutter集成逻辑
- `app/src/main/res/values/strings.xml` - 修改界面文本
- `app/src/main/res/layout/activity_main.xml` - 修改界面布局

## 注意事项

1. 确保Flutter AAR已经构建完成
2. 如果修改了Flutter模块，需要重新构建AAR
3. 支持的最低Android版本为API 21 (Android 5.0)
4. 建议在真机上测试Flutter功能的完整性