#!/bin/bash

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' |                                    # Pluck JSON value
    cut -d "v" -f 2
}

#checking if EasyRSA already exists
if [[ ! -e ../EasyRSA ]]; then
    echo "Easy-RSA folder not present. stopping script"
    exit
fi

if [[ -e ../EasyRSA/pki ]]; then
    echo "Easy-RSA/pki folder present. stopping script"
    exit
fi

# create vars file


echo "Enter Country Code [US]"
read -r EASYRSA_REQ_COUNTRY
echo
echo "Enter Province Code [California]"
read -r EASYRSA_REQ_PROVINCE
echo
echo "Enter City Code [San Francisco]"
read -r EASYRSA_REQ_CITY
echo
echo "Enter ORG Code [MyORG]"
read -r EASYRSA_REQ_ORG
echo
echo "Enter email Code [spam@myorg.com]"
read -r EASYRSA_REQ_EMAIL
echo
echo "Enter Organisation Unit Code [Engineering]"
read -r EASYRSA_REQ_OU
echo


# init Easy-RSA
cd ../EasyRSA*
./easyrsa init-pki

echo "" >> pki/vars


echo 'set_var EASYRSA_DN	"org"'  >> pki/vars

echo 'set_var EASYRSA_REQ_COUNTRY	"'${EASYRSA_REQ_COUNTRY}'"' >> pki/vars
echo 'set_var EASYRSA_REQ_PROVINCE	"'${EASYRSA_REQ_PROVINCE}'"' >> pki/vars
echo 'set_var EASYRSA_REQ_CITY	"'${EASYRSA_REQ_CITY}'"' >> pki/vars
echo 'set_var EASYRSA_REQ_ORG	"'${EASYRSA_REQ_ORG}'"' >> pki/vars
echo 'set_var EASYRSA_REQ_EMAIL	"'${EASYRSA_REQ_EMAIL}'"' >> pki/vars
echo 'set_var EASYRSA_REQ_OU		"'${EASYRSA_REQ_OU}'"' >> pki/vars

./easyrsa gen-dh
./easyrsa --batch build-ca nopass

# easyrsa init-pki
# easyrsa --batch build-ca nopass
# easyrsa --batch --req-cn=example.org gen-req example.org nopass
# easyrsa --batch --subject-alt-name='DNS:example.org,DNS:www.example.org'  \
#     sign-req server example.org./eas  

openssl x509 -in pki/ca.crt -out pki/$HOSTNAME-ca.pem -text
