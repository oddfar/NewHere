APP_NAME := NewHere
WORKFLOW_NAME := NewFileHere.workflow
DMG_NAME := NewHere_Installer.dmg
BUILD_DIR := build

.PHONY: all build app dmg clean

all: dmg

build:
	go build -o $(APP_NAME) main.go

app: build
	mkdir -p $(BUILD_DIR)/$(APP_NAME).app/Contents/MacOS
	cp $(APP_NAME) $(BUILD_DIR)/$(APP_NAME).app/Contents/MacOS/
	cp config.yaml $(BUILD_DIR)/$(APP_NAME).app/Contents/MacOS/
	# Copy workflow to build dir
	cp -r $(WORKFLOW_NAME) $(BUILD_DIR)/

dmg: app
	# Create a temporary directory for DMG contents
	mkdir -p $(BUILD_DIR)/dmg_root
	cp -r $(BUILD_DIR)/$(APP_NAME).app $(BUILD_DIR)/dmg_root/
	cp -r $(BUILD_DIR)/$(WORKFLOW_NAME) $(BUILD_DIR)/dmg_root/
	cp README.txt $(BUILD_DIR)/dmg_root/
	
	# Create DMG
	hdiutil create -volname "$(APP_NAME)" -srcfolder $(BUILD_DIR)/dmg_root -ov -format UDZO $(DMG_NAME)

clean:
	rm -rf $(APP_NAME) $(BUILD_DIR) $(DMG_NAME)
