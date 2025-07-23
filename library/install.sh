#!/bin/bash

# 问卷调查SDK安装脚本
# 使用方法: ./install.sh <target_project_path>

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
if [ $# -eq 0 ]; then
    print_error "请提供目标项目路径"
    echo "使用方法: $0 <target_project_path>"
    echo "示例: $0 /path/to/your/android/project"
    exit 1
fi

TARGET_PROJECT="$1"
SDK_DIR="$(cd "$(dirname "$0")" && pwd)"

# 检查目标项目是否存在
if [ ! -d "$TARGET_PROJECT" ]; then
    print_error "目标项目路径不存在: $TARGET_PROJECT"
    exit 1
fi

# 检查是否为Android项目
if [ ! -f "$TARGET_PROJECT/build.gradle" ] && [ ! -f "$TARGET_PROJECT/build.gradle.kts" ]; then
    print_error "目标路径不是有效的Android项目（未找到build.gradle文件）"
    exit 1
fi

print_info "开始安装问卷调查SDK..."
print_info "SDK路径: $SDK_DIR"
print_info "目标项目: $TARGET_PROJECT"

# 创建必要的目录
print_info "创建必要的目录..."
mkdir -p "$TARGET_PROJECT/app/libs"
mkdir -p "$TARGET_PROJECT/flutter_aar"

# 复制AAR和JAR文件
print_info "复制SDK文件..."
cp "$SDK_DIR/android_sdk/sdk-release.aar" "$TARGET_PROJECT/app/libs/"
cp "$SDK_DIR/external_libs/kunlun.v6.012.1617-all.jar" "$TARGET_PROJECT/app/libs/"
cp "$SDK_DIR/external_libs/kunlun_swift.v1.101.2811.aar" "$TARGET_PROJECT/app/libs/"

# 复制Flutter AAR
print_info "复制Flutter AAR文件..."
cp -r "$SDK_DIR/flutter_aar/"* "$TARGET_PROJECT/flutter_aar/"

# 复制文档
print_info "复制文档文件..."
mkdir -p "$TARGET_PROJECT/sdk_docs"
cp -r "$SDK_DIR/docs/"* "$TARGET_PROJECT/sdk_docs/"
cp "$SDK_DIR/VERSION_INFO.json" "$TARGET_PROJECT/sdk_docs/"

# 复制诊断工具
print_info "复制诊断工具..."
cp "$SDK_DIR/diagnose.sh" "$TARGET_PROJECT/"
chmod +x "$TARGET_PROJECT/diagnose.sh"
print_success "诊断工具复制完成"

# 配置gradle.properties（重要：解决内存问题）
setup_gradle_properties

# 配置gradle.properties
setup_gradle_properties() {
    local gradle_properties="$TARGET_PROJECT/gradle.properties"
    
    print_info "配置gradle.properties..."
    
    if [ ! -f "$gradle_properties" ]; then
        print_info "创建gradle.properties文件"
        cat > "$gradle_properties" << EOF
# Gradle配置 - 解决内存问题
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
org.gradle.daemon=true
org.gradle.parallel=true
android.useAndroidX=true
android.enableJetifier=false
android.enableBuildCache=true
EOF
        print_success "已创建基本gradle.properties配置"
    else
        print_info "检查现有gradle.properties配置"
        
        # 检查关键配置
        local needs_update=false
        
        if ! grep -q "org.gradle.jvmargs.*-Xmx" "$gradle_properties"; then
            print_warning "缺少JVM内存配置，添加中..."
            echo "org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m" >> "$gradle_properties"
            needs_update=true
        fi
        
        if ! grep -q "android.enableJetifier=false" "$gradle_properties"; then
            print_warning "建议禁用Jetifier以减少内存使用"
            echo "android.enableJetifier=false" >> "$gradle_properties"
            needs_update=true
        fi
        
        if ! grep -q "android.useAndroidX=true" "$gradle_properties"; then
            print_warning "添加AndroidX配置"
            echo "android.useAndroidX=true" >> "$gradle_properties"
            needs_update=true
        fi
        
        if [ "$needs_update" = true ]; then
            print_success "已更新gradle.properties配置"
        else
            print_success "gradle.properties配置正常"
        fi
    fi
}

# 检查app/build.gradle文件
APP_BUILD_GRADLE="$TARGET_PROJECT/app/build.gradle"
if [ ! -f "$APP_BUILD_GRADLE" ]; then
    APP_BUILD_GRADLE="$TARGET_PROJECT/app/build.gradle.kts"
fi

if [ ! -f "$APP_BUILD_GRADLE" ]; then
    print_warning "未找到app/build.gradle文件，请手动配置依赖"
else
    print_info "检查build.gradle配置..."
    
    # 检查是否已经配置了SDK依赖
    if grep -q "sdk-release" "$APP_BUILD_GRADLE"; then
        print_warning "检测到已存在SDK配置，请手动检查是否需要更新"
    else
        print_info "需要手动添加以下配置到 $APP_BUILD_GRADLE:"
        echo ""
        echo "repositories {"
        echo "    flatDir {"
        echo "        dirs 'libs'"
        echo "    }"
        echo "    maven {"
        echo "        url '../flutter_aar'"
        echo "    }"
        echo "    maven {"
        echo "        url 'https://storage.googleapis.com/download.flutter.io'"
        echo "    }"
        echo "}"
        echo ""
        echo "dependencies {"
        echo "    // Flutter AAR依赖"
        echo "    debugImplementation 'com.kunlun.android.questionnaire:flutter_debug:1.0'"
        echo "    profileImplementation 'com.kunlun.android.questionnaire:flutter_profile:1.0'"
        echo "    releaseImplementation 'com.kunlun.android.questionnaire:flutter_release:1.0'"
        echo "    "
        echo "    // SDK和外部库依赖（排除重复类以避免冲突）"
        echo "    implementation(name: 'sdk-release', ext: 'aar') {"
        echo "        exclude group: 'io.flutter', module: 'flutter_embedding_debug'"
        echo "        exclude group: 'io.flutter', module: 'flutter_embedding_profile'"
        echo "        exclude group: 'io.flutter', module: 'flutter_embedding_release'"
        echo "    }"
        echo "    implementation files('libs/kunlun.v6.012.1617-all.jar')"
        echo "    implementation(name: 'kunlun_swift.v1.101.2811', ext: 'aar')"
        echo "}"
        echo ""
    fi
fi

# 检查AndroidManifest.xml
MANIFEST_FILE="$TARGET_PROJECT/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST_FILE" ]; then
    print_info "检查AndroidManifest.xml权限..."
    
    if ! grep -q "android.permission.INTERNET" "$MANIFEST_FILE"; then
        print_warning "请添加网络权限到AndroidManifest.xml:"
        echo "<uses-permission android:name=\"android.permission.INTERNET\" />"
        echo "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />"
    else
        print_success "网络权限已存在"
    fi
