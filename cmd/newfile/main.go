package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"newfilehere/internal/config"
	"newfilehere/internal/creator"
	"newfilehere/internal/ui"
)

func main() {
	// 解析命令行参数
	var (
		targetDir  string
		configPath string
	)

	flag.StringVar(&targetDir, "dir", ".", "目标目录路径")
	flag.StringVar(&configPath, "config", "", "配置文件路径")
	flag.Parse()

	// 如果提供了位置参数，使用第一个作为目标目录
	if flag.NArg() > 0 {
		targetDir = flag.Arg(0)
	}

	// 验证目标目录
	if stat, err := os.Stat(targetDir); err != nil || !stat.IsDir() {
		ui.ShowErrorDialog(fmt.Sprintf("无效的目标目录: %s", targetDir))
		log.Fatalf("无效的目标目录: %s", targetDir)
	}

	// 加载配置文件
	cfgPath, err := config.GetConfigPath(configPath)
	if err != nil {
		ui.ShowErrorDialog(fmt.Sprintf("未找到配置文件: %v", err))
		log.Fatalf("未找到配置文件: %v", err)
	}

	cfg, err := config.Load(cfgPath)
	if err != nil {
		ui.ShowErrorDialog(fmt.Sprintf("加载配置文件失败: %v", err))
		log.Fatalf("加载配置文件失败: %v", err)
	}

	// 获取模板目录
	templateDir, err := config.GetTemplateDir()
	if err != nil {
		ui.ShowErrorDialog(fmt.Sprintf("未找到模板目录: %v", err))
		log.Fatalf("未找到模板目录: %v", err)
	}

	// 显示文件类型选择对话框
	selectedIndex, err := ui.ShowFileTypeDialog(cfg.FileTypes)
	if err != nil {
		// 用户取消操作，静默退出
		log.Printf("用户取消操作: %v", err)
		os.Exit(0)
	}

	// 创建文件
	fileCreator := creator.New(cfg, templateDir)
	filePath, err := fileCreator.CreateFile(targetDir, selectedIndex)
	if err != nil {
		ui.ShowErrorDialog(fmt.Sprintf("创建文件失败: %v", err))
		log.Fatalf("创建文件失败: %v", err)
	}

	// 打开文件
	if err := fileCreator.OpenFile(filePath); err != nil {
		log.Printf("打开文件失败: %v", err)
	}

	// 显示成功消息（可选）
	log.Printf("成功创建文件: %s", filePath)
}
