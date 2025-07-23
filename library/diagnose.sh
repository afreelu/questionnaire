#!/bin/bash

# SDK诊断脚本
# 用于检测和修复常见的SDK集成问题

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <Android项目路径>"
    echo "示例: $0 /path/to/your/android/project"
    exit 1
fi

TARGET_PROJECT="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

print_header "SDK集成诊断报告"
print_info "项目路径: $TARGET_PROJECT"
print_info "诊断时间: $(date)"
echo ""

# 诊断结果统计
ISSUES_FOUND=0
ISSUES_FIXED=0

# 1. 检查gradle.properties配置
print_header "1. 检查Gradle内存配置"
GRADLE_PROPERTIES="$TARGET_PROJECT/gradle.properties"

if [ ! -f "$GRADLE_PROPERTIES" ]; then
    print_warning "未找到gradle.properties文件"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    print_success "找到gradle.properties文件"
    
    # 检查JVM内存配置
    if ! grep -q "org.gradle.jvmargs.*-Xmx" "$GRADLE_PROPERTIES"; then
        print_warning "缺少JVM内存配置"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        print_success "JVM内存配置正常"
    fi
    
    # 检查Jetifier配置
    if grep -q "android.enableJetifier=true" "$GRADLE_PROPERTIES"; then
        print_warning "建议禁用Jetifier以减少内存使用"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        print_success "Jetifier配置正常"
    fi
fi

echo ""

# 2. 检查重复依赖
print_header "2. 检查重复依赖问题"
APP_BUILD_GRADLE="$TARGET_PROJECT/app/build.gradle"
SETTINGS_GRADLE="$TARGET_PROJECT/settings.gradle"

if [ ! -f "$APP_BUILD_GRADLE" ]; then
    APP_BUILD_GRADLE="$TARGET_PROJECT/app/build.gradle.kts"
fi

if [ ! -f "$APP_BUILD_GRADLE" ]; then
    print_error "未找到app/build.gradle文件"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    print_success "找到app/build.gradle文件"
    
    # 检查SDK依赖声明
    SDK_PROJECT_DEP=$(grep -c "implementation project.*sdk" "$APP_BUILD_GRADLE" 2>/dev/null || echo "0")
    SDK_FILE_DEP=$(grep -c "implementation.*sdk-release" "$APP_BUILD_GRADLE" 2>/dev/null || echo "0")
    
    print_info "项目依赖声明: $SDK_PROJECT_DEP 个"
    print_info "文件依赖声明: $SDK_FILE_DEP 个"
    
    if [ $((SDK_PROJECT_DEP + SDK_FILE_DEP)) -gt 1 ]; then
        print_warning "检测到重复的SDK依赖声明"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
        
        # 显示具体的重复依赖
        echo "重复的依赖声明:"
        grep -n "implementation.*sdk" "$APP_BUILD_GRADLE" 2>/dev/null || true
    else
        print_success "SDK依赖声明正常"
    fi
fi

# 检查settings.gradle
if [ -f "$SETTINGS_GRADLE" ]; then
    if grep -q "include.*:sdk" "$SETTINGS_GRADLE"; then
        if [ $SDK_FILE_DEP -gt 0 ]; then
            print_warning "使用文件依赖时不应在settings.gradle中包含SDK模块"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        else
            print_success "settings.gradle配置正常"
        fi
    else
        print_success "settings.gradle中未包含SDK模块"
    fi
else
    print_warning "未找到settings.gradle文件"
fi

echo ""

# 3. 检查AAR文件
print_header "3. 检查AAR文件"
LIBS_DIR="$TARGET_PROJECT/app/libs"
FLUTTER_AAR_DIR="$TARGET_PROJECT/flutter_aar"

