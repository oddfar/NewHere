# NewFileHere - macOS 右键新建文件工具

这是一个轻量级的 macOS 工具，让您可以像在 Windows 中一样通过右键菜单快速创建新文件。

## 功能特性

- 🎯 通过右键菜单快速创建文件
- 📝 支持多种文件类型（txt、md、Office 文档、代码文件等）
- ⚙️ 可配置的文件类型和模板
- 🚀 轻量级，使用 Go 语言开发
- 🍎 原生 macOS 集成（Quick Actions）

## 支持的文件类型

- **文本文件**：txt, md
- **Office 文档**：doc, docx, xls, xlsx, ppt, pptx
- **代码文件**：go, py, js, html, css, java
- **其他**：pdf, zip

## 安装方法

### 快速安装（推荐）

1. 下载并打开 `NewFileHere.dmg`
2. 运行自动安装脚本：
   ```bash
   ./scripts/install.sh
   ```

### 手动安装

1. 将 `NewFileHere.app` 拖入 Applications（应用程序）文件夹
2. 将 `NewFileHere.workflow` 拖入 `~/Library/Services/`
3. 重启 Finder：`killall Finder`

详细安装说明请查看：[INSTALLATION.md](INSTALLATION.md)

## 使用方法

### 🎯 方式一：Quick Action（需选中文件夹）

1. 在 Finder 中**选中一个文件夹**
2. 右键点击文件夹
3. 选择"服务" 或 "快速操作" → "新建文件"
4. 在弹出的对话框中选择文件类型

**注意**：macOS 限制，Quick Action 只能在选中文件/文件夹时触发。

### ⚡ 方式二：命令行（推荐）

更灵活，可在任意目录使用：

```bash
# 在当前目录创建文件
newfile

# 在指定目录创建文件
newfile -dir ~/Documents
```

### 🔧 方式三：Finder 工具栏（最方便）

最接近 Windows 的体验！

1. 查看 [INSTALLATION.md](INSTALLATION.md) 中的"方式三"
2. 创建工具栏应用后，在任意 Finder 窗口点击工具栏按钮即可

## 自定义配置

编辑 `config.yaml` 文件可以自定义支持的文件类型和模板。

## 技术栈

- Go 1.21+
- macOS Quick Actions
- 原生系统对话框（osascript）

## 开发

```bash
# 克隆仓库
git clone <repository-url>

# 初始化 Go 模块
go mod download

# 构建
go build -o newfile cmd/newfile/main.go

# 运行测试
go test ./...
```

## 构建 DMG

```bash
./scripts/build-dmg.sh
```

## 许可证

MIT License

## 作者

zhaoshenchen
