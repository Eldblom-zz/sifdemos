<#
    Install script for a non-scaled XP instance on a single machine

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

### Run installs

# Xconnect
Install-SitecoreConfiguration @xconnectSolr
Install-SitecoreConfiguration @xconnect

# Sitecore
Install-SitecoreConfiguration @sitecoreSolr
Install-SitecoreConfiguration @sitecore
