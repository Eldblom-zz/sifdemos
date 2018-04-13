# General Args
$prefix                 = 'sugcon_xm1'
$configsRoot            = Join-Path $PSScriptRoot Configs
$sqlServer              = '.'

$sitecoreSolr = @{
    SolrRoot            = 'C:\Solr'
    SolrService         = 'Solr'
}