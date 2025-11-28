#!/bin/bash

# NewFileHere DMG 构建脚本
# 用于编译 Go 程序并打包成 macOS 应用

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}NewFileHere DMG 构建脚本${NC}"
echo -e "${GREEN}========================================${NC}\n"

# 获取脚本所在目录的父目录（项目根目录）
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# 定义变量
APP_NAME="NewFileHere"
BUILD_DIR="$PROJECT_ROOT/build"
DIST_DIR="$PROJECT_ROOT/dist"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
DMG_NAME="${APP_NAME}.dmg"

# 清理旧的构建文件
echo -e "${YELLOW}清理旧的构建文件...${NC}"
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"

# 编译 Go 程序
echo -e "${YELLOW}编译 Go 程序...${NC}"
go build -o "$BUILD_DIR/newfile" -ldflags="-s -w" cmd/newfile/main.go
if [ $? -ne 0 ]; then
    echo -e "${RED}编译失败！${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 编译成功${NC}\n"

# 创建应用程序包结构
echo -e "${YELLOW}创建应用程序包...${NC}"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# 复制可执行文件
cp "$BUILD_DIR/newfile" "$APP_BUNDLE/Contents/MacOS/"

# 复制配置文件和模板
cp config.yaml "$APP_BUNDLE/Contents/Resources/"
cp -r templates "$APP_BUNDLE/Contents/Resources/"

# 创建 Info.plist
cat > "$APP_BUNDLE/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleExecutable</key>
    <string>newfile</string>
    <key>CFBundleIdentifier</key>
    <string>com.newfilehere.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo -e "${GREEN}✓ 应用程序包创建成功${NC}\n"

# 创建 Quick Action 工作流
echo -e "${YELLOW}创建 Quick Action 工作流...${NC}"
WORKFLOW_DIR="$BUILD_DIR/$APP_NAME.workflow"
mkdir -p "$WORKFLOW_DIR/Contents"

cat > "$WORKFLOW_DIR/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSServices</key>
    <array>
        <dict>
            <key>NSBackgroundColorName</key>
            <string>background</string>
            <key>NSIconName</key>
            <string>NSTouchBarComposeTemplate</string>
            <key>NSMenuItem</key>
            <dict>
                <key>default</key>
                <string>新建文件</string>
            </dict>
            <key>NSMessage</key>
            <string>runWorkflowAsService</string>
            <key>NSRequiredContext</key>
            <dict>
                <key>NSApplicationIdentifier</key>
                <string>com.apple.finder</string>
            </dict>
            <key>NSSendFileTypes</key>
            <array>
                <string>public.folder</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
EOF

# 创建工作流文档
cat > "$WORKFLOW_DIR/Contents/document.wflow" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AMApplicationBuild</key>
    <string>523</string>
    <key>AMApplicationVersion</key>
    <string>2.10</string>
    <key>AMDocumentVersion</key>
    <string>2</string>
    <key>actions</key>
    <array>
        <dict>
            <key>action</key>
            <dict>
                <key>AMAccepts</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.path</string>
                    </array>
                </dict>
                <key>AMActionVersion</key>
                <string>1.0.2</string>
                <key>AMApplication</key>
                <array>
                    <string>Automator</string>
                </array>
                <key>AMParameterProperties</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <dict/>
                    <key>inputMethod</key>
                    <dict/>
                </dict>
                <key>AMProvides</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.attributed-string</string>
                    </array>
                </dict>
                <key>ActionBundlePath</key>
                <string>/System/Library/Automator/Run Shell Script.action</string>
                <key>ActionName</key>
                <string>Run Shell Script</string>
                <key>ActionParameters</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <string>/Applications/NewFileHere.app/Contents/MacOS/newfile "$@"</string>
                    <key>inputMethod</key>
                    <integer>1</integer>
                </dict>
                <key>BundleIdentifier</key>
                <string>com.apple.RunShellScript</string>
            </dict>
        </dict>
    </array>
    <key>connectors</key>
    <dict/>
    <key>workflowMetaData</key>
    <dict>
        <key>serviceInputTypeIdentifier</key>
        <string>com.apple.Automator.fileSystemObject.folder</string>
        <key>serviceOutputTypeIdentifier</key>
        <string>com.apple.Automator.nothing</string>
        <key>workflowTypeIdentifier</key>
        <string>com.apple.Automator.servicesMenu</string>
    </dict>
</dict>
</plist>
EOF

echo -e "${GREEN}✓ Quick Action 创建成功${NC}\n"

# 创建安装说明
cat > "$BUILD_DIR/安装说明.txt" << EOF
NewFileHere - 安装说明
======================

感谢您下载 NewFileHere！

安装步骤：
=========

1. 将 NewFileHere.app 拖拽到 Applications（应用程序）文件夹

2. 将 NewFileHere.workflow 拖拽到以下位置之一：
   - ~/Library/Services/           （仅当前用户）
   - /Library/Services/             （所有用户，需要管理员权限）

3. 重启 Finder 或注销重新登录使 Quick Action 生效

使用方法：
=========

1. 在 Finder 中打开任意文件夹
2. 右键点击文件夹中的空白处
3. 选择 "快速操作" -> "新建文件"
4. 在弹出的对话框中选择要创建的文件类型
5. 新文件将在当前目录创建并自动打开

自定义：
========

您可以编辑以下文件来自定义功能：
- /Applications/NewFileHere.app/Contents/Resources/config.yaml
- /Applications/NewFileHere.app/Contents/Resources/templates/

卸载：
======

删除以下文件即可：
- /Applications/NewFileHere.app
- ~/Library/Services/NewFileHere.workflow

作者：zhaoshenchen
EOF

echo -e "${YELLOW}创建 DMG 镜像...${NC}"

# 创建临时挂载点
DMG_TEMP_DIR="$BUILD_DIR/dmg_temp"
mkdir -p "$DMG_TEMP_DIR"

# 复制文件到临时目录
cp -r "$APP_BUNDLE" "$DMG_TEMP_DIR/"
cp -r "$WORKFLOW_DIR" "$DMG_TEMP_DIR/"
cp "$BUILD_DIR/安装说明.txt" "$DMG_TEMP_DIR/"

# 创建 Applications 符号链接
ln -s /Applications "$DMG_TEMP_DIR/Applications"

# 创建 DMG
hdiutil create -volname "$APP_NAME" \
    -srcfolder "$DMG_TEMP_DIR" \
    -ov -format UDZO \
    "$DIST_DIR/$DMG_NAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}创建 DMG 失败！${NC}"
    exit 1
fi

echo -e "${GREEN}✓ DMG 创建成功${NC}\n"

# 清理临时文件
echo -e "${YELLOW}清理临时文件...${NC}"
rm -rf "$DMG_TEMP_DIR"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}构建完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nDMG 文件位置: ${YELLOW}$DIST_DIR/$DMG_NAME${NC}\n"
