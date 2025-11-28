.PHONY: build clean run install dmg test

# 默认目标
all: build

# 编译程序
build:
	@echo "编译 NewFileHere..."
	@go build -o newfile cmd/newfile/main.go
	@echo "✓ 编译完成"

# 运行程序（在当前目录测试）
run: build
	@./newfile

# 测试（在临时目录测试）
test: build
	@echo "测试文件创建功能..."
	@mkdir -p /tmp/newfilehere_test
	@./newfile -dir /tmp/newfilehere_test
	@echo "✓ 测试完成"

# 清理构建文件
clean:
	@echo "清理构建文件..."
	@rm -f newfile
	@rm -rf build dist
	@echo "✓ 清理完成"

# 安装到本地（用于开发测试）
install: build
	@echo "安装到 /usr/local/bin..."
	@sudo cp newfile /usr/local/bin/
	@sudo cp config.yaml /usr/local/bin/
	@sudo cp -r templates /usr/local/bin/
	@echo "✓ 安装完成"

# 构建 DMG
dmg:
	@./scripts/build-dmg.sh

# 下载依赖
deps:
	@echo "下载 Go 依赖..."
	@go mod download
	@go mod tidy
	@echo "✓ 依赖下载完成"

# 格式化代码
fmt:
	@echo "格式化代码..."
	@go fmt ./...
	@echo "✓ 格式化完成"

# 代码检查
lint:
	@echo "运行代码检查..."
	@go vet ./...
	@echo "✓ 检查完成"

# 显示帮助信息
help:
	@echo "NewFileHere - Makefile 帮助"
	@echo ""
	@echo "可用命令："
	@echo "  make build    - 编译程序"
	@echo "  make run      - 编译并运行程序"
	@echo "  make test     - 测试程序功能"
	@echo "  make clean    - 清理构建文件"
	@echo "  make install  - 安装到本地（需要 sudo）"
	@echo "  make dmg      - 构建 DMG 安装包"
	@echo "  make deps     - 下载 Go 依赖"
	@echo "  make fmt      - 格式化代码"
	@echo "  make lint     - 代码检查"
	@echo "  make help     - 显示此帮助信息"
