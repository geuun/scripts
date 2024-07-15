#!/bin/bash

# check current shell
CURRENT_SHELL=$(basename "$SHELL")

# install
curl https://pyenv.run | bash

echo "Add PATH Environment Values"
echo "Current Shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" = "bash" ]; then
    if ! grep -q 'export PYENV_DIR="$HOME/.pyenv' ~/.bashrc; then
      echo '' >> ~/.bashrc
      echo '# pyenv' >> ~/.bashrc
      echo 'export PYENV_DIR="$HOME/.pyenv"' >> ~/.bashrc
      echo 'command -v pyenv >/dev/null || export PATH="$PYENV_DIR/bin:$PATH"' >> ~/.bashrc
      echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    fi
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    if ! grep -q 'export PYENV_DIR="$HOME/.pyenv' ~/.zshrc; then
      echo '' >> ~/.zshrc
      echo '# pyenv' >> ~/.zshrc
      echo 'export PYENV_DIR="$HOME/.pyenv"' >> ~/.zshrc
      echo 'command -v pyenv >/dev/null || export PATH="$PYENV_DIR/bin:$PATH"' >> ~/.zshrc
      echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    fi
else
    echo "This Shell Script not supported $CURRENT_SHELL"
    exit 1
fi

echo "DONE!"
echo "Please restart your shell or run 'source ~/.bash_profile' or 'source ~/.zshrc' to apply changes."