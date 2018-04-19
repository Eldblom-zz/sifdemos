#Requires -Version 3
param(
    [string]$SiteName = "sugcon_xp1.cm",	
	[string]$SiteHostHeaderName = "sugcon_xp1.cm",	
	[string]$SqlDbPrefix = $SiteName,
	[string]$CommerceSearchProvider = "SOLR"
)

$global:DEPLOYMENT_DIRECTORY=Split-Path $MyInvocation.MyCommand.Path
$modulesPath=( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "Modules" )
if ($env:PSModulePath -notlike "*$modulesPath*")
{
    $p = $env:PSModulePath + ";" + $modulesPath
    [Environment]::SetEnvironmentVariable("PSModulePath",$p)
}


$params = @{
        Path = Resolve-Path '.\Configuration\Commerce\Master_SingleServer.json'	
		SiteName = $SiteName
		SiteHostHeaderName = $SiteHostHeaderName 
		InstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$SiteName"
		XConnectInstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$($SiteName)_xconnect"
		CertificateName = $SiteName
		CommerceServicesDbServer = $($Env:COMPUTERNAME)    #OR "SQLServerName\SQLInstanceName"
		CommerceServicesDbName = "SitecoreCommerce9_SharedEnvironments"
		CommerceServicesGlobalDbName = "SitecoreCommerce9_Global"		
        SitecoreDbServer = $($Env:COMPUTERNAME)            #OR "SQLServerName\SQLInstanceName"
		SitecoreCoreDbName = "$($SqlDbPrefix)_Core"
		SitecoreUsername = "sitecore\admin"
		SitecoreUserPassword = "b"
		CommerceSearchProvider = $CommerceSearchProvider
		SolrUrl = "https://localhost:8983/solr"
		SolrRoot = "c:\\solr-6.6.2"
		SolrService = "Solr-6.6.2"
		SolrSchemas = ( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "SolrSchemas" )
		SearchIndexPrefix = ""
		AzureSearchServiceName = ""
		AzureSearchAdminKey = ""
		AzureSearchQueryKey = ""
		CommerceEngineDacPac = Resolve-Path -Path "..\Sitecore.Commerce.Engine.SDK.*\Sitecore.Commerce.Engine.DB.dacpac"	   
		CommerceOpsServicesPort = "5015"
		CommerceShopsServicesPort = "5005"
		CommerceAuthoringServicesPort = "5000"
		CommerceMinionsServicesPort = "5010"		
		SitecoreCommerceEngineZipPath = Resolve-Path -Path "..\Sitecore.Commerce.Engine.*.zip"		
		SitecoreBizFxServicesContentPath = Resolve-Path -Path "..\Sitecore.BizFX.*"		
		SitecoreIdentityServerZipPath = Resolve-Path -Path "..\Sitecore.IdentityServer.1.*.zip"
		CommerceEngineCertificatePath = Resolve-Path -Path "..\storefront.engine.cer"		
        SiteUtilitiesSrc = ( Join-Path -Path $DEPLOYMENT_DIRECTORY -ChildPath "SiteUtilityPages" )	
        HabitatImagesModuleFullPath = Resolve-Path -Path "..\Sitecore.Commerce.Habitat.Images-*.zip"	
        AdvImagesModuleFullPath = Resolve-Path -Path "..\Adventure Works Images.zip"	
        CommerceConnectModuleFullPath = Resolve-Path -Path "..\Sitecore Commerce Connect*.zip"	
        CEConnectPackageFullPath = Resolve-Path -Path "..\Sitecore.Commerce.Engine.Connect*.update"
        PowerShellExtensionsModuleFullPath = Resolve-Path -Path "..\Sitecore.PowerShell.Extensions.*\content\Sitecore PowerShell Extensions*.zip"
        SXAModuleFullPath = Resolve-Path -Path "..\Sitecore.Experience.Accelerator.*\content\Sitecore Experience Accelerator*.zip"
        SXACommerceModuleFullPath = Resolve-Path -Path "..\Sitecore Commerce Experience Accelerator 1.*.zip"
		SXAStorefrontModuleFullPath = Resolve-Path -Path "..\Sitecore Commerce Experience Accelerator Storefront 1.*.zip"
        SXAStorefrontThemeModuleFullPath = Resolve-Path -Path "..\Sitecore Commerce Experience Accelerator Storefront Themes*.zip"
		SXAStorefrontCatalogModuleFullPath = Resolve-Path -Path "..\Sitecore Commerce Experience Accelerator Storefront Habitat Catalog*.zip"
		MergeToolFullPath = Resolve-Path -Path "..\MSBuild.Microsoft.VisualStudio.Web.targets.14.0.0.3\tools\VSToolsPath\Web\Microsoft.Web.XmlTransform.dll"
		UserAccount = @{
			Domain = $Env:COMPUTERNAME
			UserName = 'CSFndRuntimeUser'
			Password = 'Pu8azaCr'
		}
		BraintreeAccount = @{
			MerchantId = ''
			PublicKey = ''
			PrivateKey = ''
		}
		SitecoreIdentityServerName = "SitecoreIdentityServer"		
    }

if ($CommerceSearchProvider -eq "SOLR") {
	Install-SitecoreConfiguration @params
}
elseif ($CommerceSearchProvider -eq "AZURE"){
	Install-SitecoreConfiguration @params -Skip InstallSolrCores
}