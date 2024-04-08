# Create a new COM object to interact with Windows Update
$updateSession = New-Object -ComObject Microsoft.Update.Session

# Create an Update Searcher object
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Configure to use your WSUS server (https://learn.microsoft.com/en-us/previous-versions/windows/desktop/aa387280(v=vs.85))
<#
typedef enum  { 
  ssDefault        = 0,
  ssManagedServer  = 1,
  ssWindowsUpdate  = 2,
  ssOthers         = 3
} ServerSelection;
#>
$updateSearcher.ServerSelection = 1

function Write-TimestampedVerbose {
    Param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Verbose "[$timestamp] $Message" -Verbose
}

Write-TimestampedVerbose "Connecting to the WSUS server for updates..."

# Search for updates
Write-TimestampedVerbose "Searching for available updates..."
$searchResult = $updateSearcher.Search("IsInstalled=0")

# Check if there are updates available
if ($searchResult.Updates.Count -gt 0) {
    Write-TimestampedVerbose ("Found {0} available updates." -f $searchResult.Updates.Count)
    
    # Loop through the available updates and display their details
    foreach ($update in $searchResult.Updates) {
        Write-TimestampedVerbose ("Update Title: {0}" -f $update.Title)
        Write-TimestampedVerbose ("Update Description: {0}" -f $update.Description)
        Write-TimestampedVerbose ("Update KB Article IDs: {0}" -f ($update.KBArticleIDs -join ', '))
        Write-TimestampedVerbose "---------------------------------"
    }
} else {
    Write-TimestampedVerbose "No updates are available."
}
