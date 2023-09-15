#!/bin/bash
# Script to check the alias output. In big ru have to alias xpath to xpath -e
shopt -s expand_aliases

macVer=`sw_vers -productVersion`
reqVer="11.0.0"
if [ "$(printf '%s\n' "$reqVer" "$macVer" | sort -V | head -n1)" = "$reqVer" ]; then
        #They are running big sur or greater
        alias xpath='xpath -e'
fi

#Read-only JAMF Admin credentials to access computer information in the JAMF computer resource .xml
userName="readonly"
password="%7ujgVztC1jN9zO"


#Uses the Jamf API to query the computer site based on the serial number.
serial="$(ioreg -l | grep IOPlatformSerialNumber | sed -e 's/.*\"\(.*\)\"/\1/')"
echo "Serial Number is ${serial}"

#Pulls the computer Site based on the serial number
computerSite=`curl -H Accept:application/xml -s -u ${userName}:${password} https://byu.jamfcloud.com/JSSResource/computers/serialnumber/$serial/subset/general | xpath "//computer/general/site/name/text()"`
echo "Computer Site is $computerSite"

#The case statement will choose which code to provide based on which site it pulls from the API.
case $computerSite in
   "ASG") echo "Assigning to ASG"
   deployCode='2RXT3H44Z747'
   ;;
   "BYUB") echo "Assigning to BYUB"
   deployCode='XLSKAPYAYT5T'
   ;;
   "CFAC") echo "Assigning to CFAC"
   deployCode='YTTLARZXH3LR'
   ;;
   "CHEM") echo "Assigning to CHEM"
   deployCode='A5ZLZJSR7A5S'
   ;;
   "CSR-Common") echo "Assigning to CSR-Common"
   deployCode='LPSZ72W2LZ57'
   ;;
   "CTL") echo "Assigning to CTL"
   deployCode='SA2XYRPP4TRH'
   ;;
   "DCE") echo "Assigning to DCE" #They do not yet have a site within Jamf, but Kory set this up in case they use Jamf sometime in the future.
   deployCode='SL5ASSP4S44H'
   ;;
   "ECE") echo "Assigning to ECE"
   deployCode='4PH4K4THKWRH'
   ;;
   "FHSS") echo "Assigning to FHSS" 
   deployCode='K5JJLSL7APYZ'
   ;;
   "HBLL") echo "Assigning to HBLL"
   deployCode='S2HHYTT3X3Y3'
   ;;
   "HR") echo "Assigning to HR"
   deployCode='2RXT3H44Z747'
   ;;
   "Humanities") echo "Assigning to Humanities"
   deployCode='ZT2WHRR772R2'
   ;;
   "KennedyCenter") echo "Assigning to KennedyCenter" 
   deployCode='SWJYWY7RLS43'
   ;;
   "LAW") echo "Assigning to LAW"
   deployCode='44RHRHZXZ2AY'
   ;;
   "LFSCI") echo "Assigning to LFSCI"
   deployCode='WPLSJPKJKPW7'
   ;;
   "Math") echo "Assigning to Math" 
   deployCode='K5HXSYL5T2H5'
   ;;
   "MSM") echo "Assigning to MSM" 
   deployCode='TZYXYLTWSHYS'
   ;;
   "MSE") echo "Assigning to MSE" 
   deployCode='AXK7ARXJWSLX'
   ;;
   "CON") echo "Assigning to CON" 
   deployCode='H4LY54LPA5A3'
   ;;
   "OIT") echo "Assigning to OIT"
   deployCode='H55Z5J5S35TT'
   ;;
   "OIT-AV") echo "Assigning to OIT-AV"
   deployCode='523KWT3LW5A2'
   ;;
   "OIT-TS") echo "Assigning to OIT-Technology Support"
   deployCode='37JA3HTS4KHW'
   ;;
   "PandG") echo "Assigning to PandG" 
   deployCode='PTPYL44T5SYP'
   ;;
   "PFD") echo "Assigning to PFD" 
   deployCode='W3KRXHZ2WPTS'
   ;;
   "Physics") echo "Assigning to Physics" 
   deployCode='TP3TPWJZRKH2'
   ;;
   "PM") echo "Assigning to PM" 
   deployCode='W7ZHZL2PHHAW'
   ;;
   "Religion") echo "Assigning to Religion" 
   deployCode='KHY4HHX7X4J4'
   ;;
   "Risk") echo "Assigning to Risk" 
   deployCode='255YJLAWASZS'
   ;;
   "SOT") echo "Assigning to SOT" 
   deployCode='Z7KAXK3WLSPJ'
   ;;
   "SLC") echo "Assigning to SLC" 
   deployCode='SL5ASSP4S44H'
   ;;
   
   #Add all new sites above this line as the default will take any input from the computerSite variable.
   *) echo "Assigning to Default Deployment as no site was found" #This is the default that will catch everything that does not fall under another site.
   deployCode='AKTWXRLXKTAH'
   ;;
