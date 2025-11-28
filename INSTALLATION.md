# NewFileHere 安装与使用指南

## 问题说明

macOS 的 Quick Actions 有一个限制：它只能在**选中文件**时触发，无法在 Finder 空白处右键时触发。

因此，我们提供了**两种使用方式**供您选择。

## 方式一：Quick Action（需要选中文件夹）

### 安装步骤

1. 将 `NewFileHere.app` 复制到 `/Applications/`
2. 将 `NewFileHere.workflow` 复制到 `~/Library/Services/`
3. 重启 Finder：`killall Finder`

### 使用方法

1. 在 Finder 中**选中一个文件夹**
2. 右键点击该文件夹
3. 选择"服务" 或 "快速操作" → "新建文件"
4. 新文件将在该文件夹中创建

### 启用服务（如果没有显示）

1. 打开"系统偏好设置" → "键盘" → "快捷键" → "服务"
2. 找到"新建文件"并勾选启用
3. 可以设置快捷键（可选）

---

## 方式二：命令行别名（推荐 - 更灵活）

这种方式可以在任何目录快速创建文件。

### 安装步骤

1. 将 `NewFileHere.app` 复制到 `/Applications/`

2. 添加别名到您的 shell 配置文件：

**对于 zsh (macOS 默认)**：
```bash
echo 'alias newfile="/Applications/NewFileHere.app/Contents/MacOS/newfile"' >> ~/.zshrc
source ~/.zshrc
```

**对于 bash**：
```bash
echo 'alias newfile="/Applications/NewFileHere.app/Contents/MacOS/newfile"' >> ~/.bashrc
source ~/.bashrc
```

### 使用方法

在终端中进入任意目录，然后运行：
```bash
newfile
```

或指定目标目录：
```bash
newfile -dir ~/Documents
```

---

## 方式三：Finder 工具栏按钮（最方便）

这是最接近 Windows 右键新建文件的体验。

### 创建 Finder 工具栏脚本

1. 打开"脚本编辑器"应用
2. 创建新文档，选择"应用程序"类型
3. 粘贴以下 AppleScript：

```applescript
tell application "Finder"
    -- 获取当前 Finder 窗口的路径
    try
        set currentFolder to (target of front window) as alias
        set folderPath to POSIX path of currentFolder
    on error
        -- 如果没有打开的窗口，使用桌面
        set folderPath to POSIX path of (path to desktop folder)
    end try
end tell

-- 调用 NewFileHere 程序
do shell script "/Applications/NewFileHere.app/Contents/MacOS/newfile -dir " & quoted form of folderPath
```

4. 保存为"应用程序"格式，命名为"新建文件.app"
5. 保存到 `~/Applications/` 或任意位置
6. 按住 `⌘Command` 键，将"新建文件.app"拖到 Finder 工具栏

### 使用方法

1. 打开任意文件夹
2. 点击工具栏的"新建文件"按钮
3. 选择文件类型
4. 完成！

---

## 方式四：键盘快捷键（最快速）

### 设置步骤

1. 打开"系统偏好设置" → "键盘" → "快捷键" → "App 快捷键"
2. 点击 `+` 添加新快捷键
3. 选择应用程序：Finder
4. 菜单标题：输入"新建文件"（必须与 Quick Action 名称完全一致）
5. 设置快捷键，例如：`⌘⇧N` (Command + Shift + N)

### 使用方法

在 Finder 中按下您设置的快捷键即可。

---

## 故障排查

### Quick Action 不显示

1. **检查安装位置**：
   ```bash
   ls ~/Library/Services/NewFileHere.workflow
   ls /Applications/NewFileHere.app
   ```

2. **刷新服务缓存**：
   ```bash
   /System/Library/CoreServices/pbs -flush
   killall Finder
   ```

3. **检查系统偏好设置**：
   - "系统偏好设置" → "扩展" → "Finder"
   - 确保相关扩展已启用

4. **重新登录**：
   注销并重新登录 macOS

### 权限问题

如果提示没有权限：
```bash
chmod +x /Applications/NewFileHere.app/Contents/MacOS/newfile
```

### 找不到配置文件

确保配置文件和模板位于正确位置：
```bash
ls /Applications/NewFileHere.app/Contents/Resources/config.yaml
ls /Applications/NewFileHere.app/Contents/Resources/templates/
```

---

## 推荐方案

根据不同使用习惯：

- **🎯 推荐**：方式三（工具栏按钮）- 最接近 Windows 体验
- **⚡ 快速**：方式四（键盘快捷键）- 效率最高
- **💻 终端**：方式二（命令行别名）- 适合开发者
- **📁 传统**：方式一（Quick Action）- 系统原生但需选中文件夹

---

## 测试验证

安装完成后，测试创建文件：

1. 打开任意文件夹
2. 使用上述任一方式触发
3. 选择文件类型（例如：文本文件）
4. 确认文件成功创建

如有问题，请查看故障排查部分或提交 Issue。
