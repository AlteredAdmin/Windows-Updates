$searchQuery = "IsInstalled=0 and Type='Software' and IsHidden=0"

$Session = New-Object -ComObject Microsoft.Update.Session
$Search = $Session.CreateUpdateSearcher() 
$SearchResults = $Search.Search($searchQuery)



$SearchResults.Updates


$downloader = $Session.CreateUpdateDownloader()
$downloader.Updates = $SearchResults.Updates
$downloader.Download()


$Installer = $Session.CreateUpdateInstaller()
$Installer.Updates = $SearchResults.Updates
$Installer.Install()