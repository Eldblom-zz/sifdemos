* Remove all cert part in sitecore-xp0.json
* Remove all cert part in xconnect-xp0.json
* Change binding to http in xconnect
* Disable
    * sc.XConnect.Security.EnforceSSL.xml
    * sc.XConnect.Security.EnforceSSLWithCertificateValidation.xml

appSetting AllowInvalidClientCertificates=true
remove connectionstrings

Change xconnect to port 8888

StartFiddler
