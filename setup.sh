#!/bin/sh

DEBIAN_FRONTEND=noninteractive

sudo apt-get update && sudo apt-get install -y --no-install-recommends gnupg software-properties-common curl jq
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

cat << EOF > /home/codespace/.terraform.d/credentials.tfrc.json
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_API_TOKEN"
    }
  }
}
EOF 
