### Find and run Uninstall
$Applications = 'Mendix 8*' #This is the only part of this snippit that you change. Everything else should remian the same

# Check for applications to remove
foreach($ApplicationName in $Applications)
{
    if ($ApplicationName) {  

        # Remove applications
        $programs = Get-WmiObject -class win32_product
        $success = $false

        foreach ($program in $programs) {
            if ($program.Name -match $ApplicationName) {
      
                # Remove applications using MSIEXEC by GUID
                $success = $true
                Write-Host "Removing:" $program.Name
                $msicode = $program.IdentifyingNumber
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $msicode /q" -Wait -NoNewWindow
            }
        }

        # Display a not found message
        if (-Not $success) {
            Write-Host "Software not found."
        }
    }
}