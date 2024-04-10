<#
Script Name: WSUS_AutoApprove_DEV_to_PROD.ps1

Description: This PowerShell script automates the approval of updates in Windows Server Update Services (WSUS) from the "DEV" group to groups containing "PROD" in their names. 
The script identifies updates approved for the "DEV" group and approves them for relevant "PROD" groups if the update is older than 30 days. Please note that this script is experimental.

#>

# WSUS Server Configuration
$wsusServerName = "WSUSServerName"
$wsusPort = "8530" # Change if using a different port
$wsusServer = Get-WsusServer -Name $wsusServerName -PortNumber $wsusPort

# Get all updates approved for the "DEV" group
$devGroupUpdates = Get-WsusUpdateApproval -UpdateScope All -Action Approved -TargetGroupName "DEV" -WsusServer $wsusServer

# Define the approval deadline (30 days)
$approvalDeadline = (Get-Date).AddDays(-30)

# Approve updates for groups containing "PROD" in their names if older than 30 days
foreach ($update in $devGroupUpdates) {
    $updateSummary = Get-WsusUpdateSummary -Update $update.Update -ApprovalState Approved -WsusServer $wsusServer
    $approvalDate = $updateSummary.FirstApprovedDate

    if ($approvalDate -lt $approvalDeadline) {
        $prodGroups = Get-WsusComputerTargetGroup -WsusServer $wsusServer | Where-Object { $_.Name -like "*PROD*" }

        foreach ($prodGroup in $prodGroups) {
            Write-Host "Approving update $($update.Update.Title) for $($prodGroup.Name)"
            Approve-WsusUpdate -Update $update.Update -ComputerTargetGroup $prodGroup -WsusServer $wsusServer
        }
    }
}

Write-Host "Update approvals completed."
