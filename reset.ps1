Get-ChildItem *.log -Recurse | Remove-Item
. redis-cli FLUSHALL