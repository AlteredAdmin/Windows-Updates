# Windows Update Management Scripts

## Script Details
### CheckForUpdates.ps1
This script connects to the configured WSUS server and checks for updates that are not yet installed on the system. It provides detailed information about each update, including the title, description, and associated KB article IDs.

### InstallWindowsUpdates.ps1
This script performs a check for available updates, downloads them if necessary, and then installs them. It provides detailed progress information and will indicate whether a system reboot is required after the updates are installed.