#!/usr/bin/env bash

#
# Workstation Profile
#

export EDITOR=code

export PATH="$HOME/.local/bin:$PATH"

mkdir -p "$HOME/.terraform.d/plugin-cache"

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

export PAGER=less

#
# Aliases
#

if [ -f "$HOME/dev/personal/workstation/shell/aliases.sh" ]; then
  source "$HOME/dev/personal/workstation/shell/aliases.sh"
fi
