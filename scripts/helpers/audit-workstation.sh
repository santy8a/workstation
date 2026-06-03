#!/bin/bash

OUTPUT="workstation-audit.txt"

echo "======================================" > $OUTPUT
echo "WORKSTATION AUDIT" >> $OUTPUT
echo "Fecha: $(date)" >> $OUTPUT
echo "======================================" >> $OUTPUT
echo "" >> $OUTPUT

TOOLS=(
git
gh
az
terraform
kubectl
helm
kubelogin
ansible
yq
jq
k9s
kubectx
kubens
psql
atlas
docker
python3
pipx
uv
)

echo "######### WHICH #########" >> $OUTPUT
echo "" >> $OUTPUT

for tool in "${TOOLS[@]}"
do
    echo "===== $tool =====" >> $OUTPUT

    if which $tool >/dev/null 2>&1; then
        which $tool >> $OUTPUT
    else
        echo "NOT INSTALLED" >> $OUTPUT
    fi

    echo "" >> $OUTPUT
done

echo "" >> $OUTPUT
echo "######### VERSIONS #########" >> $OUTPUT
echo "" >> $OUTPUT

run_version () {
    TOOL=$1
    CMD=$2

    echo "===== $TOOL =====" >> $OUTPUT

    if which $TOOL >/dev/null 2>&1; then
        eval "$CMD" >> $OUTPUT 2>&1
    else
        echo "NOT INSTALLED" >> $OUTPUT
    fi

    echo "" >> $OUTPUT
}

run_version git "git --version"
run_version gh "gh --version"
run_version az "az version"
run_version terraform "terraform version"
run_version kubectl "kubectl version --client"
run_version helm "helm version"
run_version kubelogin "kubelogin --version"
run_version ansible "ansible --version"
run_version yq "yq --version"
run_version jq "jq --version"
run_version k9s "k9s version"
run_version kubectx "kubectx -V"
run_version kubens "kubens --help | head -n 1"
run_version psql "psql --version"
run_version atlas "atlas version"
run_version docker "docker --version"
run_version python3 "python3 --version"
run_version pipx "pipx --version"
run_version uv "uv --version"

echo "" >> $OUTPUT
echo "######### CONFIGURATION #########" >> $OUTPUT
echo "" >> $OUTPUT

echo "~/.kube" >> $OUTPUT
ls -la ~/.kube >> $OUTPUT 2>&1
echo "" >> $OUTPUT

echo "~/.azure" >> $OUTPUT
ls -la ~/.azure >> $OUTPUT 2>&1
echo "" >> $OUTPUT

echo "~/.ssh" >> $OUTPUT
ls -la ~/.ssh >> $OUTPUT 2>&1
echo "" >> $OUTPUT

echo "######### OS #########" >> $OUTPUT
echo "" >> $OUTPUT

uname -a >> $OUTPUT
echo "" >> $OUTPUT

cat /etc/os-release >> $OUTPUT

echo ""
echo "Audit generado en:"
echo "$(pwd)/$OUTPUT"
