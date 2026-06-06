# WSL Corporate Certificates

## Síntoma

curl:

curl: (60) SSL certificate problem:
self-signed certificate in certificate chain

gh auth login:

connection reset by peer

## Causa

WSL no confía en los certificados de inspección SSL corporativos.

Certificados utilizados:

- Kyndryl SSL Inspection
- Kyndryl-Forward-Trust-ECDSA-v2

## Instalación

sudo cp *.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

## Validación

curl -I https://github.com

Resultado esperado:

HTTP/2 200

## Impacto

Corrige:

- curl
- GitHub Copilot
- Git HTTPS
- Terraform
- Azure CLI
- pip
- npm
- Docker
