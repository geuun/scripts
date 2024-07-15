#!/bin/bash

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

# check current shell
CURRENT_SHELL=$(basename "$SHELL")

# install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Add PATH Environment Values"
echo "Current Shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" = "bash" ]; then
    if ! grep -q 'export NVM_DIR="$HOME/.nvm' ~/.bashrc; then
      echo '' >> ~/.bashrc
      echo '# nvm' >> ~/.bashrc
      echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
      echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
      echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
    fi
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    if ! grep -q 'export NVM_DIR="$HOME/.nvm' ~/.zshrc; then
      echo '' >> ~/.zshrc
      echo '# nvm' >> ~/.zshrc
      echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
      echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
      echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
    fi
else
    echo "This Shell Script not supported $CURRENT_SHELL"
    exit 1
fi

echo "DONE!"
echo "Please restart your shell or run 'source ~/.bash_profile' or 'source ~/.zshrc' to apply changes."