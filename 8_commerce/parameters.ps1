<#
    Install script for a scaled instance on a single machine

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# General Args
$prefix                 = 'sugcon_xpdev'
$configsRoot            = Join-Path $PSScriptRoot Configs
$packagesRoot           = Join-Path $PSScriptRoot Packages
$licenseFilePath        = Join-Path $PSScriptRoot "../license.xml"
$sqlServer              = '.'
$sitecoreVersion        = 'Sitecore 9.0.1 rev. 171219'
$instanceNames = @{
    Sitecore = "${prefix}"
    XConnect = "${prefix}.xconnect"
}
$solr = @{
    Root            = 'C:\Solr'
    Service         = 'Solr'
}


### Sitecore ###

# Configre Sitecore Solr
$sitecoreSolr = @{
    Path                = Join-Path $configsRoot sitecore-solr.json
    SolrRoot            = $solr.Root
    SolrService         = $solr.Service
    CorePrefix          = $prefix
}

# Install Sitecore
$sitecore = @{
    Path                = Join-Path $configsRoot sitecore-xp0.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_single.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SiteName            = $instanceNames.Sitecore
    SqlServer           = $sqlServer
    XConnectCollectionService  = "http://$($instanceNames.XConnect)"
}

### XConnect ###

# Configure XConnect Solr
$xconnectSolr = @{
    Path                = Join-Path $configsRoot xconnect-solr.json
    SolrRoot            = $solr.Root
    SolrService         = $solr.Service
    CorePrefix          = $prefix
}

# Install XConnect
$xconnect = @{
    Path                = Join-Path $configsRoot xconnect-xp0.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp0xconnect.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SqlServer           = $sqlServer
}