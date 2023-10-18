#!/bin/bash

[ "$1" == "" ] && echo "usage: $0 <path to ca.crt file>"   && exit 1

CACRTFILE=$1
if [[ ! -e $CACRTFILE ]]; then
    echo "$CACRTFILE not present. stopping script"
    exit 1
fi

IFS= read -rd '' output < <(cat $CACRTFILE)
yq e 'del(.shared.ca_cert_data)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
output=$output yq e '.shared.ca_cert_data |= strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
output=$output yq e '.appliveview_connector.backend.caCertData |= strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml

yq e '.shared.ca_cert_data' tap-values.yaml > ./certs-chain.crt
yq e tap-values.yaml