

# Unfortunately existing Invoke-RemoveServiceTask does not support
# matching multiples at the moment, so instead we wrap with our own
Function CustomRemoveService {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )

    Get-Service -Name $Name |
        ForEach-Object {
            Invoke-ManageServiceTask -Name $_.Name -Status Stopped
            Invoke-RemoveServiceTask -Name $_.Name
        }
}

# There are built in functions that already manage remove websites/app pools
Register-SitecoreInstallExtension -Command Remove-Website -As RemoveWebsite -Type Task
Register-SitecoreInstallExtension -Command Remove-WebAppPool -As RemoveWebAppPool -Type Task
# Built in function already manages cleaning up file system
Register-SitecoreInstallExtension -Command Remove-Item -As Remove -Type Task
# Custom remove service to enable removing all services in one call
Register-SitecoreInstallExtension -Command CustomRemoveService -As RemoveService -Type Task -Force
# Register SqlCmd
Register-SitecoreInstallExtension -Command Invoke-SqlCmd -As Sql -Type Task