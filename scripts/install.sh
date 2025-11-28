#!/bin/bash

# NewFileHere 安装脚本
# 自动安装应用、工作流和配置别名

set -e

echo "========================================="
echo "NewFileHere 安装脚本"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build"

# 检查是否已构建
if [ ! -d "$BUILD_DIR/NewFileHere.app" ]; then
    echo -e "${RED}错误：未找到构建文件${NC}"
    echo "请先运行: ./scripts/build-dmg.sh"
    exit 1
fi

echo -e "${YELLOW}步骤 1/4：安装应用到 /Applications/${NC}"
if [ -d "/Applications/NewFileHere.app" ]; then
    echo "移除旧版本..."
    sudo rm -rf "/Applications/NewFileHere.app"
fi
sudo cp -R "$BUILD_DIR/NewFileHere.app" /Applications/
sudo chmod -R 755 /Applications/NewFileHere.app
echo -e "${GREEN}✓ 应用安装成功${NC}"
echo ""

echo -e "${YELLOW}步骤 2/4：安装 Quick Action 工作流${NC}"
mkdir -p ~/Library/Services/
if [ -d ~/Library/Services/NewFileHere.workflow ]; then
    echo "移除旧版本..."
    rm -rf ~/Library/Services/NewFileHere.workflow
fi
cp -R "$BUILD_DIR/NewFileHere.workflow" ~/Library/Services/
echo -e "${GREEN}✓ Quick Action 安装成功${NC}"
echo ""

echo -e "${YELLOW}步骤 3/4：配置命令行别名${NC}"
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    # 检查是否已存在别名
    if grep -q "alias newfile=" "$SHELL_RC" 2>/dev/null; then
        echo "别名已存在，跳过..."
    else
        echo 'alias newfile="/Applications/NewFileHere.app/Contents/MacOS/newfile"' >> "$SHELL_RC"
        echo -e "${GREEN}✓ 别名已添加到 $SHELL_RC${NC}"
        echo -e "${YELLOW}  请运行以下命令使别名生效：${NC}"
        echo -e "  source $SHELL_RC"
    fi
else
    echo -e "${YELLOW}未检测到 shell 配置文件，请手动添加别名${NC}"
fi
echo ""

echo -e "${YELLOW}步骤 4/4：刷新系统服务缓存${NC}"
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
killall Finder 2>/dev/null || true
echo -e "${GREEN}✓ 系统缓存已刷新${NC}"
echo ""

echo "========================================="
echo -e "${GREEN}安装完成！${NC}"
echo "========================================="
echo ""
echo "使用方法："
echo ""
echo "1. Quick Action（需要选中文件夹）："
echo "   - 在 Finder 中选中文件夹 → 右键 → 服务/快速操作 → 新建文件"
echo ""
echo "2. 命令行（推荐）："
echo "   - 在终端运行: newfile"
echo "   - 或指定目录: newfile -dir ~/Documents"
echo ""
echo "3. Finder 工具栏（最方便）："
echo "   - 查看 INSTALLATION.md 了解如何添加工具栏按钮"
echo ""
echo -e "${YELLOW}提示：如果 Quick Action 未显示，请：${NC}"
echo "1. 打开 系统偏好设置 → 键盘 → 快捷键 → 服务"
echo "2. 找到并勾选"新建文件""
echo "3. 或者重新登录系统"
echo ""
echo "详细文档请查看: $PROJECT_ROOT/INSTALLATION.md"
