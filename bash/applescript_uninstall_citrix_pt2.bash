#!/usr/bin/osascript

tell application "System Events"
	tell process "Uninstall Citrix Workspace"
		click button "Quit" of window "Uninstall Citrix Workspace"
	end tell
end tell




    #   sudo osascript -e '
    #         tell application "System Events"
    #                 tell process "Uninstall Citrix Workspace" 
    #                     click button "Continue" of window "Uninstall Citrix Workspace"
    #                 end tell
    #         end tell
            
    #         tell application "System Events"
	#             tell process "Uninstall Citrix Workspace"
	# 	            click button "Quit" of window "Uninstall Citrix Workspace"
	#             end tell
    #         end tell
    #         '