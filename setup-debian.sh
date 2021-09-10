#!/bin/sh

DEBIAN_FRONTEND=noninteractive

sudo apt-get -qq update && sudo apt-get -qq install -y --no-install-recommends \
  gnupg \
  software-properties-common \
  curl \
  jq \
  apt-transport-https \
  ca-certificates

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# Focal repository not yet available
#sudo apt-add-repository "deb [arch=amd64] https://apt.kubernetes.io/ $(lsb_release -cs) main"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt-get -qq update && sudo apt-get -qq install -y --no-install-recommends \
  terraform \
  kubectl

mkdir -p /home/codespace/.terraform.d/
cat << EOF > /home/codespace/.terraform.d/credentials.tfrc.json
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_API_TOKEN"
    }
  }
}
EOF

terraform init
 
if [ $(terraform show -json |jq 'has("values")') = "false" ]; then 
  echo "Kubernetes resource not found"; 
  exit 0
else
  echo "Kubernetes found in Terraform state";
  rm -f ~/.kube/config 
  TF_OUTPUTS_FILE=~/tf_outputs.json
  terraform show -json | jq '.values.outputs' > $TF_OUTPUTS_FILE
fi

USER_NAME=$(jq -r '.cluster_username.value' $TF_OUTPUTS_FILE)
USER_PASS=$(jq -r '.cluster_password.value' $TF_OUTPUTS_FILE)
CLUSTER_HOST=$(jq -r '.host.value' $TF_OUTPUTS_FILE)

USER_CERT_DATA=$(jq -r '.client_certificate.value' $TF_OUTPUTS_FILE)
USER_KEY_DATA=$(jq -r '.client_key.value' $TF_OUTPUTS_FILE)
CLUSTER_CA_DATA=$(jq -r '.cluster_ca_certificate.value' $TF_OUTPUTS_FILE)

mkdir -p /home/codespace/.kube/
cat << EOF > /home/codespace/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CLUSTER_CA_DATA
    server: $CLUSTER_HOST
  name: online-ide
contexts:
- context:
    cluster: online-ide
    user: $USER_NAME
  name: default-context
current-context: default-context
kind: Config
preferences: {}
users:
- name: $USER_NAME
  user:
    client-certificate-data: $USER_CERT_DATA
    client-key-data: $USER_KEY_DATA
    password: $USER_PASS
    username: $USER_NAME
EOF

kubectl get pods --all-namespaces

pip install mkdocs
sudo apt install -y plantuml