# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

$uninstallArgs = @{
    Path = Join-Path $configsRoot "uninstall.json"
    Prefix = $prefix
    SqlServer = $sqlServer
}

Install-SitecoreConfiguration @uninstallArgs