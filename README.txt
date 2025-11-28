NewHere - macOS 右键 "在此新建文件" 工具
==============================================

安装说明:
1. 将 "NewHere.app" 拖入您的 "应用程序" (Applications) 文件夹。
   (必须执行此步骤，因为快捷操作会在 /Applications/NewHere.app 中查找应用)

2. 双击 "NewFileHere.workflow" 安装快捷操作。
   - 在提示时点击 "安装" (Install)。
   - 如果系统提示，请在 "系统设置 -> 隐私与安全性 -> 辅助功能" 中授予 "NewHere" 权限。

使用方法:
1. 在 Finder (访达) 中，进入任意文件夹。
2. 在文件夹空白处点击右键。
3. 选择 "快捷操作" (Quick Actions) -> "New File Here"。
4. 选择文件类型并输入文件名。
5. 文件将创建在当前文件夹中！

自定义配置:
您可以编辑应用包内的 `config.yaml` 文件来添加新的文件类型：
/Applications/NewHere.app/Contents/MacOS/config.yaml
(右键点击 NewHere.app -> 显示包内容)
