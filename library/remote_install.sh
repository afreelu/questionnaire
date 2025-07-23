#!/bin/bash

# Questionnaire SDK 远程安装脚本
# 用法: ./remote_install.sh [目标项目路径] [版本号]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# 配置
REPO_URL="https://github.com/afreelu/questionnaire"
API_URL="https://api.github.com/repos/afreelu/questionnaire"
DEFAULT_VERSION="v1.2.1"

# 参数解析
TARGET_PROJECT="${1:-.}"
VERSION="${2:-$DEFAULT_VERSION}"

# 检查参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Questionnaire SDK 远程安装脚本"
    echo ""
    echo "用法: $0 [目标项目路径] [版本号]"
    echo ""
    echo "参数:"
    echo "  目标项目路径    Android项目根目录路径 (默认: 当前目录)"
    echo "  版本号         SDK版本号 (默认: $DEFAULT_VERSION)"
    echo ""
    echo "示例:"
    echo "  $0 /path/to/android/project v1.2.1"
    echo "  $0 . latest  # 使用最新版本"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -l, --list     列出所有可用版本"
    echo "  -c, --check    检查最新版本"
    exit 0
fi

if [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
    print_header "获取可用版本列表"
    curl -s "$API_URL/releases" | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/' | head -10
    exit 0
fi

if [ "$1" = "-c" ] || [ "$1" = "--check" ]; then
    print_header "检查最新版本"
    LATEST=$(curl -s "$API_URL/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
    echo "最新版本: $LATEST"
    exit 0
fi

# 获取最新版本
if [ "$VERSION" = "latest" ]; then
    print_header "获取最新版本信息"
    VERSION=$(curl -s "$API_URL/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
    if [ -z "$VERSION" ]; then
        print_error "无法获取最新版本信息"
        exit 1
    fi
    print_success "最新版本: $VERSION"
fi

print_header "Questionnaire SDK 远程安装"
echo "目标项目: $TARGET_PROJECT"
echo "SDK版本: $VERSION"
echo "仓库地址: $REPO_URL"
echo ""

# 检查目标项目
if [ ! -d "$TARGET_PROJECT" ]; then
    print_error "目标目录不存在: $TARGET_PROJECT"
    exit 1
fi

if [ ! -f "$TARGET_PROJECT/app/build.gradle" ] && [ ! -f "$TARGET_PROJECT/build.gradle" ]; then
    print_error "目标目录不是有效的Android项目"
    exit 1
fi

# 创建必要目录
LIBS_DIR="$TARGET_PROJECT/app/libs"
mkdir -p "$LIBS_DIR"
print_success "创建libs目录: $LIBS_DIR"

# 检查网络连接
print_header "检查网络连接"
if ! curl -s --head "$REPO_URL" > /dev/null; then
    print_error "无法连接到GitHub，请检查网络连接"
    exit 1
fi
print_success "网络连接正常"

# 下载文件函数
download_file() {
    local filename="$1"
    local url="$REPO_URL/releases/download/$VERSION/$filename"
    local output="$LIBS_DIR/$filename"
    
    echo -n "下载 $filename... "
    if curl -L -f -s "$url" -o "$output"; then
        print_success "完成"
        return 0
    else
        print_error "失败"
        return 1
    fi
}

# 下载SDK文件
print_header "下载SDK文件"

# 主要AAR文件
if ! download_file "questionnaire_sdk-release.aar"; then
    print_error "下载主要AAR文件失败"
    exit 1
fi

# 依赖库文件
download_file "kunlun.v6.012.1617-all.jar" || print_warning "Kunlun JAR下载失败，可能需要手动添加"
download_file "kunlun_swift.v1.101.2811.aar" || print_warning "Kunlun Swift AAR下载失败，可能需要手动添加"

# 配置build.gradle
print_header "配置项目"

BUILD_GRADLE="$TARGET_PROJECT/app/build.gradle"

if [ -f "$BUILD_GRADLE" ]; then
    # 检查并添加libs依赖
    if ! grep -q "fileTree(dir.*libs" "$BUILD_GRADLE"; then
        print_warning "添加libs依赖到build.gradle"
        # 在dependencies块中添加fileTree依赖
        if grep -q "dependencies {" "$BUILD_GRADLE"; then
            sed -i.bak '/dependencies {/a\
    implementation fileTree(dir: "libs", include: ["*.jar", "*.aar"])
' "$BUILD_GRADLE"
            print_success "已添加libs依赖"
        else
            print_warning "请手动添加以下依赖到build.gradle:"
            echo "implementation fileTree(dir: 'libs', include: ['*.jar', '*.aar'])"
        fi
    else
        print_success "libs依赖已存在"
    fi
    
    # 检查并添加MultiDex支持
    if ! grep -q "multiDexEnabled" "$BUILD_GRADLE"; then
        print_warning "建议启用MultiDex支持"
        echo "请在defaultConfig中添加: multiDexEnabled true"
    else
        print_success "MultiDex支持已配置"
    fi
    
    # 检查编译版本
    COMPILE_SDK=$(grep "compileSdkVersion" "$BUILD_GRADLE" | grep -o '[0-9]\+' | head -1)
    if [ -n "$COMPILE_SDK" ] && [ "$COMPILE_SDK" -lt 33 ]; then
        print_warning "建议使用compileSdkVersion 33或更高版本"
    fi
else
    print_warning "未找到app/build.gradle文件"
fi

# 创建使用示例
EXAMPLE_FILE="$TARGET_PROJECT/QuestionnaireSdkExample.java"
if [ ! -f "$EXAMPLE_FILE" ]; then
    cat > "$EXAMPLE_FILE" << 'EOF'
// Questionnaire SDK 使用示例
// 请将此代码集成到您的Activity中

import com.kunlun.questionnaire.QuestionnairSdk;

public class MainActivity extends AppCompatActivity {
    private QuestionnairSdk questionnairSdk;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // 初始化SDK
        questionnairSdk = new QuestionnairSdk();
    }
    
    // 显示问卷
    private void showQuestionnaire(String voteId) {
        questionnairSdk.showQuestionnaire(this, voteId, "CN", 
            new QuestionnairSdk.QuestionnairListioner() {
                @Override
                public void onComplete(int retCode, String retMsg) {
                    Log.d("Questionnaire", "完成: " + retCode + ", " + retMsg);
                    // 处理问卷完成回调
                }
            });
    }
}
EOF
    print_success "创建使用示例: $EXAMPLE_FILE"
fi

# 生成安装报告
REPORT_FILE="$TARGET_PROJECT/sdk_remote_install_report.txt"
cat > "$REPORT_FILE" << EOF
Questionnaire SDK 远程安装报告
生成时间: $(date)

=== 安装信息 ===
SDK版本: $VERSION
目标项目: $TARGET_PROJECT
仓库地址: $REPO_URL

=== 已安装文件 ===
EOF

# 列出已安装的文件
if [ -d "$LIBS_DIR" ]; then
    echo "AAR/JAR文件:" >> "$REPORT_FILE"
    ls -la "$LIBS_DIR"/*.{aar,jar} 2>/dev/null | while read line; do
        echo "  $line" >> "$REPORT_FILE"
    done
fi

cat >> "$REPORT_FILE" << EOF

=== 使用方法 ===
1. 同步项目 (Sync Project)
2. 清理并重新构建项目
3. 参考 QuestionnaireSdkExample.java 集成代码

=== 故障排除 ===
如遇到问题，请:
1. 检查build.gradle配置
2. 确保所有AAR文件完整下载
3. 运行项目清理: ./gradlew clean
4. 查看完整文档: $REPO_URL

=== 版本信息 ===
当前版本: $VERSION
检查更新: curl -s $API_URL/releases/latest | grep tag_name
EOF

print_success "生成安装报告: $REPORT_FILE"

# 完成安装
print_header "安装完成"
print_success "Questionnaire SDK $VERSION 已成功安装到 $TARGET_PROJECT"
echo ""
echo "下一步操作:"
echo "1. 在Android Studio中同步项目 (Sync Project)"
echo "2. 参考 QuestionnaireSdkExample.java 集成SDK"
echo "3. 查看安装报告: $REPORT_FILE"
echo ""
echo "如需帮助，请访问: $REPO_URL"

# 检查是否需要更新
if command -v git >/dev/null 2>&1; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/.git" ]; then
        echo ""
        print_header "检查脚本更新"
        cd "$SCRIPT_DIR"
        if git fetch origin main 2>/dev/null; then
            LOCAL=$(git rev-parse HEAD)
            REMOTE=$(git rev-parse origin/main)
            if [ "$LOCAL" != "$REMOTE" ]; then
                print_warning "发现脚本更新，建议运行: git pull origin main"
            else
                print_success "脚本已是最新版本"
            fi
        fi
    fi
fi