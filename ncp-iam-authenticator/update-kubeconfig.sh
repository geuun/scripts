#!/bin/bash

echo "Update kubeconfig file"
read -p "- Please enter your Region Code (KR): " REGION_CODE
if [ -z "$REGION_CODE" ]; then
    echo "Please enter a valid region code"
    exit 1
fi

read -p "- Please enter your cluster uuid: " CLUSTER_UUID
if [ -z "$CLUSTER_UUID" ]; then
    echo "Please enter a valid cluster uuid"
    exit 1
fi

read -p "- Please enter your Profile Name: " PROFILE_NAME
if [ -z "$PROFILE_NAME" ]; then
    PROFILE_NAME="DEFAULT"
fi

ncp-iam-authenticator update-kubeconfig --region "$REGION_CODE" --clusterUuid "$CLUSTER_UUID" --profile "$PROFILE_NAME" --debug true
echo "DONE!"