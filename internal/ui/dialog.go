package ui

import (
	"fmt"
	"os/exec"
	"strings"

	"newfilehere/internal/config"
)

// ShowFileTypeDialog 显示文件类型选择对话框
// 使用 macOS 原生的 osascript 调用对话框
func ShowFileTypeDialog(fileTypes []config.FileType) (int, error) {
	if len(fileTypes) == 0 {
		return -1, fmt.Errorf("没有可用的文件类型")
	}

	// 构建选项列表
	var options []string
	for _, ft := range fileTypes {
		options = append(options, fmt.Sprintf("%s (.%s)", ft.Name, ft.Extension))
	}

	// 构建 AppleScript
	script := fmt.Sprintf(`
		set fileTypeList to {%s}
		set selectedType to choose from list fileTypeList with prompt "选择要创建的文件类型：" default items {item 1 of fileTypeList}
		if selectedType is false then
			return ""
		else
			return item 1 of selectedType
		end if
	`, `"`+strings.Join(options, `", "`)+`"`)

	// 执行 AppleScript
	cmd := exec.Command("osascript", "-e", script)
	output, err := cmd.Output()
	if err != nil {
		return -1, fmt.Errorf("显示对话框失败: %w", err)
	}

	// 解析用户选择
	selected := strings.TrimSpace(string(output))
	if selected == "" {
		return -1, fmt.Errorf("用户取消操作")
	}

	// 找到对应的索引
	for i, option := range options {
		if option == selected {
			return i, nil
		}
	}

	return -1, fmt.Errorf("未找到选择的文件类型")
}

// ShowErrorDialog 显示错误对话框
func ShowErrorDialog(message string) {
	script := fmt.Sprintf(`
		display dialog "%s" buttons {"确定"} default button 1 with icon stop with title "错误"
	`, escapeAppleScript(message))

	exec.Command("osascript", "-e", script).Run()
}

// ShowSuccessDialog 显示成功对话框
func ShowSuccessDialog(message string) {
	script := fmt.Sprintf(`
		display dialog "%s" buttons {"确定"} default button 1 with title "成功"
	`, escapeAppleScript(message))

	exec.Command("osascript", "-e", script).Run()
}

// escapeAppleScript 转义 AppleScript 中的特殊字符
func escapeAppleScript(s string) string {
	s = strings.ReplaceAll(s, `\`, `\\`)
	s = strings.ReplaceAll(s, `"`, `\"`)
	return s
}
