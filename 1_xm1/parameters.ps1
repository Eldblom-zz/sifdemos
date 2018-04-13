# General Args
$prefix                 = 'sugcon_xm1'
$configsRoot            = Join-Path $PSScriptRoot Configs
$packagesRoot           = Join-Path $PSScriptRoot Packages
$licenseFilePath        = Join-Path $PSScriptRoot '..\\license.xml'
$sqlServer              = '.'
$instanceNames = @{
    Sitecore = @{
        Cd      = "${prefix}.cd"
        Cm      = "${prefix}.cm"
    }
}

### Sitecore ###

# Configre Sitecore Solr
$sitecoreSolr = @{
    Path                = Join-Path $configsRoot sitecore-solr.json
    SolrRoot            = 'C:\Solr'
    SolrService         = 'Solr'
    CorePrefix          = $prefix
}

# Install Sitecore CM
$sitecoreCM = @{
    Path                = Join-Path $configsRoot sitecore-xm1-cm.json
    Package             = Join-Path $packagesRoot 'Sitecore 9.0.1 rev. 171219 (OnPrem)_cm.scwdp.zip'
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SiteName            = $instanceNames.Sitecore.Cm
    SqlServer           = $sqlServer
}

# Install Sitecore CD
$sitecoreCD = @{
    Path                = Join-Path $configsRoot sitecore-xm1-cd.json
    Package             = Join-Path $packagesRoot 'Sitecore 9.0.1 rev. 171219 (OnPrem)_cd.scwdp.zip'
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SiteName            = $instanceNames.Sitecore.Cd
    SqlServer           = $sqlServer
}