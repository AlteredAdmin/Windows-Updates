# Function to log with timestamps
function Log-Message {
    param (
        [string]$Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Log-Message "Starting Windows Update process..."

# Create a COM object for the Windows Update Session
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()

Log-Message "Searching for available updates..."
$searchResult = $updateSearcher.Search("IsInstalled=0")

if ($searchResult.Updates.Count -eq 0) {
    Log-Message "No updates found."
} else {
    Log-Message "$($searchResult.Updates.Count) update(s) found."

    # Create a collection to hold the updates to download
    $updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl

    foreach ($update in $searchResult.Updates) {
        Log-Message "Found update: $($update.Title)"
        $updatesToDownload.Add($update) | Out-Null
    }

    # Download updates
    Log-Message "Downloading updates..."
    $downloader = $updateSession.CreateUpdateDownloader()
    $downloader.Updates = $updatesToDownload
    $downloadResult = $downloader.Download()

    # Check download result
    if ($downloadResult.ResultCode -eq 2) {
        Log-Message "Updates downloaded successfully."

        # Create a collection for updates to be installed
        $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl

        foreach ($update in $updatesToDownload) {
            Log-Message "Preparing to install: $($update.Title)"
            $updatesToInstall.Add($update) | Out-Null
        }

        # Install updates
        Log-Message "Installing updates..."
        $installer = $updateSession.CreateUpdateInstaller()
        $installer.Updates = $updatesToInstall
        $installResult = $installer.Install()

        # Check install result
        if ($installResult.ResultCode -eq 2) {
            Log-Message "Updates installed successfully."
        } else {
            Log-Message "Failed to install some updates."
        }
    } else {
        Log-Message "Failed to download updates."
    }
}

Log-Message "Windows Update process completed."


##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################


# # Create a new COM object to interact with Windows Update
# $updateSession = New-Object -ComObject Microsoft.Update.Session

# # Create an Update Searcher object
# $updateSearcher = $updateSession.CreateUpdateSearcher()

# # Configure to use your WSUS server (https://learn.microsoft.com/en-us/previous-versions/windows/desktop/aa387280(v=vs.85))
# <#
# typedef enum  { 
#   ssDefault        = 0,
#   ssManagedServer  = 1,
#   ssWindowsUpdate  = 2,
#   ssOthers         = 3
# } ServerSelection;
# #>
# $updateSearcher.ServerSelection = 1

# function Write-TimestampedVerbose {
#     Param ([string]$Message)
#     $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#     Write-Verbose "[$timestamp] $Message" -Verbose
# }

# Write-TimestampedVerbose "Connecting to the WSUS server for updates..."

# # Search for updates
# Write-TimestampedVerbose "Searching for available updates..."
# $searchResult = $updateSearcher.Search("IsInstalled=0 and IsHidden=0")

# # Check if there are updates available
# if ($searchResult.Updates.Count -gt 0) {
#     Write-TimestampedVerbose ("Found {0} available updates." -f $searchResult.Updates.Count)
    
#     # Create a collection of updates to download
#     $updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
#     foreach ($update in $searchResult.Updates) {
#         if ($update.EulaAccepted -eq $false) {
#             $update.AcceptEula()
#         }
#         $updatesToDownload.Add($update) | Out-Null
#     }

#     # Download the updates
#     $downloader = $updateSession.CreateUpdateDownloader()
#     $downloader.Updates = $updatesToDownload
#     Write-TimestampedVerbose "Downloading updates..."
#     $downloadResult = $downloader.Download()

#     # Check the download result
#     if ($downloadResult.ResultCode -eq 2) {
#         Write-TimestampedVerbose "All updates downloaded successfully."

#         # Create a collection of updates to install
#         $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
#         foreach ($update in $searchResult.Updates) {
#             $updatesToInstall.Add($update) | Out-Null
#         }

#         # Install the updates
#         $installer = $updateSession.CreateUpdateInstaller()
#         $installer.Updates = $updatesToInstall
#         Write-TimestampedVerbose "Installing updates..."
#         $installationResult = $installer.Install()

#         # Output the installation result
#         Write-TimestampedVerbose ("Installation Result Code: {0}" -f $installationResult.ResultCode)

#         # Check if installation was successful
#         if ($installationResult.ResultCode -eq 2) {
#             # Count is not working, this needs to be fixed, it keeps reporting 0 i think .count is not correct. 
#             Write-TimestampedVerbose ("Number of updates successfully installed: {0}" -f $installationResult.updates.Count)
#         } else {
#             Write-TimestampedVerbose "Installation of some updates failed."
#         }

#         if ($installationResult.RebootRequired -eq $true) {
#             Write-TimestampedVerbose "A reboot is required to complete the installation of some updates."
#         }
#     } else {
#         Write-TimestampedVerbose "Some updates could not be downloaded."
#     }
# } else {
#     Write-TimestampedVerbose "No updates are available."
# }