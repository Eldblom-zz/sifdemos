<#
    Install script for a scaled instance on a single machine

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

### Run installs

# Sitecore
Install-SitecoreConfiguration @sitecoreCD2

# Scalability
Install-SitecoreConfiguration @scalabilityCM
Install-SitecoreConfiguration @scalabilityCD
Install-SitecoreConfiguration @scalabilityCD2