<#
    Install script for the Sitecore Publishing Service

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

### Run installs

# Publishing Service
Install-SitecoreConfiguration @publish

# Sitecore
Install-SitecoreConfiguration @sitecoreCM
Install-SitecoreConfiguration @sitecoreCD
Install-SitecoreConfiguration @sitecoreCD2