else
    print_warning "未找到AndroidManifest.xml文件"
fi

# 生成安装报告
REPORT_FILE="$TARGET_PROJECT/sdk_installation_report.txt"
print_info "生成安装报告: $REPORT_FILE"

cat > "$REPORT_FILE" << EOF
问卷调查SDK安装报告
==================

安装时间: $(date)
SDK版本: 1.0.0
目标项目: $TARGET_PROJECT

已复制的文件:
- app/libs/sdk-release.aar
- app/libs/kunlun.v6.012.1617-all.jar
- app/libs/kunlun_swift.v1.101.2811.aar
- flutter_aar/ (Flutter AAR文件)
- sdk_docs/ (文档文件)

已自动配置:
- gradle.properties (JVM内存配置，解决"Java heap space"错误)
- AndroidX和Jetifier设置
- Gradle性能优化配置

下一步操作:
1. 检查并更新app/build.gradle文件，添加必要的依赖配置
2. 确认AndroidManifest.xml中包含网络权限
3. 在Application类中初始化SDK: QuestionnairSdk.init(this)
4. 参考sdk_docs/目录中的文档进行集成

⚠️ 重要提示:
- 如果遇到"Java heap space"错误，请检查gradle.properties文件中的内存配置
- 如果遇到"Duplicate class"错误，请使用exclude配置排除重复的Flutter类
- 建议使用提供的配置示例以避免常见的依赖冲突问题

重要文档:
- sdk_docs/README.md - 基本集成指南
- sdk_docs/API_REFERENCE.md - API参考文档
- sdk_docs/INTEGRATION_EXAMPLE.md - 完整集成示例
- sdk_docs/CHANGELOG.md - 版本更新日志

技术支持:
如有问题，请查看文档或联系技术支持团队。
EOF

print_success "SDK文件复制完成！"
print_info "请查看安装报告: $REPORT_FILE"
print_info "接下来请按照sdk_docs/README.md中的说明完成集成配置"

echo ""
print_success "安装完成！请按照以下步骤继续:"
echo "1. 查看安装报告: $REPORT_FILE"
echo "2. 阅读集成文档: $TARGET_PROJECT/sdk_docs/README.md"
echo "3. 参考示例代码: $TARGET_PROJECT/sdk_docs/INTEGRATION_EXAMPLE.md"
echo "4. 配置build.gradle和AndroidManifest.xml"
echo "5. 在Application中初始化SDK"
echo ""
echo "🔧 故障诊断:"
echo "  如遇到问题，可运行诊断工具进行自动检测和修复"
echo "  诊断工具位置: $TARGET_PROJECT/diagnose.sh"

echo ""
print_info "祝您使用愉快！"