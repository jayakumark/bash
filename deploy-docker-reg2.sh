#!/bin/bash
#
# Deploy Docker Registry:2 with a self-signed certificate for encryption and auth.
#

# Parameters
HT_USERNAME="testuser"
HT_PASSWORD="password"
CERT_COMMON_NAME=""

# Script
wget -qO- https://get.docker.com/ | sh
usermod -aG docker $USER
mkdir /registry
apt-get install apache2-utils
htpasswd -b -c .htpasswd $HT_USERNAME $HT_PASSWORD

# generate a root key
mkdir certs
openssl genrsa -out certs/ca.key 2048
openssl req -x509 -new -nodes -key certs/ca.key -days 10000 -out certs/ca.crt -subj "/CN=$HOSTNAME/O=Company/C=US"
openssl genrsa -out certs/docker-registry.key 2048
openssl req -new -key certs/docker-registry.key -out certs/docker-registry.csr -subj "/CN=$CERT_COMMON_NAME/O=Company/C=US"
openssl x509 -req -in certs/docker-registry.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/docker-registry.crt -days 10000

docker run -d -p 5000:5000 -v /registry:/var/lib/registry --name registry registry:2 # appears to be missing storage location variable
docker run -d -p 443:443 -e REGISTRY_HOST="registry" \
  -e REGISTRY_PORT="5000" \
  -e SERVER_NAME="localhost" \
  --link registry:registry \
  -v $(pwd)/.htpasswd:/etc/nginx/.htpasswd:ro \
  -v $(pwd)/certs:/etc/nginx/ssl:ro \
  --name registry-proxy containersol/docker-registry-proxy


# client
# cp -v certs/ca.crt /etc/docker/certs.d/$CERT_COMMON_NAME/ca.crt
# service docker restart
# docker login -u <username> -p <password> -e <email> localhost:443
# docker pull hello-world
# docker tag hello-world:latest localhost:443/hello-secure-world:latest
# docker push localhost:443/hello-secure-world:latest
