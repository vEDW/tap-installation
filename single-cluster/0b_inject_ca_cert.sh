#!/bin/bash

if [ $# -ne 1 ]; then
    echo
    echo "N"
    
    exit 1 
else    
    SERVERURL="${1}"
fi

[ "$1" == "" ] && echo "usage: $0 <path to ca.crt file>"   && exit 1

CACRTFILE=$1
if [[ ! -e $CACRTFILE ]]; then
    echo "$CACRTFILE not present. stopping script"
    exit 1
fi

IFS= read -rd '' output < <(cat $CACRTFILE)
output=$output yq e '.shared.ca_cert_data = strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml