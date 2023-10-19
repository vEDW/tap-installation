#!/bin/bash

[ "$1" == "" ] || [ "$2" == "" ] && echo "usage: $0 <path to ca.crt file> <path to ca.key file>"   && exit 1

CACRTFILE=$1
if [[ ! -e $CACRTFILE ]]; then
    echo "$CACRTFILE not present. stopping script"
    exit 1
fi

CAKEYFILE=$2
if [[ ! -e $CAKEYFILE ]]; then
    echo "$CAKEYFILE not present. stopping script"
    exit 1
fi

IFS= read -rd '' output < <(cat $CACRTFILE)
yq e 'del(.accelerator.server.tls.crt)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
output=$output yq e '.accelerator.server.tls.crt |= strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
IFS= read -rd '' output < <(cat $CAKEYFILE)
yq e 'del(.accelerator.server.tls.key)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml
output=$output yq e '.accelerator.server.tls.key |= strenv(output)' tap-values.yaml > tmpfile && mv tmpfile tap-values.yaml

yq e tap-values.yaml

