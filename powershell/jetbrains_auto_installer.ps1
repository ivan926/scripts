

$JSON_API_URL = "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" 

$response_JSON_Object = invoke-webrequest -URI "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | ConvertFrom-Json

$executable_URL = $response_JSON_Object.TBA.downloads.windows.link

Write-Output $executable_URL

$mac_path = "/tmp"

$windows_path = $env:Temp

Invoke-WebRequest -Uri $executable_URL -Out "$mac_path/jetbrains.exe" 

# Start-Process -FilePath "$full_path" -ArgumentList "/S /CONFIG=$path/mockConfig.txt" -NoNewWindow -Wait

Start-Process -FilePath "$mac_path" -ArgumentList "/S /CONFIG=$path/mockConfig.txt" -NoNewWindow -Wait  