esac
  
echo "Done assigning site."

#Everything from here on down was taken from the software vendor.

# echo ./
#cp /Library/Application\ Support/JAMF/Waiting\ Room/Splashtop_Streamer_Mac_DEPLOY_INSTALLER.dmg ./
# cp /Library/Application\ Support/JAMF/Waiting\ Room/"$4" ./ # FIXME This is a problem

function usage()
{
    echo -e "Usage: `basename $1` [-i input streamer dmg file] [-d deploy code] [-a account based setting] [-w show deploy warning] ..."
    echo -e "\t-i : input streamer dmg file."
    echo -e "\t-d : deploy code."
    echo -e "\t-w : show deploy warning (0/1). (default 1)"
    echo -e "\t-n : computer name."
    echo -e "\t-s : show Streamer UI after installation (0/1). (default 1)"
    echo -e "\t-c : init security code."
    echo -e "\t-e : Require additional password to connect (0:off, 1:Require security code, 2:Require Mac login). (default 0)"
    echo -e "\t-r : Request permission to connect (0:off, 1:on)."
    echo -e "\t-l : loopback connection only (0/1). (default 0)"
    echo -e "\t-v : install/update driver (0/1). (default 1)"
    echo -e "\t-h : hide tray icon (0/1). (default 0)"
    echo -e "\t-b : default client name on connection bubble."
}

CHECK_NEED_DMG_IN="0"
CHECK_NEED_DEPLOY_CODE="0"
DEPLOY_CODE=""
COMPUTER_NAME=""
REQUEST_PERMISSION=""
INIT_SECURITY_CODE=""
SECURITY_OPTION=""
LOOPBACK_ONLY="0"
INSTALL_DRIVER="1" 
HIDE_TRAY_ICON="0"
DEFAULT_CLIENT_NAME=""

DMG_IN="$4"
CHECK_NEED_DMG_IN="1"

DEPLOY_CODE=$deployCode #Changed this to point to the case statement above instead of parameter 5 ($5)
CHECK_NEED_DEPLOY_CODE="1"

SHOW_DEPLOY_WARNING="0"

SHOW_STREAMER_UI="0"

#INSTALL_DRIVER="0"


if [ "$CHECK_NEED_DMG_IN" == "0" ]; then
echo "No input streamer dmg file!"
usage "$0"
exit 1
fi

#if [ "$CHECK_NEED_DEPLOY_CODE" == "0" ]; then
#echo "No deploy code!"
#usage "$0"
#exit 1
#fi

#write .PreInstall
echo "Inject settings"
mkdir /Users/Shared/SplashtopStreamer

echo "The no_driver flag = $INSTALL_DRIVER"

if [ "$INSTALL_DRIVER" == "0" ]; then
NO_DRIVER="/Users/Shared/SplashtopStreamer/.NoDriver"
touch "$NO_DRIVER"
echo "No driver being created"
fi

PRE_INSTALL="/Users/Shared/SplashtopStreamer/.PreInstall"
rm -rf $PRE_INSTALL
touch "$PRE_INSTALL"
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"              > "$PRE_INSTALL"
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> "$PRE_INSTALL"
echo "<plist version=\"1.0\">"                                 >> "$PRE_INSTALL"
echo "<dict>"                                                  >> "$PRE_INSTALL"

echo "    <key>UniversalSetting</key>"                         >> "$PRE_INSTALL"
if [ "$ACCOUNT_BASED_SETTING" == "1" ]; then
echo "        <false/>"                                        >> "$PRE_INSTALL"
else
echo "        <true/>"                                         >> "$PRE_INSTALL"
fi

echo "    <key>Common</key>"                                   >> "$PRE_INSTALL"
echo "        <dict>"                                          >> "$PRE_INSTALL"
echo "             <key>HidePreferenceDomainSelection</key>"   >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
echo "             <key>EulaAccepted</key>"                    >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
echo "        </dict>"                                         >> "$PRE_INSTALL"


echo "    <key>STP</key>"                                      >> "$PRE_INSTALL"
echo "        <dict>"                                          >> "$PRE_INSTALL"

if [ ! "$DEPLOY_CODE" == "" ]; then
echo "             <key>ShowDeployMode</key>"                  >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
echo "             <key>DeployCode</key>"                      >> "$PRE_INSTALL"
echo "                 <string>""$DEPLOY_CODE""</string>"      >> "$PRE_INSTALL"

echo "             <key>SplashtopAccount</key>"                >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
echo "             <key>DeployTeamNameCache</key>"             >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
echo "             <key>DeployTeamOwnerCache</key>"            >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
echo "             <key>LastDeployCode</key>"                  >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
echo "             <key>TeamCode</key>"                        >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
echo "             <key>TeamCodeInUse</key>"                   >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"

