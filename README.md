# Questionnaire SDK

一个基于Flutter技术开发的Android问卷调查SDK，提供完整的问卷展示、交互和数据收集功能。

## 项目结构

```
trae_wj/
├── library/                    # SDK发布包
│   ├── android_sdk/            # Android AAR文件
│   │   └── questionnaire_sdk-release.aar
│   ├── flutter_aar/            # Flutter编译的AAR文件
│   ├── external_libs/          # 外部依赖库
│   │   ├── kunlun.v6.012.1617-all.jar
│   │   └── kunlun_swift.v1.101.2811.aar
│   ├── docs/                   # 文档
│   │   ├── README.md
│   │   ├── API_REFERENCE.md
│   │   ├── TROUBLESHOOTING.md
│   │   └── INTEGRATION_EXAMPLE.md
│   ├── install.sh              # 自动安装脚本
│   ├── diagnose.sh             # 诊断工具
│   └── VERSION_INFO.json       # 版本信息
├── questionnaire_sdk/          # Flutter源码
│   ├── lib/                    # Dart源码
│   ├── host_app/               # 测试应用
│   └── pubspec.yaml
├── codes/                      # 代码备份
└── bridge-codes/               # 桥接代码
```

## 版本信息

- **当前版本**: v1.2.1
- **发布日期**: 2024-01-16
- **构建号**: 121

## 主要功能

- ✅ 问卷展示和交互
- ✅ 多种题型支持（单选、多选、文本输入等）
- ✅ 数据收集和提交
- ✅ 网络请求处理
- ✅ 错误处理和诊断
- ✅ 自动安装和配置

## 最新更新 (v1.2.1)

### 修复内容
- 修复Function类型错误：`type 'Null' is not a subtype of type 'Function'`
- 改进HTTP请求回调函数的空值检查
- 优化getVoteByRequest方法的缓存逻辑
- 修复页面缓存时空字符串解析错误

### 新增功能
- 增强诊断工具，支持检测回调接口实现
- 更新故障排除文档，新增Function类型错误解决方案

## 快速开始

### 方法一：远程安装（推荐）

1. **直接从GitHub安装**
   ```bash
   curl -L https://github.com/afreelu/questionnaire/raw/main/library/remote_install.sh | bash -s /path/to/your/android/project
   ```

2. **或下载脚本后安装**
   ```bash
   wget https://github.com/afreelu/questionnaire/raw/main/library/remote_install.sh
   chmod +x remote_install.sh
   ./remote_install.sh /path/to/your/android/project v1.2.1
   ```

### 方法二：Gradle集成

在 `app/build.gradle` 中添加：
```gradle
apply from: 'https://github.com/afreelu/questionnaire/raw/main/library/gradle_integration.gradle'
```

### 方法三：本地安装

1. **下载SDK**
   ```bash
   git clone https://github.com/afreelu/questionnaire.git
   cd questionnaire/library
   ```

2. **自动安装**
   ```bash
   ./install.sh /path/to/your/android/project
   ```

3. **运行诊断**
   ```bash
   ./diagnose.sh /path/to/your/android/project
   ```

## 集成示例

```java
// 初始化SDK
QuestionnairSdk questionnairSdk = new QuestionnairSdk();

// 显示问卷
questionnairSdk.showQuestionnaire(this, voteId, "CN", new QuestionnairSdk.QuestionnairListioner() {
    @Override
    public void onComplete(int retCode, String retMsg) {
        Log.d(TAG, "问卷完成: " + retCode + ", " + retMsg);
    }
});
```

## 文档

- [API参考文档](library/docs/API_REFERENCE.md)
- [集成示例](library/docs/INTEGRATION_EXAMPLE.md)
- [故障排除指南](library/docs/TROUBLESHOOTING.md)
- [快速开始指南](library/QUICK_START.md)

## 支持

如果遇到问题，请：
1. 查看[故障排除指南](library/docs/TROUBLESHOOTING.md)
2. 运行诊断工具：`./diagnose.sh`
3. 提交Issue到GitHub仓库

## 许可证

详见 [LICENSE.txt](library/LICENSE.txt)