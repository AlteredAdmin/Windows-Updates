# Stopping Windows Update Services
Stop-Service -Name BITS
Stop-Service -Name wuauserv
Stop-Service -Name appidsvc
Stop-Service -Name cryptsvc

# Remove QMGR Data file
Remove-Item "$env:allusersprofile\Microsoft\Network\Downloader\qmgr*.dat" -ErrorAction SilentlyContinue -Force

# Renaming the Software Distribution and CatRoot Folder
Remove-Item $env:systemroot\SoftwareDistribution.bak -Recurse -ErrorAction SilentlyContinue -Force
Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue -Force

# This may not work if the folder is locked by having a contained file being accessed
if($is64)
{
    Remove-Item $env:systemroot\sysnative\Catroot2.bak -Recurse -ErrorAction SilentlyContinue -Force
    Rename-Item $env:systemroot\sysnative\Catroot2 catroot2.bak -ErrorAction SilentlyContinue -Force
}
else
{
    Remove-Item $env:systemroot\System32\Catroot2.bak -Recurse -ErrorAction SilentlyContinue -Force
    Rename-Item $env:systemroot\System32\Catroot2 catroot2.bak -ErrorAction SilentlyContinue -Force
}


# Removing old Windows Update log
Remove-Item $env:systemroot\WindowsUpdate.log -ErrorAction SilentlyContinue -Force


Start-process -FilePath "sc.exe" -ArgumentList "sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)" -Wait
Start-process -FilePath "sc.exe" -ArgumentList "sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)" -Wait


# Registering some DLLs
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll

# Resetting the WinSock
netsh winsock reset
netsh winhttp reset proxy

# Delete all BITS jobs
Get-BitsTransfer | Remove-BitsTransfer

# Starting Windows Update Services
Start-Service -Name BITS
Start-Service -Name wuauserv
Start-Service -Name appidsvc
Start-Service -Name cryptsvc


# Forcing discovery
start-process -FilePath "wuauclt" -ArgumentList "/resetauthorization /detectnow" -Wait

Write-Host "Please reboot"