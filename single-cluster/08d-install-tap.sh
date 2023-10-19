#!/bin/bash

# 08-install-tap.sh
#
# This scripts install TAP version $TAP_VERSION (defined in 00-set-environment-variables.sh).
# Configuration file tap-values.yaml should be populated with the correct configuration parameters.
#
# Run this script in the context of the Kubernetes cluster you're installing TAP to.
# Use kubectl config set-context to switch to correct cluster prior to running this script.
#

# Install TAP
#
source ./00-set-environment-variables.sh  

tanzu secret registry add registry-credentials --username $MY_REGISTRY --password $MY_REGISTRY_USER --server $MY_REGISTRY_PASSWORD --namespace default --export-to-all-namespaces

tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yaml -n tap-install