if [ ! -d "$LIBS_DIR" ]; then
    print_warning "未找到app/libs目录"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    # 检查SDK AAR
    if [ -f "$LIBS_DIR/sdk-release.aar" ]; then
        print_success "找到SDK AAR文件"
    else
        print_warning "未找到sdk-release.aar文件"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
    
    # 检查外部库
    if [ -f "$LIBS_DIR/kunlun.v6.012.1617-all.jar" ]; then
        print_success "找到Kunlun JAR文件"
    else
        print_warning "未找到kunlun.v6.012.1617-all.jar文件"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
    
    if [ -f "$LIBS_DIR/kunlun_swift.v1.101.2811.aar" ]; then
        print_success "找到Kunlun Swift AAR文件"
    else
        print_warning "未找到kunlun_swift.v1.101.2811.aar文件"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
fi

# 检查Flutter AAR
if [ ! -d "$FLUTTER_AAR_DIR" ]; then
    print_warning "未找到flutter_aar目录"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    if [ -d "$FLUTTER_AAR_DIR/com/kunlun/android/questionnaire" ]; then
        print_success "找到Flutter AAR文件"
    else
        print_warning "Flutter AAR目录结构不正确"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
fi

echo ""

# 4. 检查权限配置
print_header "4. 检查权限配置"
MANIFEST_FILE="$TARGET_PROJECT/app/src/main/AndroidManifest.xml"

if [ ! -f "$MANIFEST_FILE" ]; then
    print_warning "未找到AndroidManifest.xml文件"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    if grep -q "android.permission.INTERNET" "$MANIFEST_FILE"; then
        print_success "网络权限配置正常"
    else
        print_warning "缺少网络权限配置"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
fi

echo ""

# 5. 自动修复选项
print_header "5. 自动修复建议"

if [ $ISSUES_FOUND -eq 0 ]; then
    print_success "未发现配置问题！"
else
    print_warning "发现 $ISSUES_FOUND 个潜在问题"
    echo ""
    print_info "是否尝试自动修复？(y/n)"
    read -r AUTO_FIX
    
    if [ "$AUTO_FIX" = "y" ] || [ "$AUTO_FIX" = "Y" ]; then
        print_info "开始自动修复..."
        
        # 修复gradle.properties
        if [ ! -f "$GRADLE_PROPERTIES" ] || ! grep -q "org.gradle.jvmargs.*-Xmx" "$GRADLE_PROPERTIES"; then
            print_info "修复gradle.properties配置"
            if [ ! -f "$GRADLE_PROPERTIES" ]; then
                touch "$GRADLE_PROPERTIES"
            fi
            
            # 添加内存配置
            if ! grep -q "org.gradle.jvmargs" "$GRADLE_PROPERTIES"; then
                echo "org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m" >> "$GRADLE_PROPERTIES"
            fi
            
            # 添加其他优化配置
            if ! grep -q "org.gradle.daemon" "$GRADLE_PROPERTIES"; then
                echo "org.gradle.daemon=true" >> "$GRADLE_PROPERTIES"
            fi
            
            if ! grep -q "android.useAndroidX" "$GRADLE_PROPERTIES"; then
                echo "android.useAndroidX=true" >> "$GRADLE_PROPERTIES"
            fi
            
            if ! grep -q "android.enableJetifier=false" "$GRADLE_PROPERTIES"; then
                echo "android.enableJetifier=false" >> "$GRADLE_PROPERTIES"
            fi
            
            print_success "gradle.properties配置已修复"
            ISSUES_FIXED=$((ISSUES_FIXED + 1))
        fi
        
        # 清理Gradle缓存
        print_info "清理Gradle缓存"
        cd "$TARGET_PROJECT"
        if [ -f "./gradlew" ]; then
            ./gradlew clean > /dev/null 2>&1 || true
            print_success "Gradle缓存已清理"
            ISSUES_FIXED=$((ISSUES_FIXED + 1))
        fi
        
        echo ""
        print_success "自动修复完成！修复了 $ISSUES_FIXED 个问题"
    fi
fi

echo ""

# 6. 检查常见运行时错误
print_header "6. 检查常见运行时错误"

