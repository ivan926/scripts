osascript -e 'tell application "Finder" to set the clipboard to "https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=mac"
tell application "System Events"
    tell application "Safari" to activate
    keystroke "l" using {command down, option down}
    keystroke "v" using command down
    keystroke "enter" using command down
end tell'