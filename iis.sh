##################################################################################################################################################
# IIS Configuration checker and analysis
# by Cyb3rB3an
# Twitter feed: @Cyb3rB3an 
#
# The following script extracts information from the IIS config.
# To extract the IIS config: %windir%\system32\inetsrv\appcmd list site /config /xml > c:\sites.xml
#
# This tools extracts the Site name and bindings from the config filename
# With the bindings an IP lookup is performed and an NMAP is completed over port 80 & 443 to try and determine the website type and version
#
# Usage:
# ./iis.sh <filename>
#
# Tested in IIS7.5 and 8 
#
##################################################################################################################################################


# Checks file parameter is present 
if [ "$#" -ne 1 ]; then
    echo -e "\e[31m--------------------------------------"
    echo -e "Illegal number of parameters"
    echo -e "Format needs to be iis.sh <filename>"
    echo -e "--------------------------------------"

exit 0
fi

# reads filename

iisinput=$1

echo -e "\e[32m----------------"
echo -e "IIS Script"
echo -e "----------------"
echo -e "\e[39m"

#IIS basic info Site and bindings"
echo -e "\e[32m----------------"
echo -e "Sites and Bindings"
echo -e "----------------"
echo -e "\e[39m"

iisextract=($(grep 'site name\|bindingInformation' $iisinput))
extracttotal=${#iisextract[@]}


for ((i = 0; i != extracttotal; i++)); do
   echo -e "${iisextract[i]}" | grep 'name=\|bindingInformation'
done


#IIS basic info Site and bindings
echo -e "\e[32m"
echo -e "----------------------------------------------------"
echo -e "Bindings to public ip lookup"
echo -e "webserver (port 80/443) version lookup with nmap -sV"
echo -e "----------------------------------------------------"
echo -e "\e[39m"

#DNS and NMAP 
urllist=($(grep 'bindingInformation' $iisinput | cut -d ":" -f 3 | grep -v -e '^[[:space:]]*$'cat $iisinput | grep 'bindingInformation' | cut -d ":" -f 3 | cut -d '"' -f 1 | cut -d "=" -f 2 | grep -v -e '^[[:space:]]*$'))
urltotal=${#urllist[@]}

for ((i = 0; i != urltotal; i++)); do
   echo -e "---------------------------------------"
   echo -e "\e[33m${urllist[i]}\e[39m"
   dig +short ${urllist[i]}
   nmap -p 80,443 -sV ${urllist[i]} |grep /tcp
   echo -e "----------------------------------------"
   echo -e ""
done