# 检查是否有Function类型错误的修复
if [ -f "$TARGET_PROJECT/app/src/main/java"* ]; then
    JAVA_FILES=$(find "$TARGET_PROJECT/app/src/main/java" -name "*.java" 2>/dev/null || echo "")
    if [ -n "$JAVA_FILES" ]; then
        # 检查是否正确实现了回调接口
        CALLBACK_IMPL=$(grep -r "QuestionnairListioner" "$TARGET_PROJECT/app/src/main/java" 2>/dev/null | wc -l || echo "0")
        if [ "$CALLBACK_IMPL" -gt 0 ]; then
            print_success "找到回调接口实现"
        else
            print_warning "未找到回调接口实现，可能导致Function类型错误"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    fi
fi

echo ""

# 7. 生成诊断报告
print_header "7. 诊断报告"
REPORT_FILE="$TARGET_PROJECT/sdk_diagnostic_report.txt"

cat > "$REPORT_FILE" << EOF
SDK集成诊断报告
===============

诊断时间: $(date)
项目路径: $TARGET_PROJECT
发现问题: $ISSUES_FOUND 个
已修复问题: $ISSUES_FIXED 个

详细信息:
---------

1. Gradle配置检查:
$([ -f "$GRADLE_PROPERTIES" ] && echo "   ✅ gradle.properties存在" || echo "   ❌ gradle.properties缺失")
$([ -f "$GRADLE_PROPERTIES" ] && grep -q "org.gradle.jvmargs.*-Xmx" "$GRADLE_PROPERTIES" && echo "   ✅ JVM内存配置正常" || echo "   ❌ JVM内存配置缺失")

2. 依赖检查:
$([ -f "$APP_BUILD_GRADLE" ] && echo "   ✅ app/build.gradle存在" || echo "   ❌ app/build.gradle缺失")
$([ -f "$LIBS_DIR/sdk-release.aar" ] && echo "   ✅ SDK AAR文件存在" || echo "   ❌ SDK AAR文件缺失")
$([ -d "$FLUTTER_AAR_DIR" ] && echo "   ✅ Flutter AAR目录存在" || echo "   ❌ Flutter AAR目录缺失")

3. 权限检查:
$([ -f "$MANIFEST_FILE" ] && grep -q "android.permission.INTERNET" "$MANIFEST_FILE" && echo "   ✅ 网络权限配置正常" || echo "   ❌ 网络权限配置缺失")

建议操作:
---------
$([ $ISSUES_FOUND -gt 0 ] && echo "1. 查看详细的故障排除指南: docs/TROUBLESHOOTING.md" || echo "配置正常，无需额外操作")
$([ $ISSUES_FOUND -gt 0 ] && echo "2. 运行清理命令: ./gradlew clean && ./gradlew assembleDebug")
$([ $ISSUES_FOUND -gt 0 ] && echo "3. 如仍有问题，请联系技术支持")

EOF

print_success "诊断报告已生成: $REPORT_FILE"

echo ""
print_header "诊断完成"
if [ $ISSUES_FOUND -eq 0 ]; then
    print_success "🎉 恭喜！您的SDK集成配置正常"
else
    if [ $ISSUES_FIXED -gt 0 ]; then
        print_success "✨ 已自动修复 $ISSUES_FIXED 个问题"
        if [ $((ISSUES_FOUND - ISSUES_FIXED)) -gt 0 ]; then
            print_warning "还有 $((ISSUES_FOUND - ISSUES_FIXED)) 个问题需要手动处理"
            print_info "请查看故障排除指南: docs/TROUBLESHOOTING.md"
        fi
    else
        print_warning "发现 $ISSUES_FOUND 个问题需要处理"
        print_info "请查看故障排除指南: docs/TROUBLESHOOTING.md"
    fi
fi

echo ""
print_info "💡 提示: 运行 './gradlew clean && ./gradlew assembleDebug' 来测试构建"
print_info "📚 更多帮助: docs/README.md"