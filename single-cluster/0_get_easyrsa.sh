#!/bin/bash

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' |                                    # Pluck JSON value
    cut -d "v" -f 2
}


#checking if EasyRSA already exists
if [[ -e ../EasyRSA ]]; then
    echo "Easy-RSA folder already present. stopping script"
    exit
fi

# Github Releases
EASYRSARELEASE=`get_latest_release "OpenVPN/easy-rsa"`
echo "export EASYRSARELEASE=$EASYRSARELEASE"

REPONAME="OpenVPN/easy-rsa"

if [[ ${EASYRSARELEASE} == "" ]]; then
    EASYRSARELEASE=$(curl -s https://api.github.com/repos/$REPONAME/releases/latest | jq -r .tag_name)
fi

if [[ ${EASYRSARELEASE} == "null" ]]; then
    echo "github api rate limiting blocked request"
    echo "as an alternative, please set EASYRSARELEASE version in define_download_version_env"
    exit
fi

# EASYRSA cli
curl -s -LO https://github.com/OpenVPN/easy-rsa/releases/download/v$EASYRSARELEASE/EasyRSA-$EASYRSARELEASE.tgz 

tar -zxf EasyRSA-$EASYRSARELEASE.tgz  --directory=../
mv ../EasyRSA-$EASYRSARELEASE ../EasyRSA
rm EasyRSA-$EASYRSARELEASE.tgz

echo "EasyRSA downloaded and deployed at : ../EasyRSA"
