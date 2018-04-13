<#
    Install script for a scaled instance on a single machine

    All sitecore applications/services are installed on the current machine
    All databases on installed on the given SqlServer
#>

# General Args
$prefix                 = 'sugcon_xp1'
$configsRoot            = Join-Path $PSScriptRoot Configs
$packagesRoot           = Join-Path $PSScriptRoot Packages
$licenseFilePath        = Join-Path $PSScriptRoot "../license.xml"
$sqlServer              = '.'
$sitecoreVersion        = 'Sitecore 9.0.1 rev. 171219'
$instanceNames = @{
    Sitecore = @{
        Cd      = "${prefix}.cd"
        Cm      = "${prefix}.cm"
        Rep     = "${prefix}.rep"
        Prc     = "${prefix}.prc"
    }
    XConnect = @{
        Collection          = "${prefix}.xconnect.collection"
        CollectionSearch    = "${prefix}.xconnect.collectionsearch"
        Reference           = "${prefix}.xconnect.reference"
        MA                  = "${prefix}.xconnect.ma"
        MAReporting         = "${prefix}.xconnect.marep"
    }
}

### Certs ###

# Create XConnectCert
$cert = @{
    Path                = Join-Path $configsRoot xconnect-createcert.json
    CertificateName     = "${prefix}.xconnect"
    CertPath            = Join-Path $PSScriptRoot Certificates
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
    Path                = Join-Path $configsRoot sitecore-xp1-cm.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_cm.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    XConnectCert        = $cert.CertificateName
    SiteName            = $instanceNames.Sitecore.Cm
    SqlServer           = $sqlServer
    ProcessingService                       = "https://$($instanceNames.Sitecore.Prc)"
    ReportingService                        = "https://$($instanceNames.Sitecore.Rep)"
    XConnectCollectionSearchService         = "https://$($instanceNames.XConnect.CollectionSearch)"
    XConnectReferenceDataService            = "https://$($instanceNames.XConnect.Reference)"
    MarketingAutomationOperationsService    = "https://$($instanceNames.XConnect.MA)"
    MarketingAutomationReportingService     = "https://$($instanceNames.XConnect.MAReporting)"
}

# Install Sitecore CD
$sitecoreCD = @{
    Path                = Join-Path $configsRoot sitecore-xp1-cd.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_cd.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    XConnectCert        = $sitecoreCM.XConnectCert
    SiteName            = $instanceNames.Sitecore.Cd
    SqlServer           = $sqlServer
    XConnectCollectionService               = "https://$($instanceNames.XConnect.Collection)"
    XConnectReferenceDataService            = "https://$($instanceNames.XConnect.Reference)"
    MarketingAutomationOperationsService    = "https://$($instanceNames.XConnect.MA)"
    MarketingAutomationReportingService     = "https://$($instanceNames.XConnect.MAReporting)"
}

# Install Sitecore PRC - All interaction processing occurs here (live/historic)
$sitecorePRC = @{
    Path                = Join-Path $configsRoot sitecore-xp1-prc.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_prc.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    XConnectCert        = $sitecoreCM.XConnectCert
    SiteName            = $instanceNames.Sitecore.Prc
    SqlServer           = $sqlServer
    XConnectCollectionService               = "https://$($instanceNames.XConnect.Collection)"
}

# Install Sitecore REP - Stateless - endpoint to the reporting database
$sitecoreREP = @{
    Path                = Join-Path $configsRoot sitecore-xp1-rep.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_rep.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SqlDbPrefix         = $prefix
    SiteName            = $instanceNames.Sitecore.Rep
    SqlServer           = $sqlServer
}

### XConnect ###

# Configure XConnect Solr
$xconnectSolr = @{
    Path                = Join-Path $configsRoot xconnect-solr.json
    SolrRoot            = $sitecoreSolr.SolrRoot
    SolrService         = $sitecoreSolr.SolrService
    CorePrefix          = $prefix
}

# Install XConnect Collection - R/W endpoint for single contacts/interactions
$xconnectCollection = @{
    Path                = Join-Path $configsRoot xconnect-xp1-collection.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp1collection.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect.Collection
    SqlDbPrefix         = $prefix
    SqlServer           = $sqlServer
    XConnectCert        = $sitecoreCM.XConnectCert
}

# Install XConnect Collection Search - Listings of contacts/interactions / Query API - Service for XConnect indexer
$xconnectCollectionSearch = @{
    Path                = Join-Path $configsRoot xconnect-xp1-collectionsearch.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp1collectionsearch.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect.CollectionSearch
    SqlDbPrefix         = $prefix
    SolrCorePrefix      = $prefix
    SqlServer           = $sqlServer
    XConnectCert        = $sitecoreCM.XConnectCert
}

# Install XConnect MA Reporting - Service for querying MA info
$xconnectMAReporting = @{
    Path                = Join-Path $configsRoot xconnect-xp1-marketingautomationreporting.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp1marketingautomationreporting.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect.MAReporting
    SqlDbPrefix         = $prefix
    SqlServer           = $sqlServer
    XConnectCert        = $sitecoreCM.XConnectCert
}

# Install XConnect MA - Operations/Engine - Ops webservice API - Live application of goals etc - Engine (service) processes the queue
$xconnectMA = @{
    Path                = Join-Path $configsRoot xconnect-xp1-marketingautomation.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp1marketingautomation.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect.MA
    SqlDbPrefix         = $prefix
    SqlServer           = $sqlServer
    XConnectCert        = $sitecoreCM.XConnectCert
    XConnectCollectionService               = "https://$($instanceNames.XConnect.Collection)"
    XConnectReferenceDataService            = "https://$($instanceNames.XConnect.Reference)"
}

# Install XConnect ReferenceData - Store of actual data to trivialise lookups
$xconnectReference = @{
    Path                = Join-Path $configsRoot xconnect-xp1-referencedata.json
    Package             = Join-Path $packagesRoot "$sitecoreVersion (OnPrem)_xp1referencedata.scwdp.zip"
    LicenseFile         = $licenseFilePath
    SiteName            = $instanceNames.Xconnect.Reference
    SqlDbPrefix         = $prefix
    SqlServer           = $sqlServer
    XConnectCert        = $sitecoreCM.XConnectCert
}