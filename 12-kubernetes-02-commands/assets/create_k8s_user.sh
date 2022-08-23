#~/usr/local/bin/env bash
# Generate a key
openssl genrsa -out developer.key 2048
# Generate CSR 
openssl req -new -key developer.key \
  -out developer.csr \
  -subj "/CN=developer"
# Request a certificate signed by kubernetes certificate
# for minikube
openssl x509 -req -in developer.csr \
  -CA ~/.minikube/ca.crt \
  -CAkey ~/.minikube/ca.key \
  -CAcreateserial \
  -out developer.crt -days 500
# for real kubernetes 
# openssl x509 -req -in developer.csr \
#   -CA /etc/kubernetes/pki/ca.crt \
#   -CAkey /etc/kubernetes/pki/ca.key \
#   -CAcreateserial \
#   -out developer.crt -days 500

# Adding new config for the user
kubectl config set-credentials developer \
  --client-certificate=/home/vagrant/developer.crt \
  --client-key=/home/vagrant/developer.key

kubectl config set-context developer-context \
  --cluster=minikube --user=developer

# kubectl config set-context developer-context \
#   --cluster=minikube --user=developer

# kubectl config set-cluster minikube \
#     --server=https://192.168.0.200:6443/ \
# 	--insecure-skip-tls-verify=true

curl -LO https://github.com/corneliusweig/rakkess/releases/download/v0.5.0/rakkess-amd64-linux.tar.gz \
  && tar xf rakkess-amd64-linux.tar.gz rakkess-amd64-linux \
  && chmod +x rakkess-amd64-linux \
  && sudo mv -i rakkess-amd64-linux $GOPATH/bin/rakkess

kubectl apply -f manifest.yml
kubectl -n app-namespace run  busybox --image=busybox -- /bin/sh -c "while true; do echo $(date) New log entry; sleep 1; done;"
