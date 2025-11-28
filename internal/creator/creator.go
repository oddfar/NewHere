package creator

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"

	"newfilehere/internal/config"
)

// Creator 文件创建器
type Creator struct {
	config      *config.Config
	templateDir string
}

// New 创建新的文件创建器
func New(cfg *config.Config, templateDir string) *Creator {
	return &Creator{
		config:      cfg,
		templateDir: templateDir,
	}
}

// CreateFile 在指定目录创建文件
func (c *Creator) CreateFile(targetDir string, fileTypeIndex int) (string, error) {
	if fileTypeIndex < 0 || fileTypeIndex >= len(c.config.FileTypes) {
		return "", fmt.Errorf("无效的文件类型索引: %d", fileTypeIndex)
	}

	fileType := c.config.FileTypes[fileTypeIndex]

	// 生成文件名
	fileName := c.generateFileName(targetDir, fileType)
	filePath := filepath.Join(targetDir, fileName)

	// 复制模板文件或创建空文件
	if err := c.createFromTemplate(filePath, fileType.Template); err != nil {
		return "", fmt.Errorf("创建文件失败: %w", err)
	}

	return filePath, nil
}

// generateFileName 生成文件名（处理冲突）
func (c *Creator) generateFileName(targetDir string, fileType config.FileType) string {
	baseName := fileType.DefaultName
	extension := fileType.Extension
	fileName := fmt.Sprintf("%s.%s", baseName, extension)

	// 检查文件是否存在
	fullPath := filepath.Join(targetDir, fileName)
	if _, err := os.Stat(fullPath); os.IsNotExist(err) {
		return fileName
	}

	// 文件名冲突处理
	if c.config.Settings.ConflictResolution == "append_number" {
		for i := 1; i < 1000; i++ {
			fileName = fmt.Sprintf("%s_%d.%s", baseName, i, extension)
			fullPath = filepath.Join(targetDir, fileName)
			if _, err := os.Stat(fullPath); os.IsNotExist(err) {
				return fileName
			}
		}
	}

	return fileName
}

// createFromTemplate 从模板创建文件
func (c *Creator) createFromTemplate(filePath, templateName string) error {
	templatePath := filepath.Join(c.templateDir, templateName)

	// 检查模板是否存在
	if _, err := os.Stat(templatePath); os.IsNotExist(err) {
		// 模板不存在，创建空文件
		file, err := os.Create(filePath)
		if err != nil {
			return err
		}
		return file.Close()
	}

	// 复制模板文件
	return copyFile(templatePath, filePath)
}

// OpenFile 打开文件（使用系统默认应用）
func (c *Creator) OpenFile(filePath string) error {
	if !c.config.Settings.OpenAfterCreate {
		return nil
	}

	cmd := exec.Command("open", filePath)
	return cmd.Run()
}

// copyFile 复制文件
func copyFile(src, dst string) error {
	sourceFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer sourceFile.Close()

	destFile, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer destFile.Close()

	_, err = io.Copy(destFile, sourceFile)
	return err
}
