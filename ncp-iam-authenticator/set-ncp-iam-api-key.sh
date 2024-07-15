#!/bin/bash

NCP_API_GW="https://ncloud.apigw.ntruss.com"


# Set NCP IAM API Key
echo "Please enter Configuration Parameters for NCP IAM"

echo "Please enter your Profile Name"
read -p "Profile Name: " PROFILE_NAME

echo "Please enter your NCP IAM API Access Key"
read -p "Access Key: " ACCESS_KEY

echo "Please enter your NCP IAM API Secret Key"
read -p "Secret Key: " SECRET_KEY

# Make configure file
## add directory
if [ ! -d $HOME/.ncloud ]; then
    mkdir -p $HOME/.ncloud
fi
## add configure file
if [ ! -f $HOME/.ncloud/configure ]; then
    touch $HOME/.ncloud/configure
fi

if ! grep -q "\[$PROFILE_NAME\]" $HOME/.ncloud/configure; then
  cat <<EOF > $HOME/.ncloud/configure
  [$PROFILE_NAME]
  ncloud_access_key_id = $ACCESS_KEY
  ncloud_secret_access_key = $SECRET_KEY
  ncloud_api_url = $NCP_API_GW
  
EOF
else
  echo "Profile already exists"
  exit 1
fi