#!/bin/bash

# 03-deploy-cluster-essentials.sh
#
# This script is only required for non-TKGm clusters (AKS, EKS, GKE, etc.). For vSphere /w Tanzu v7 it's also required to 
# install Cluster Essentials. vSphere /w Tanzu v8 TKG clusters have cluster essentials available out-of-the-box, so you can skip this step.
#
# Run this script in the context of the Kubernetes cluster you're planning to install TAP on.
# Use 'kubectl config set-context <kubernetes context>' to switch to correct cluster prior to running this script.
#
# Download Cluster Essentials from Tanzu Network at https://network.tanzu.vmware.com/
#
# For Linux:
# - Change download file to tanzu-cluster-essentials-linux-amd64-1.3.0.tgz
# 
source 00-set-environment-variables.sh  

tanzu package repository add tbs-full-deps-repository \
  --url ${MY_REGISTRY}/${MY_REGISTRY_INSTALL_REPO}/tbs-full-deps:${TBS_VERSION} \
  --namespace tap-install

tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v "${TBS_VERSION}" -n tap-install
