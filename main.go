package main

import (
	"embed"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"gopkg.in/yaml.v3"
)

//go:embed config.yaml
var configFS embed.FS

type FileType struct {
	Name      string `yaml:"name"`
	Extension string `yaml:"extension"`
	Content   string `yaml:"content"`
}

type Config struct {
	Types []FileType `yaml:"types"`
}

func main() {
	// 1. Determine target directory
	targetDir := "."
	if len(os.Args) > 1 {
		targetDir = os.Args[1]
	}
	
	// Ensure target directory exists
	if _, err := os.Stat(targetDir); os.IsNotExist(err) {
		showError("目标目录不存在: " + targetDir)
		os.Exit(1)
	}

	// 2. Load Configuration
	config, err := loadConfig()
	if err != nil {
		showError("无法加载配置: " + err.Error())
		os.Exit(1)
	}

	// 3. Show File Type Selection
	selectedType, err := showTypeSelection(config.Types)
	if err != nil {
		// User cancelled or error
		if err.Error() != "User cancelled" {
			showError("选择文件类型错误: " + err.Error())
		}
		os.Exit(0)
	}

	// 4. Show Filename Input
	filename, err := showFilenameInput(selectedType.Extension)
	if err != nil {
		if err.Error() != "User cancelled" {
			showError("输入文件名错误: " + err.Error())
		}
		os.Exit(0)
	}

	// 5. Create File
	fullPath := filepath.Join(targetDir, filename)
	err = createFile(fullPath, selectedType.Content)
	if err != nil {
		showError("无法创建文件: " + err.Error())
		os.Exit(1)
	}
}

func loadConfig() (*Config, error) {
	// First try to load from the same directory as the executable (for user customization)
	exePath, err := os.Executable()
	if err == nil {
		configPath := filepath.Join(filepath.Dir(exePath), "config.yaml")
		if _, err := os.Stat(configPath); err == nil {
			data, err := ioutil.ReadFile(configPath)
			if err == nil {
				var config Config
				if err := yaml.Unmarshal(data, &config); err == nil {
					return &config, nil
				}
			}
		}
	}

	// Fallback to embedded config
	data, err := configFS.ReadFile("config.yaml")
	if err != nil {
		return nil, err
	}
	var config Config
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, err
	}
	return &config, nil
}

func showTypeSelection(types []FileType) (*FileType, error) {
	var typeNames []string
	for _, t := range types {
		typeNames = append(typeNames, fmt.Sprintf("%s (.%s)", t.Name, t.Extension))
	}

	// AppleScript to choose from list
	script := fmt.Sprintf(`set typeList to {%s}
set selectedType to choose from list typeList with prompt "请选择文件类型:" with title "在此新建文件"
if selectedType is false then
	return "CANCELLED"
else
	return item 1 of selectedType
end if`, formatAppleScriptList(typeNames))

	out, err := runAppleScript(script)
	if err != nil {
		return nil, err
	}

	out = strings.TrimSpace(out)
	if out == "CANCELLED" {
		return nil, fmt.Errorf("User cancelled")
	}

	// Find the matched type
	for _, t := range types {
		if fmt.Sprintf("%s (.%s)", t.Name, t.Extension) == out {
			return &t, nil
		}
	}
	return nil, fmt.Errorf("Unknown selection: %s", out)
}

func showFilenameInput(defaultExtension string) (string, error) {
	defaultName := "未命名." + defaultExtension
	script := fmt.Sprintf(`display dialog "请输入文件名:" default answer "%s" with title "在此新建文件" buttons {"取消", "创建"} default button "创建"
text returned of result`, defaultName)

	out, err := runAppleScript(script)
	if err != nil {
		// If user clicks Cancel, osascript returns non-zero exit code usually
		return "", fmt.Errorf("User cancelled")
	}
	return strings.TrimSpace(out), nil
}

func createFile(path string, content string) error {
	// Check if file exists
	if _, err := os.Stat(path); err == nil {
		return fmt.Errorf("文件已存在: %s", path)
	}

	return ioutil.WriteFile(path, []byte(content), 0644)
}

func showError(msg string) {
	script := fmt.Sprintf(`display dialog "%s" with title "错误" buttons {"确定"} default button "确定" with icon stop`, msg)
	runAppleScript(script)
}

func runAppleScript(script string) (string, error) {
	cmd := exec.Command("osascript", "-e", script)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func formatAppleScriptList(items []string) string {
	var quoted []string
	for _, item := range items {
		quoted = append(quoted, fmt.Sprintf("\"%s\"", item))
	}
	return strings.Join(quoted, ", ")
}
