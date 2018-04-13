# Some utility functions to help in the script
Function ModuleAbsent ($Name){
    return $null -eq (Get-InstalledModule -Name $Name -ErrorAction SilentlyContinue)
}

# Ensure the nuget package provider is installed
Get-PackageProvider -Name Nuget -ForceBootstrap

if(ModuleAbsent SqlServer){
    Install-Module -Name SqlServer -Repository PSGallery -Force
}