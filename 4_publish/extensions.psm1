Set-StrictMode -Version 2.0

Function Invoke-InstallPackageTask {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SiteFolder,
		[Parameter(Mandatory=$true)]
        [string]$SiteUrl,
		[Parameter(Mandatory=$true)]
        [string]$PackagePath
    )

    Write-TaskInfo "Installing Package $PackagePath" -Tag 'PackageInstall'

    #Generate a random 10 digit folder name. For security 
	$folderKey = -join ((97..122) | Get-Random -Count 10 | % {[char]$_})
	
	#Generate a Access Key (hi there TDS)
	$accessKey = New-Guid
	
	Write-TaskInfo "Folder Key = $folderKey" -Tag 'PackageInstall'
	Write-TaskInfo "Access Guid = $accessKey" -Tag 'PackageInstall'

	#The path to the source Agent.  Should be in the same folder as I'm running
	$sourceAgentPath = Resolve-Path "PackageInstaller.asmx"
	
	#The folder on the Server where the Sitecore PackageInstaller folder is to be created
	$packageInstallPath = [IO.Path]::Combine($SiteFolder, 'sitecore', 'PackageInstaller')
	
	#The folder where the actuall install happens
	$destPath = [IO.Path]::Combine($SiteFolder, 'sitecore', 'PackageInstaller', $folderKey)

	#Full path including the installer name
	$fullFileDestPath = Join-Path $destPath "PackageInstaller.asmx"
	
	Write-TaskInfo "Source Agent [$sourceAgentPath]" -Tag 'PackageInstall'
	Write-TaskInfo "Dest AgentPath [$destPath]" -Tag 'PackageInstall'

	#Forcibly cread the folder 
	New-Item -ItemType Directory -Force -Path $destPath

	#Read contents of the file, and embed the security token
	(Get-Content $sourceAgentPath).replace('[TOKEN]', $accessKey) | Set-Content $fullFileDestPath

	#How do we get to Sitecore? This URL!
	$webURI= "$siteURL/sitecore/PackageInstaller/$folderKey/packageinstaller.asmx?WSDL"
	 
	Write-TaskInfo "Url $webURI" -Tag 'PackageInstall'
	
	#Do the install here
	$proxy = New-WebServiceProxy -uri $webURI
	$proxy.Timeout = 1800000

	#Invoke our proxy
	$proxy.InstallZipPackage($PackagePath, $accessKey)

	#Remove the folderKey
	Remove-Item $packageInstallPath -Recurse -Force
}
Register-SitecoreInstallExtension -Command Invoke-InstallPackageTask -As InstallPackage -Type Task
Register-SitecoreInstallExtension -Command Expand-Archive -As ExpandArchive -Type Task
Register-SitecoreInstallExtension -Command Remove-Item -As Remove -Type Task
