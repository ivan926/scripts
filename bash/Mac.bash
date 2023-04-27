#!/bin/bash
 
# Dialog Function
function msgBox() {
  osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon caution with title "$(basename $0)"
      ## icon 0=stop,icon 1=software,icon 2=caution
      return  -- Suppress result
    end tell
EOT
}
 
msgBox "Software has been installed. Please restart your computer!"