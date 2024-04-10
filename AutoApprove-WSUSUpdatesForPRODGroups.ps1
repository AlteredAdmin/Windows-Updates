<#
Script Name: AutoApprove-WSUSUpdatesForPRODGroups.ps1

Description:
This PowerShell script automates the approval of updates in WSUS for computer groups containing "PROD" in their name. 
It identifies updates older than 30 days and approves them for installation in the specified production groups. 
Please note that this script is experimental and should be thoroughly tested in a non-production environment before use in a production environment.

#>

# Import WSUS Module
Import-Module -Name UpdateServices

# Define WSUS server name
$wsusServer = "WSUSServerName"

# Connect to WSUS server
$wsus = Get-WsusServer -Name $wsusServer

# Get all WSUS computer groups with "PROD" in their name
$targetGroups = Get-WsusComputerGroup -UpdateServer $wsus | Where-Object { $_.Name -match "PROD" }

# Get updates older than 30 days
$olderThanDate = (Get-Date).AddDays(-30)

# Get all updates older than 30 days
$updates = Get-WsusUpdate -UpdateServer $wsus -Approval Unapproved | Where-Object {$_.CreationDate -lt $olderThanDate}

foreach ($update in $updates) {
    # Check if the update is applicable to any of the target groups
    foreach ($targetGroup in $targetGroups) {
        if ($update.IsInstallable($targetGroup)) {
            Write-Host "Approving update $($update.Title) for group $($targetGroup.Name)"
            # Approve the update for the target group
            Approve-WsusUpdate -Update $update -Action Install -TargetGroupName $targetGroup.Name -UpdateServer $wsus
        }
    }
}

Write-Host "Auto-approval process completed."
