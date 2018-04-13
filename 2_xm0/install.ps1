<#
    Install script for XM Single

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

### Run installs

# Sitecore
Install-SitecoreConfiguration @sitecoreStandalone