#!/bin/bash

# check current shell
CURRENT_SHELL=$(basename "$SHELL")

# install
curl -sSL https://install.python-poetry.org | python3 -

# PATH setting
echo "Add PATH Environment Values"
echo "Current Shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" = "bash" ]; then
    if ! grep -q 'export POETRY_DIR="$HOME/.local/bin"' ~/.bashrc; then
      echo '' >> ~/.bashrc
      echo '# poetry' >> ~/.bashrc
      echo 'export POETRY_DIR="$HOME/.local/bin"' >> ~/.bashrc
      echo 'export PATH="$POETRY_DIR:$PATH"' >> ~/.bashrc
    fi
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    if ! grep -q 'export POETRY_DIR="$HOME/.local/bin"' ~/.zshrc; then
      echo '' >> ~/.zshrc
      echo '# poetry' >> ~/.zshrc
      echo 'export POETRY_DIR="$HOME/.local/bin"' >> ~/.zshrc
      echo 'export PATH="$POETRY_DIR:$PATH"' >> ~/.zshrc
    fi
else
    echo "This Shell Script not supported $CURRENT_SHELL"
    exit 1
fi

# poetry config settings
poetry config virtualenvs.in-project true

echo "DONE!"
echo "Please restart your shell or run 'source ~/.bash_profile' or 'source ~/.zshrc' to apply changes."