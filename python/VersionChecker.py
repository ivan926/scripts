from tkinter import *
from tkinter.ttk import *
from tkinter import messagebox
import subprocess
import os
import sys

#subprocess equvialent but leaves out a letter, if other function is needed this string will be used
subprocessCommands = """
INTEL_LINK="https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=macM1"

echo $INTEL_LINK
URL=$(curl -L $INTEL_LINK | awk -F '\"' ' { for(i=1;i<NF;i++){ print $i} } ' | grep jetbrains | grep thanks | head -n 1)
sleep 10
echo $URL
echo "Should have ouput the"

open -j -g -u $URL
  




sleep 3
# close all tabs that were just opened
osascript -e 'tell application "firefox" to activate
tell application "System Events" to keystroke "w" using command down'
osascript -e 'tell application "Google Chrome"
	delete (every tab of every window where its title contains "Thank you for downloading the Toolbox App!")
end tell'

osascript -e 'tell application "Safari"
	delete (every tab of every window whose name = "Thank you for downloading the Toolbox App!")
end tell'

#give the curl command enough time to download the dmg file from website
sleep 10

#extract name of current DMG
DMG=$(ls ~/Downloads/ | grep jet | head -n 1)

echo $DMG

sleep 30


cd ~/Downloads/
echo "Removing potential xattr apple quarantine"
xattr -d com.apple.quarantine $DMG


    """

##############################################################################################################################################


master = Tk()


master.geometry('450x300')

#event listener function being called
def scanForLatestVersion():
    #messagebox.showinfo('Alert1',"I just wanted to know if you were alright?")
    result = subprocess.run(subprocessCommands,text=True,capture_output=True,shell=True)
    print("subProcess.run() function has ended")    

    result = subprocess.run("cd ~/Downloads; dmg=$(ls | grep jetbrain); echo $dmg ",text=True,capture_output=True,shell=True)

    dmg = result.stdout


    subprocess.run("cd ~/Downloads ; dmg=$(ls | grep jetbrain); rm $dmg ",shell=True)

    print("Current DMG version, ",dmg)

    return dmg



    #capture_output=True, text=True,shell=True)
    #print("stdout",result.stdout)



label = Label(master,text="Time to see if there is an update",font='sans 16 bold').place(x=120,y=50)


button = Button(master,text="initialize",command=scanForLatestVersion).place(x=180,y=100)

master.bind(button)


master.mainloop()