if [ "$COMPUTER_NAME" == "" ]; then
echo "             <key>HostName</key>"                        >> "$PRE_INSTALL"
echo "                 <string>""</string>"                    >> "$PRE_INSTALL"
fi

fi

echo "             <key>ShowDeployLoginWarning</key>"          >> "$PRE_INSTALL"
if [ "$SHOW_DEPLOY_WARNING" == "0" ]; then
echo "                 <false/>"                               >> "$PRE_INSTALL"
else
echo "                 <true/>"                                >> "$PRE_INSTALL"
fi

if [ ! "$COMPUTER_NAME" == "" ]; then
echo "             <key>HostName</key>"                        >> "$PRE_INSTALL"
echo "                 <string>""$COMPUTER_NAME""</string>"    >> "$PRE_INSTALL"
fi

if [ "$REQUEST_PERMISSION" == "1" ]; then
echo "             <key>EnablePermissionProtection</key>"      >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
fi
if [ "$REQUEST_PERMISSION" == "0" ]; then
echo "             <key>EnablePermissionProtection</key>"      >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
fi

if [ "$SECURITY_OPTION" == "0" ]; then
echo "             <key>EnableSecurityCodeProtection</key>"    >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
echo "             <key>EnableOSCredential</key>"              >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
fi

if [ "$SECURITY_OPTION" == "1" ]; then
echo "             <key>EnableSecurityCodeProtection</key>"    >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
echo "             <key>EnableOSCredential</key>"              >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
fi

if [ "$SECURITY_OPTION" == "2" ]; then
echo "             <key>EnableSecurityCodeProtection</key>"    >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
echo "             <key>EnableOSCredential</key>"              >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
fi

if [ ! "$INIT_SECURITY_CODE" == "" ]; then
echo "             <key>init_security_code</key>"              >> "$PRE_INSTALL"
echo "                 <string>""$INIT_SECURITY_CODE""</string>">> "$PRE_INSTALL"
fi

if [ "$LOOPBACK_ONLY" == "1" ]; then
echo "             <key>LegacyConnectionLoopbackOnly</key>"    >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
fi

if [ "$HIDE_TRAY_ICON" == "1" ]; then
echo "             <key>HideTrayIcon</key>"                    >> "$PRE_INSTALL"
echo "                 <true/>"                                >> "$PRE_INSTALL"
fi

if [ ! "$DEFAULT_CLIENT_NAME" == "" ]; then
echo "             <key>DefaultClientDeviceName</key>"         >> "$PRE_INSTALL"
echo "                 <string>""$DEFAULT_CLIENT_NAME""</string>">> "$PRE_INSTALL"
fi

if [ "$SHOW_STREAMER_UI" == "0" ]; then
echo "             <key>FirstTimeClose</key>"                  >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
echo "             <key>FirstTimeLogin</key>"                  >> "$PRE_INSTALL"
echo "                 <false/>"                               >> "$PRE_INSTALL"
fi

echo "        </dict>"                                         >> "$PRE_INSTALL"
echo "</dict>"                                                 >> "$PRE_INSTALL"
echo "</plist>"                                                >> "$PRE_INSTALL"

#mount dmg
echo "Mounting dmg file"
#download latest DMG from website?
cd /tmp 
curl -L -o splashtop.dmg https://my.splashtop.com/srs/mac 
hdiutil attach -nobrowse /tmp/splashtop.dmg

#make sure hidden uninstaller is removed if there is an older version or existing
if [ -d "/tmp/.uninstall_splashtop" ]; then
    rm -Rf "/tmp/.uninstall_splashtop"
    cp -Rf "/Volumes/SplashtopStreamer/Uninstall Splashtop Streamer.app" "/tmp/.uninstall_splashtop"
else
     cp -Rf "/Volumes/SplashtopStreamer/Uninstall Splashtop Streamer.app" "/tmp/.uninstall_splashtop"
fi


echo "Install silently"
NORMAL_INSTALLER="/Volumes/SplashtopStreamer/Splashtop Streamer.pkg"
HIDDEN_INSTALLER="/Volumes/SplashtopStreamer/.Splashtop Streamer.pkg"
if [ -f "$NORMAL_INSTALLER" ]; then
   installer -pkg "$NORMAL_INSTALLER" -target /
else
   installer -pkg "$HIDDEN_INSTALLER" -target /
fi

echo "Unmount dmg"
hdiutil detach /Volumes/SplashtopStreamer

#move uninstall application within the splashstreamers content folder
#cp -Rf "/tmp/Uninstall Splashtop Streamer.app/" "/Applications/Splashtop Streamer.app/Contents"

echo "Done!"

#rm ./Splashtop_Streamer_Mac_DEPLOY_INSTALLER.dmg
rm /tmp/splashtop.dmg

killall -zv Installer #This line is to eliminate the threads left by the installer as zombies. 

exit 0