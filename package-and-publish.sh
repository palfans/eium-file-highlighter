#!/bin/bash

# 打包和发布 VS Code 扩展的脚本
# 作者: GitHub Copilot
# 日期: May 10, 2025

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 显示带颜色的消息函数
echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo_error "$1 命令未找到，请安装后重试。"
        echo_info "可以尝试运行: npm install -g $1"
        exit 1
    fi
}

# 切换到项目目录
cd "$(dirname "$0")"

# 检查 vsce 命令是否存在
check_command vsce

# 清除旧的 vsix 文件
echo_info "清除旧的 .vsix 文件..."
rm -f *.vsix

# 获取当前版本号
VERSION=$(grep -o '"version": "[^"]*' package.json | cut -d'"' -f4)
echo_info "当前版本: $VERSION"

# 创建变更日志条目
if [ ! -f CHANGELOG.md ]; then
    echo "# Change Log" > CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "All notable changes to the \"eium-file-highlighter\" extension will be documented in this file." >> CHANGELOG.md
    echo "" >> CHANGELOG.md
fi

# 检查是否已经有这个版本的记录
if ! grep -q "## $VERSION" CHANGELOG.md; then
    echo_info "正在更新 CHANGELOG.md..."
    
    # 在文件顶部插入新的变更日志条目
    TEMP_FILE=$(mktemp)
    cat CHANGELOG.md > $TEMP_FILE
    
    echo "# Change Log" > CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "All notable changes to the \"eium-file-highlighter\" extension will be documented in this file." >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "## $VERSION - $(date +'%Y-%m-%d')" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "- Updated version to $VERSION" >> CHANGELOG.md
    echo "- Improved syntax highlighting rules" >> CHANGELOG.md
    echo "- Fixed known issues" >> CHANGELOG.md
    echo "- Performance optimizations" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    
    # 添加原有内容但跳过前4行
    tail -n +5 $TEMP_FILE >> CHANGELOG.md
    rm $TEMP_FILE
fi

# 打包扩展
echo_info "正在打包扩展..."
vsce package

# 检查打包是否成功
if [ $? -ne 0 ]; then
    echo_error "打包失败！"
    exit 1
fi

echo_info "打包成功！生成的文件: eium-file-highlighter-$VERSION.vsix"

# 提示用户是否发布到 VS Code Marketplace
echo ""
read -p "是否要发布到 VS Code Marketplace? (y/n): " PUBLISH

if [ "$PUBLISH" = "y" ] || [ "$PUBLISH" = "Y" ]; then
    echo_info "正在发布扩展到 VS Code Marketplace..."
    vsce publish
    
    if [ $? -ne 0 ]; then
        echo_error "发布失败！请确保您已登录并有权限发布。"
        echo_info "提示: 您可能需要先运行 'vsce login <publisher>' 命令。"
        exit 1
    fi
    
    echo_info "发布成功！您的扩展已发布到 VS Code Marketplace。"
else
    echo_info "跳过发布步骤。扩展已打包但未发布。"
fi

# 提示用户是否将更改提交到 Git
echo ""
read -p "是否要将更改提交到 Git? (y/n): " COMMIT

if [ "$COMMIT" = "y" ] || [ "$COMMIT" = "Y" ]; then
    # 检查 git 命令是否存在
    check_command git
    
    echo_info "正在提交更改到 Git..."
    git add .
    git commit -m "Update to version $VERSION"
    
    # 提示用户是否创建标签
    read -p "是否要创建版本标签 v$VERSION? (y/n): " TAG
    if [ "$TAG" = "y" ] || [ "$TAG" = "Y" ]; then
        git tag -a "v$VERSION" -m "Version $VERSION"
    fi
    
    # 提示用户是否推送更改
    read -p "是否要推送更改到远程仓库? (y/n): " PUSH
    if [ "$PUSH" = "y" ] || [ "$PUSH" = "Y" ]; then
        git push
        
        # 如果创建了标签，也推送标签
        if [ "$TAG" = "y" ] || [ "$TAG" = "Y" ]; then
            git push --tags
        fi
        
        echo_info "已成功推送更改到远程仓库！"
    else
        echo_info "更改已提交到本地仓库，但未推送到远程仓库。"
    fi
else
    echo_info "跳过 Git 提交步骤。"
fi

echo_info "脚本执行完成！"