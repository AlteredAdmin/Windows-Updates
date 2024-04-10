# Windows Update Management Scripts

## Script Details
### CheckForUpdates.ps1
This script connects to the configured WSUS server and checks for updates that are not yet installed on the system. It provides detailed information about each update, including the title, description, and associated KB article IDs.

### InstallWindowsUpdates.ps1
This script performs a check for available updates, downloads them if necessary, and then installs them. It provides detailed progress information and will indicate whether a system reboot is required after the updates are installed.

### AutoApprove-WSUSUpdatesForPRODGroups.ps1 ⚠️
This PowerShell script automates the approval of updates in WSUS for computer groups containing "PROD" in their name. 
It identifies updates older than 30 days and approves them for installation in the specified production groups. 
Please note that this script is experimental and should be thoroughly tested in a non-production environment before use in a production environment.

### WSUS_AutoApprove_DEV_to_PROD.ps1 ⚠️
This PowerShell script automates the approval of updates in Windows Server Update Services (WSUS) from the "DEV" group to groups containing "PROD" in their names. 
The script identifies updates approved for the "DEV" group and approves them for relevant "PROD" groups if the update is older than 30 days. Please note that this script is experimental.
