# General Args
$prefix                 = 'sugcon_xm1'
$configsRoot            = Join-Path $PSScriptRoot Configs
$packagesRoot           = Join-Path $PSScriptRoot Packages
$licenseFilePath        = Join-Path $PSScriptRoot '..\\license.xml'
$sqlServer              = '.'
$redisUrl               = "127.0.0.1:6379"
$instanceNames = @{
    Cm      = "${prefix}.cm"
    Cd      = "${prefix}.cd"
    Cd2     = "${prefix}.cd2"
}

$binding = "${prefix}.cd"
$port = "81"

# Install Sitecore CD2
$sitecoreCD2 = @{
    Path                = Join-Path $configsRoot sitecore-xm1-cd2.json
    Package             = Join-Path $packagesRoot 'Sitecore 9.0.1 rev. 171219 (OnPrem)_cd.scwdp.zip'
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SiteName            = $instanceNames.Cd2
    SiteBinding         = $binding
    SitePort            = $port
    SqlServer           = $sqlServer
}

# Configure scalability on CM
$scalabilityCM = @{
    Path                = Join-Path $configsRoot sitecore-XM1-scalability.json
    RedisUrl            = $redisUrl
    SiteName            = $instanceNames.Cm
    RoleType            = 'cm'
}

# Configure scalability on CD
$scalabilityCD = @{
    Path                = Join-Path $configsRoot sitecore-xm1-scalability.json
    RedisUrl            = $redisUrl
    SiteName            = $instanceNames.Cd
    RoleType            = 'cd'
}

# Configure scalability on CD2
$scalabilityCD2 = @{
    Path                = Join-Path $configsRoot sitecore-xm1-scalability.json
    RedisUrl            = $redisUrl
    SiteName            = $instanceNames.Cd2
    RoleType            = 'cd'
}