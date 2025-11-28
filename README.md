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

1. 下载最新的 DMG 文件
2. 双击打开 DMG
3. 将应用拖入 Applications 文件夹
4. 在 Finder 中右键点击任意文件夹，即可在"快速操作"中看到"新建文件"选项

## 使用方法

1. 在 Finder 中打开任意文件夹
2. 右键点击空白处
3. 选择"快速操作" → "新建文件"
4. 在弹出的对话框中选择要创建的文件类型
5. 新文件将在当前目录创建

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
