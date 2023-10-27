
<#Returns true if Microsoft Visual C++ 2015 Redistributable is installed.
This function will check both the regular Uninstall location as well as the
"Wow6432Node" location to ensure that both 32-bit and 64-bit locations are
checked for software installations.#>
function Is-Installed( $program ) {
    
  $script:x86 = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
      Where-Object { $_.GetValue( "DisplayName" ) -like "*$program*" } ).Length -gt 0;

  $script:x64 = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
      Where-Object { $_.GetValue( "DisplayName" ) -like "*$program*" } ).Length -gt 0;

  $global:output = $x86 -or $x64;


}


$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.61"
$session.Cookies.Add((New-Object System.Net.Cookie("s_fid", "5084813A4839D34A-2337F8E136FD7603", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("ORA_FPC", "id=b0d222cd-623d-49e4-8029-8497493fec0f", "/", "dev.mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("WTPERSIST", "", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("atgRecVisitorId", "10CBsEd7LXBbkwNlY3Tv0pZg9E-uC6dsAODe1wCIImPcnRQ0CBC", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("MySQL_S", "354sg6kgpcsc81k77dueq80drac5cufq", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("ak_bmsc", "1A6019ECEC911BE8E96DB737F54CAE3A~000000000000000000000000000000~YAAQivTVF5REZmyLAQAAMb76bBUgTkQ0p5l07G4xpixIEMhJV3pW/FT6yqT8ncY6WPXKbkeO+1nkPQ0xCbd5U908XOtIEs66NEOMLZhlhqmjiiAEPGZgrI6GKghISEyib76yuGh0lvrxz939ZIhGRiU0T9wSPe9SRCRSgHmvfEc8q6ZzJ1THWxSjmM3MTjT6ap5gcf2zMzH5jhWgrkfYtJUPq7LLWx24IBcYIC94Hi2EkARoLVOi6EIr4LSpGYLUbMXq2+Cvr2wN2e3ryyF8hA9HkdMLIy52+4MeVe8pCYBICro0zR5dMVAw1a3OfMixTFIBcs473XEW8U8k5MDQIeSecAu2Z2wstu/fe5LRIaor8kXdn8rMQvelFnJE+kYQPut1ft/xjXyv", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("TAsessionID", "a2998bbe-760b-447f-a407-0d5b0ba16812|NEW", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("gpw_e24", "no%20value", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("s_cc", "true", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("s_nr", "1698345248146-Repeat", "/", ".mysql.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("bm_sv", "A43EC1A4DE136D8A754587309129DF55~YAAQivTVF/YtcGyLAQAAQPlDbRVuSvFfPeSDositlMxwy7OpDEPV/U07xUXzJvTqej4cXgsun57RLPVp+0P4nTn1bopcMpGRGCJEOauIwPAbRYUx6PwhWrZM8kcHURBk0aX/T7Mx6QHKHJyN8f3G9r66EuolKG1Q+8Yaw32t6OrFFu5rR1Em4VwPcgk/otIxGgcg44IS6xEsPEFHBIqMS83yB9/B66XsAXIoKHmJjb6uGwq4jqullUqOABEFiu8=~1", "/", ".mysql.com")))
$html = Invoke-WebRequest -UseBasicParsing -Uri "https://dev.mysql.com/doc/relnotes/workbench/en/" `
-WebSession $session `
-Headers @{
"authority"="dev.mysql.com"
  "method"="GET"
  "path"="/doc/relnotes/workbench/en/"
  "scheme"="https"
  "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  "accept-encoding"="gzip, deflate, br"
  "accept-language"="en-US,en;q=0.9"
  "cache-control"="max-age=0"
  "referer"="https://www.bing.com/"
  "sec-ch-ua"="`"Chromium`";v=`"118`", `"Microsoft Edge`";v=`"118`", `"Not=A?Brand`";v=`"99`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "sec-fetch-dest"="document"
  "sec-fetch-mode"="navigate"
  "sec-fetch-site"="cross-site"
  "sec-fetch-user"="?1"
  "upgrade-insecure-requests"="1"
}




# Parse the HTML content
$parse = New-Object -ComObject "HTMLFile"
$parse.IHTMLDocument2_write($html.Content)


# Define the pattern
$pattern = "Changes in MySQL Workbench"

# Search for all <dt> elements in the HTML
$elements = $parse.getElementsByTagName('dt')

# Define the exclusion pattern
$exclusionPattern = "*Not released, General Availability*"

$inclusionPattern =  "*General Availability*"

# Filter the elements that start with the pattern
$filteredElements = $elements | Where-Object { $_.innerText.StartsWith($pattern) -and $_.innerText -notlike $exclusionPattern -and $_.innerText -like $inclusionPattern  }


# Initialize an empty array
$versionNumbers = @()

# Print the filtered elements and
# Extract and print the version numbers
$filteredElements | ForEach-Object { $versionNumber = $_.innerText -replace "Changes in MySQL Workbench ", "" -replace " .*", ""

# Add the version number to the array
$versionNumbers += $versionNumber

}

#Sort the version numbers and get the topmost one
$topVersionNumber = $versionNumbers | Sort-Object {[Version]$_} -Descending | Select-Object -First 1


$base_url = "https://cdn.mysql.com//Downloads/MySQLGUITools/mysql-workbench-community-{0}-winx64.msi"


$mysql_url_msi = $base_url -f $topVersionNumber

# Get the name of the file from the URL
$fileName = Split-Path -Path $mysql_url_msi -Leaf

$ProgressPreference = "silentlycontinue"


#alternative to invoke-webrequest is start-bitsTransfer
#start-bitsTransfer -Source $mysql_url_msi -destination ".\$filename"
$downloadPath = "$env:TEMP\$filename"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest -Uri $mysql_url_msi -OutFile "$downloadPath" 


# Define the parameter for the function
$program= "Microsoft Visual C++ 2019 Redistributable"

# Function call
Is-Installed $program

#Connect to Files, as CWIDrivers.
New-PSDrive -Name "Software" -Root "\\drive.byu.edu\Software" -PSProvider FileSystem

if ($output -ne "true") { #if Microsoft Visual C++ 2015 is not installed, the packets will be installed before installing Mysql workbench
    # Install Visual C++ 2015 packs 
    Start-Process -FilePath "\\drive.byu.edu\Software\MySQL\VC_redist.x64.exe" -ArgumentList "/quiet" -Wait -NoNewWindow
}

Start-Process "msiexec.exe" -ArgumentList "/qn /i $downloadPath" -Wait -NoNewWindow

#remove installer in temp folder
remove-item $downloadPath