
NAMECHEAP_USERNAME=
NAMECHEAP_API_USERNAME=
DOMAIN_SLD=omnicorp
DOMAIN_TLD=online
# NAMECHEAP_API_KEY
MY_IP=$(curl icanhazip.com)

if ["$NAMECHEAP_API_KEY" == ""]; then
    echo "Enter Namecheap API key:"
    read NAMECHEAP_API_KEY
fi

https://<service url>/xml.response?ApiUser=<api_username>&ApiKey=$NAMECHEAP_API_KEY&UserName=<nc_username>&Command=<cmd_name>&ClientIp=MY_IP\
&Command=namecheap.domains.dns.setCustom&SLD=$DOMAIN_SLD&TLD=$DOMAIN_TLD&NameServers=dns1.name-servers.com,dns2.name-servers.com
