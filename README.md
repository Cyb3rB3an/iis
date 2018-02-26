# iis
Windows IIS Configuration checker and analysis

The following script extracts information from the IIS config.
To extract the IIS config: %windir%\system32\inetsrv\appcmd list site /config /xml > <filename>

This tools extracts and displays the Site name and bindings from the config filename
With the bindings an IP lookup is performed and an NMAP is completed over port 80 & 443 to try and determine the website type and version

Usage:
./iis.sh <filename>

Tested in IIS7.5 and 8 
