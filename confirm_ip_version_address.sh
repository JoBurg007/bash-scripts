#!/usr/bin/bash

## Title...............: confirm_ip_version_address.sh
## Description.........: Decision on IP version and IP address upon user requests
##                       including variable initialization for the continued application.
## Version.............: 1.0
## Author..............: Paul Münzner
## License.............: MIT LICENSE
## Tested with...
## ... Bash Version....: 5.0 or later
## ... Ubuntu Version..: Ubuntu 20.04.4 LTS

echo ""
echo ""
echo "###########################################"
echo "#             ###############             #"
echo "#              START PROCESS              #"
echo "#                #########                #"
echo "###########################################"
# Declare sleep duration for better user experience
declare sleep=3
echo ""
echo ""
echo "###########################################"
echo "#           Request IP Version            #"
echo "###########################################"
echo ""
echo ""
echo "Select your preferred IP version you like to use for the following setup."
echo "Enter 1 for IPv4 or 2 for IPv6."
select yn in "IPv4" "IPv6" "Don't know!"; do
    case $yn in
    IPv4)
        echo "You selected IPv4."
        declare ipversion="IPv4"
        break
        ;;
    IPv6)
        echo "Great choice! You selected IPv6; the successor of IPv4."
        declare ipversion="IPv6"
        break
        ;;
    "Don't know!")
        echo "You cannot continue without knowing your preferred IP version! Research the web and or check this page: https://www.thousandeyes.com/learning/techtorials/ipv4-vs-ipv6. We need to abort now!"
        exit 1
        ;;
    esac
done
echo ""
echo ""
echo "###########################################"
echo "#          Check IPv6 Availability        #"
echo "###########################################"
echo ""
echo ""
# Check if IPv6/IPv4 is enabled in case IPv6/IPv4 has been selected above. If not, abort.
if [ $ipversion == "IPv4" ]; then
    echo "Checking IPv4 address..."
    sleep $sleep
    declare ipaddress=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')
elif [ $ipversion == "IPv6" ]; then
    echo "Checking if IPv6 is enabled on this system..."
    sleep $sleep
    if (test -f /proc/net/if_inet6); then
        echo "IPv6 supported"
        declare ipaddress=$(ip -6 addr | awk '{print $2}' | grep -P '^(?!fe80)[[:alnum:]]{4}:.*/64' | cut -d '/' -f1)
    else
        echo "IPv6 not supported. Execution stopped. Start again and select another IP version or enable IPv6 on your and start this process again."
        exit 1
    fi
else
    echo "Sorry! Exit due to error!"
    exit 1
fi
echo ""
echo ""
echo "###########################################"
echo "#               Verify Address            #"
echo "###########################################"
echo ""
echo ""
echo "Is your $ipversion address $ipaddress correct?"
select yn in "Yes" "No" "Don't know!"; do
    case $yn in
    Yes)
        echo "$ipversion address confirmed. Your address $ipaddress will be used for the following setup."
        declare correctipaddress=true
        break
        ;;
    No)
        declare correctipaddress=false
        break
        ;;
    "Don't know!")
        echo "You better should know your correct $ipversion address. Please contact your provider or admin and start this process again. Execution stopped!"
        exit 1
        ;;
    esac
done
#
# Get correct ip addresses if correctipaddress set to false
if [ $correctipaddress == false ]; then
    echo "Enter your correct $ipversion address now:"
    read typed
    declare ipaddress=$typed
fi
echo ""
echo ""
echo "###########################################"
echo "#               Confirm Result            #"
echo "###########################################"
echo ""
echo ""
echo "Setup will be continued with $ipversion address $ipaddress?"
select yn in "Yes" "No"; do
    case $yn in
    Yes)
        echo "Setup will be continued with $ipversion address $ipaddress!"
        break
        ;;
    No)
        echo "We cannot continue with your $ipversion address $ipaddress if you select 'No'. Process stopped now!"
        exit 1
        ;;
    esac
done
echo ""
echo ""
echo "###########################################"
echo "#   Available Variables For Further Use   #"
echo "#         IP version -> $ipversion        #"
echo "#         IP address -> $ipaddress        #"
echo "###########################################"
echo ""
echo ""
echo "###########################################"
echo "#                #########                #"
echo "#               END PROCESS               #"
echo "#             ###############             #"
echo "###########################################"
echo ""
echo ""
exit 0
