<#
    Install script for a scaled instance on a single machine

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

### Run installs

# Certificate
Install-SitecoreConfiguration @cert

# Xconnect
Install-SitecoreConfiguration @xconnectSolr
Install-SitecoreConfiguration @xconnectCollection
Install-SitecoreConfiguration @xconnectCollectionSearch
Install-SitecoreConfiguration @xconnectMaReporting
Install-SitecoreConfiguration @xconnectMa
Install-SitecoreConfiguration @xconnectReference

# Sitecore
Install-SitecoreConfiguration @sitecoreSolr
Install-SitecoreConfiguration @sitecoreCM
Install-SitecoreConfiguration @sitecoreCD
Install-SitecoreConfiguration @sitecorePRC
Install-SitecoreConfiguration @sitecoreREP