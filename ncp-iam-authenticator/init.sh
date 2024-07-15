#!/bin/bash

# install ncp-iam-authenticator
NCP_IAM_AUTHENTICATOR_DIR=$HOME/.ncp-iam-authenticator

## add directory 
mkdir -p $NCP_IAM_AUTHENTICATOR_DIR

# check cpu architecture
CPU_ARCH=$(uname -m)
## install
if [ "$CPU_ARCH" = "x86_64" ]; then
    # linux
    echo "Current Machine CPU Architecture: x86_64"
    curl -L https://github.com/NaverCloudPlatform/ncp-iam-authenticator/releases/latest/download/ncp-iam-authenticator_linux_amd64 -o $NCP_IAM_AUTHENTICATOR_DIR/ncp-iam-authenticator
elif [ "$CPU_ARCH" = "arm64" ]; then
    # macos
    echo "Current Machine CPU Architecture: arm64"
    curl -L https://github.com/NaverCloudPlatform/ncp-iam-authenticator/releases/latest/download/ncp-iam-authenticator_darwin_amd64 -o $NCP_IAM_AUTHENTICATOR_DIR/ncp-iam-authenticator
else
    echo "Not supported architecture"
    exit 1
fi

# add binary permission
echo "chmod +x $NCP_IAM_AUTHENTICATOR_DIR/ncp-iam-authenticator"
chmod +x $NCP_IAM_AUTHENTICATOR_DIR/ncp-iam-authenticator
echo "chmod success"

# add PATH 
## check current shell
CURRENT_SHELL=$(basename "$SHELL")

echo "Current shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" = "bash" ]; then
    if ! grep -q 'export NCP_IAM_DIR=$HOME/.ncp-iam-authenticator' ~/.bash_profile; then
        echo 'export NCP_IAM_DIR=$HOME/.ncp-iam-authenticator' >> ~/.bash_profile
        echo 'export PATH=$PATH:$NCP_IAM_DIR' >> ~/.bash_profile
        echo "path added!"
    fi
elif [ "$CURRENT_SHELL" = "zsh" ]; then 
    if ! grep -q 'export NCP_IAM_DIR=$HOME/.ncp-iam-authenticator' ~/.zshrc; then
        echo '' >> ~/.zshrc
        echo 'export NCP_IAM_DIR=$HOME/.ncp-iam-authenticator' >> ~/.zshrc
        echo 'export PATH=$PATH:$NCP_IAM_DIR' >> ~/.zshrc
        echo "path added!"
    fi
else
    echo "Not supported shell: $CURRENT_SHELL"
    exit 1
fi

echo "DONE!"
echo "Please restart your shell or run 'source ~/.bash_profile' or 'source ~/.zshrc' to apply changes."