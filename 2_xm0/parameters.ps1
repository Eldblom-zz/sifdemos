# General Args
$prefix                 = 'sugcon_xm0'
$configsRoot            = Join-Path $PSScriptRoot Configs
$packagesRoot           = Join-Path $PSScriptRoot Packages
$licenseFilePath        = Join-Path $PSScriptRoot '..\\license.xml'
$sqlServer              = '.'

### Sitecore ###

# Install Sitecore
$sitecoreStandalone = @{
    Path                = Join-Path $configsRoot sitecore-xm0.json
    Package             = Join-Path $packagesRoot 'Sitecore 9.0.1 rev. 171219 (OnPrem)_single.scwdp.zip'
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SiteName            = $prefix
    SqlServer           = $sqlServer
}