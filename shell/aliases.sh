#!/usr/bin/env bash

#
# General
#

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'

#
# Git
#

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'

#
# Terraform
#

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tff='terraform fmt'

#
# Kubernetes
#

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'

#
# Helm
#

alias h='helm'
alias hl='helm list'

#
# Azure
#

alias azl='az login'
alias aza='az account show'
alias azs='az account set'

#
# Docker
#

alias d='docker'
alias dc='docker compose'
