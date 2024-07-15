#!/bin/bash

echo "Create kubeconfig file"
read -p "- Please enter your Region Code (KR): " REGION_CODE
if [ -z "$REGION_CODE" ] then
    echo "Please enter valid region code"
    exit 1
fi

read -p "- Please enter your cluster uuid: " CLUSTER_UUID
if [ -z "$CLUSTER_UUID" ] then
    echo "Please enter valid cluster uuid"
    exit 1
fi

read -p "- Please enter your Profile Name: " PROFILE_NAME
if [ "$PROFILE_NAME" = "" ]; then
    $PROFILE_NAME="DEFAULT"
fi

ncp-iam-authenticator create-kubeconfig --region $REGION_CODE --cluster $CLUSTER_UUID --profile $PROFILE_NAME --debug true
echo "DONE!"