#!/usr/bin/osascript

-- NewFileHere Finder 工具栏应用
-- 用于在当前 Finder 窗口创建新文件

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

-- 刷新 Finder 窗口
tell application "Finder"
    try
        set theWindow to front window
        set target of theWindow to (target of theWindow)
    end try
end tell
