#!/bin/bash

IP=""
Csv=1
City=""
Org=""
Asn=""
Ipcheck=""

#########################
# The command line help #
#########################

display_help() {
   echo
   echo "Usage: $0 [option...] [IpAdress] "
   echo
   echo "	-c, -csv, csv		display in CSV syntax"
   echo "	-h, -help, help		help info "
   echo
}

###############################
# The command ip_info display #
###############################

display_info() {
    if [[ $Csv == 1 ]]; then
	echo "Location: $City"
	echo "Organization: $Org"
	echo "ASN: $Asn"
    else
	echo "$City;$Org;$Asn"
    fi
    echo
}

##########################
# Check ip adress syntax #
##########################

check_ip() {
    if [[ $Ipcheck =~ ^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$ ]] ; then
	IP=$Ipcheck
    else
	echo "Error: $Ipcheck is not a valid IP address."
	exit 0
    fi
}

####################
# Argument handler #
####################

while(( "$#" )); do
    case "$1" in
        "-h"|"-help"|"help")
	    display_help
	    exit 0 ;;
        "-c"|"-csv"|"csv")
	    Csv=2;;
        *)
	    Ipcheck=$1;;
    esac
    shift
done

#####################################################
####################### MAIN ########################

if [[ $Ipcheck == "" ]]; then
    if [[ ! -t 0 ]]; then
        Ipcheck=($(< /dev/stdin))
    else
	exit 0
    fi
fi

check_ip

City=$(curl -s ip-api.com/json/$IP | grep -oP '("city":")[^"]*' | grep -o '[^"]*$')
Org=$(curl -s ip-api.com/json/$IP | grep -oP '("org":")[^"]*' | grep -o '[^"]*$')
Asn=$(curl -s ip-api.com/json/$IP | grep -oP '[A][S][0-9]*')

if [[ $City == "" ]] && [[ $Org == "" ]] && [[ $Asn == "" ]]; then
    Message=$(curl -s ip-api.com/json/$IP | grep -oP '("message":")[^"]*' | grep -o '[^"]*$')
    if [[ $Message=="reserved range" ]]; then
	echo "This ip-address is reserved."
	exit 0
    fi
fi

display_info

####################################################

exit 0
