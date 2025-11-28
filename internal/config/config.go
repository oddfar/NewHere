package config

import (
	"fmt"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v3"
)

// FileType 表示一个可创建的文件类型
type FileType struct {
	Name        string `yaml:"name"`         // 显示名称
	Extension   string `yaml:"extension"`    // 文件扩展名
	DefaultName string `yaml:"default_name"` // 默认文件名（不含扩展名）
	Template    string `yaml:"template"`     // 模板文件名
}

// Settings 应用设置
type Settings struct {
	ConflictResolution string `yaml:"conflict_resolution"` // 文件名冲突处理方式
	OpenAfterCreate    bool   `yaml:"open_after_create"`   // 创建后是否打开文件
	DialogWidth        int    `yaml:"dialog_width"`        // 对话框宽度
	DialogHeight       int    `yaml:"dialog_height"`       // 对话框高度
}

// Config 配置文件结构
type Config struct {
	FileTypes []FileType `yaml:"file_types"` // 支持的文件类型
	Settings  Settings   `yaml:"settings"`   // 应用设置
}

// Load 从指定路径加载配置文件
func Load(configPath string) (*Config, error) {
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, fmt.Errorf("读取配置文件失败: %w", err)
	}

	var config Config
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("解析配置文件失败: %w", err)
	}

	return &config, nil
}

// GetConfigPath 获取配置文件路径
// 优先级：1. 参数指定的路径 2. 可执行文件同目录 3. 用户主目录
func GetConfigPath(providedPath string) (string, error) {
	// 如果提供了路径且文件存在，直接使用
	if providedPath != "" {
		if _, err := os.Stat(providedPath); err == nil {
			return providedPath, nil
		}
	}

	// 尝试可执行文件同目录
	execPath, err := os.Executable()
	if err == nil {
		execDir := filepath.Dir(execPath)
		configPath := filepath.Join(execDir, "config.yaml")
		if _, err := os.Stat(configPath); err == nil {
			return configPath, nil
		}
	}

	// 尝试用户主目录
	homeDir, err := os.UserHomeDir()
	if err == nil {
		configPath := filepath.Join(homeDir, ".newfilehere", "config.yaml")
		if _, err := os.Stat(configPath); err == nil {
			return configPath, nil
		}
	}

	return "", fmt.Errorf("未找到配置文件")
}

// GetTemplateDir 获取模板文件目录
func GetTemplateDir() (string, error) {
	// 尝试可执行文件同目录的 templates 文件夹
	execPath, err := os.Executable()
	if err == nil {
		execDir := filepath.Dir(execPath)
		templateDir := filepath.Join(execDir, "templates")
		if stat, err := os.Stat(templateDir); err == nil && stat.IsDir() {
			return templateDir, nil
		}
	}

	// 尝试用户主目录
	homeDir, err := os.UserHomeDir()
	if err == nil {
		templateDir := filepath.Join(homeDir, ".newfilehere", "templates")
		if stat, err := os.Stat(templateDir); err == nil && stat.IsDir() {
			return templateDir, nil
		}
	}

	return "", fmt.Errorf("未找到模板目录")
}
