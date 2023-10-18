#!/bin/bash

[ "$1" == "" ] && echo "usage: $0 <path to xx.crt file>"   && exit 1

CACRTFILE=$1
IFS= read -rd '' output < <(yq e '.shared.ca_cert_data' tap-values.yaml)
IFS= read -rd '' output2 < <(cat $CACRTFILE)
CACERTS=$(echo $output $output2)
output=$CACERTS yq e '.shared.ca_cert_data = strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
yq e '.shared.ca_cert_data' tap-values.yaml > ./certs-chain.crt