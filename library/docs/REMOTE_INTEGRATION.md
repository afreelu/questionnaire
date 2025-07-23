# 远程Flutter AAR库集成指南

本文档详细说明如何在宿主Android项目中获取和集成远程的Flutter AAR库。

## 方法一：通过GitHub Releases获取（推荐）

### 1. 创建GitHub Release

首先需要在GitHub仓库中创建Release并上传AAR文件：

```bash
# 在项目根目录执行
gh release create v1.2.1 \
  --title "Questionnaire SDK v1.2.1" \
  --notes "修复Function类型错误，改进HTTP请求回调处理" \
  library/android_sdk/questionnaire_sdk-release.aar \
  library/external_libs/kunlun.v6.012.1617-all.jar \
  library/external_libs/kunlun_swift.v1.101.2811.aar
```

### 2. 宿主项目集成

在宿主项目的 `app/build.gradle` 中添加：

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    // 方式1：直接下载到libs目录
    implementation fileTree(dir: 'libs', include: ['*.jar', '*.aar'])
    
    // 方式2：通过URL直接引用（需要网络）
    implementation 'com.github.afreelu:questionnaire:v1.2.1'
}
```

### 3. 下载脚本

创建自动下载脚本 `download_aar.sh`：

```bash
#!/bin/bash

# 配置
REPO_URL="https://github.com/afreelu/questionnaire"
VERSION="v1.2.1"
LIBS_DIR="app/libs"

# 创建libs目录
mkdir -p $LIBS_DIR

# 下载AAR文件
echo "正在下载 Questionnaire SDK $VERSION..."

# 下载主要AAR文件
curl -L "$REPO_URL/releases/download/$VERSION/questionnaire_sdk-release.aar" \
     -o "$LIBS_DIR/questionnaire_sdk-release.aar"

# 下载依赖库
curl -L "$REPO_URL/releases/download/$VERSION/kunlun.v6.012.1617-all.jar" \
     -o "$LIBS_DIR/kunlun.v6.012.1617-all.jar"

curl -L "$REPO_URL/releases/download/$VERSION/kunlun_swift.v1.101.2811.aar" \
     -o "$LIBS_DIR/kunlun_swift.v1.101.2811.aar"

echo "下载完成！"
```

## 方法二：通过JitPack集成

### 1. 配置JitPack

在项目根目录的 `build.gradle` 中添加：

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### 2. 添加依赖

在 `app/build.gradle` 中添加：

```gradle
dependencies {
    implementation 'com.github.afreelu:questionnaire:v1.2.1'
}
```

## 方法三：通过Maven仓库（企业推荐）

### 1. 发布到Maven仓库

在项目中添加发布配置 `publish.gradle`：

```gradle
apply plugin: 'maven-publish'

publishing {
    publications {
        maven(MavenPublication) {
            groupId = 'com.kunlun'
            artifactId = 'questionnaire-sdk'
            version = '1.2.1'
            
            artifact('library/android_sdk/questionnaire_sdk-release.aar')
            
            pom {
                name = 'Questionnaire SDK'
                description = 'Android问卷调查SDK，基于Flutter技术开发'
                url = 'https://github.com/afreelu/questionnaire'
                
                licenses {
                    license {
                        name = 'MIT License'
                        url = 'https://opensource.org/licenses/MIT'
                    }
                }
                
                developers {
                    developer {
                        id = 'afreelu'
                        name = 'Afreelu'
                        email = 'your-email@example.com'
                    }
                }
            }
        }
    }
    
    repositories {
        maven {
            name = "GitHubPackages"
            url = "https://maven.pkg.github.com/afreelu/questionnaire"
            credentials {
                username = project.findProperty("gpr.user") ?: System.getenv("USERNAME")
                password = project.findProperty("gpr.key") ?: System.getenv("TOKEN")
            }
        }
    }
}
```

### 2. 宿主项目集成

```gradle
repositories {
    maven {
        name = "GitHubPackages"
        url = "https://maven.pkg.github.com/afreelu/questionnaire"
        credentials {
            username = project.findProperty("gpr.user") ?: System.getenv("USERNAME")
            password = project.findProperty("gpr.key") ?: System.getenv("TOKEN")
        }
    }
}

dependencies {
    implementation 'com.kunlun:questionnaire-sdk:1.2.1'
}
```

## 方法四：自动化集成脚本

创建 `integrate_remote_sdk.sh` 脚本：

```bash
#!/bin/bash

# 使用方法: ./integrate_remote_sdk.sh [项目路径] [版本号]

PROJECT_PATH=${1:-"."}
VERSION=${2:-"v1.2.1"}
REPO_URL="https://github.com/afreelu/questionnaire"

echo "正在集成 Questionnaire SDK $VERSION 到项目: $PROJECT_PATH"

# 检查项目结构
if [ ! -f "$PROJECT_PATH/app/build.gradle" ]; then
    echo "错误: 未找到Android项目结构"
    exit 1
fi

# 创建libs目录
mkdir -p "$PROJECT_PATH/app/libs"

# 下载AAR文件
echo "下载SDK文件..."
curl -L "$REPO_URL/releases/download/$VERSION/questionnaire_sdk-release.aar" \
     -o "$PROJECT_PATH/app/libs/questionnaire_sdk-release.aar"

curl -L "$REPO_URL/releases/download/$VERSION/kunlun.v6.012.1617-all.jar" \
     -o "$PROJECT_PATH/app/libs/kunlun.v6.012.1617-all.jar"

curl -L "$REPO_URL/releases/download/$VERSION/kunlun_swift.v1.101.2811.aar" \
     -o "$PROJECT_PATH/app/libs/kunlun_swift.v1.101.2811.aar"

# 检查build.gradle配置
BUILD_GRADLE="$PROJECT_PATH/app/build.gradle"

if ! grep -q "fileTree(dir: 'libs'" "$BUILD_GRADLE"; then
    echo "添加libs依赖到build.gradle..."
    sed -i '' '/dependencies {/a\
    implementation fileTree(dir: "libs", include: ["*.jar", "*.aar"])
' "$BUILD_GRADLE"
fi

# 添加必要的配置
if ! grep -q "multiDexEnabled true" "$BUILD_GRADLE"; then
    echo "添加MultiDex支持..."
    sed -i '' '/defaultConfig {/a\
        multiDexEnabled true
' "$BUILD_GRADLE"
fi

echo "集成完成！请同步项目并重新构建。"
echo "使用示例代码:"
echo "QuestionnairSdk sdk = new QuestionnairSdk();"
echo "sdk.showQuestionnaire(this, voteId, \"CN\", callback);"
```

## 版本管理

### 1. 检查最新版本

```bash
# 获取最新版本信息
curl -s https://api.github.com/repos/afreelu/questionnaire/releases/latest | grep '"tag_name"'
```

### 2. 版本兼容性

| SDK版本 | 最低Android版本 | 目标Android版本 | Flutter版本 |
|---------|----------------|----------------|-------------|
| v1.2.1  | API 21 (5.0)   | API 34 (14.0)  | 3.x         |
| v1.2.0  | API 21 (5.0)   | API 33 (13.0)  | 3.x         |

## 故障排除

### 常见问题

1. **下载失败**
   ```bash
   # 检查网络连接
   curl -I https://github.com/afreelu/questionnaire
   
   # 使用代理下载
   curl --proxy http://proxy:port -L [URL]
   ```

2. **依赖冲突**
   ```gradle
   // 排除冲突的依赖
   implementation('com.kunlun:questionnaire-sdk:1.2.1') {
       exclude group: 'com.android.support'
   }
   ```

3. **版本不匹配**
   ```bash
   # 清理并重新下载
   rm -rf app/libs/questionnaire_*
   ./download_aar.sh
   ```

## 最佳实践

1. **使用固定版本号**：避免使用 `latest` 标签
2. **本地缓存**：将AAR文件提交到项目仓库中
3. **自动化更新**：使用CI/CD自动检查和更新SDK版本
4. **依赖管理**：使用Gradle的依赖管理功能
5. **版本锁定**：在生产环境中锁定特定版本

## 示例项目

完整的集成示例可以参考：
- [基础集成示例](https://github.com/afreelu/questionnaire/tree/main/examples/basic)
- [高级集成示例](https://github.com/afreelu/questionnaire/tree/main/examples/advanced)