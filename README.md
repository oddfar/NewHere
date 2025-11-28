# NewHere - macOS 右键 "在此新建文件" 工具

NewHere 是一个轻量级的 macOS 工具，允许用户通过 Finder (访达) 的右键菜单快速创建各种类型的新文件。它使用 Go 语言编写，结合 AppleScript 和 Automator 实现原生体验。

## ✨ 功能特点

- **右键集成**: 直接集成到 Finder 的 "快捷操作" 菜单。
- **多种文件类型**: 支持创建文本文件、Markdown、Go 源代码、Python 脚本、Shell 脚本、Word 文档、PPT 等。
- **自定义配置**: 用户可以通过配置文件轻松添加或修改支持的文件类型和默认模板内容。
- **轻量级**: 核心逻辑由 Go 编写，运行速度快，无臃肿依赖。
- **原生界面**: 使用 macOS 原生对话框进行交互。

## 📦 安装说明

### 方法一：使用预编译安装包 (推荐)

1. 下载最新的 `NewHere_Installer.dmg`。
2. 打开 DMG 文件。
3. 将 **NewHere.app** 拖入您的 **应用程序** (Applications) 文件夹。
   > **注意**: 必须将应用放入 `/Applications` 目录，否则快捷操作可能无法找到它。
4. 双击 **NewFileHere.workflow** 并点击 **安装** (Install)。
5. 如果系统提示，请在 "系统设置 -> 隐私与安全性 -> 辅助功能" 中授予 "NewHere" 权限。

### 方法二：从源码编译

如果您安装了 Go 环境，可以从源码编译安装：

```bash
# 克隆仓库
git clone https://github.com/oddfar/NewHere.git
cd NewHere

# 编译并打包 DMG
make all

# 安装
open NewHere_Installer.dmg
```

## 🚀 使用指南

1. 打开 Finder (访达)，进入任意文件夹。
2. 在文件夹空白处点击 **右键**。
3. 选择 **快捷操作 (Quick Actions)** -> **New File Here**。
4. 在弹出的对话框中选择要创建的文件类型。
5. 输入文件名 (支持自定义后缀，如果不输入后缀则使用默认后缀)。
6. 点击 **创建**，文件将立即出现在当前文件夹中。

## ⚙️ 自定义配置

您可以自定义支持的文件类型和默认模板内容。配置文件位于应用包内：

`/Applications/NewHere.app/Contents/MacOS/config.yaml`

**修改步骤**:
1. 在应用程序文件夹中找到 `NewHere.app`。
2. 右键点击 -> **显示包内容**。
3. 进入 `Contents` -> `MacOS`。
4. 使用文本编辑器打开 `config.yaml`。

**配置示例**:

```yaml
types:
  - name: "Vue 组件"
    extension: "vue"
    content: |
      <template>
        <div></div>
      </template>
      <script>
      export default {
        name: 'NewComponent'
      }
      </script>
      <style scoped>
      </style>
```

## 🛠️ 开发

### 项目结构

- `main.go`: 核心应用程序逻辑 (Go)。
- `config.yaml`: 默认配置文件。
- `NewFileHere.workflow`: Automator 快捷操作源文件。
- `Makefile`: 构建和打包脚本。

### 构建命令

- `make build`: 仅编译 Go 二进制文件。
- `make app`: 编译并组装 `.app` 包。
- `make dmg`: 打包生成 `.dmg` 安装文件。
- `make clean`: 清理构建产物。

## 📄 许可证

MIT License
