#!/bin/bash
#

source ./00-set-environment-variables.sh  

tanzu package installed update tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yaml -n tap-install