#!/bin/bash
#
# Deploy Docker Registry v2.0
# Uses nginx proxy for encryption and basic auth.
#

# Parameters - change these
HT_USERNAME="testuser"
HT_PASSWORD="password"
CERT_COMMON_NAME="my.docker.host"
REGISTRY_PATH="/registry"
NGINX_PATH="/registry/nginx/external"
CERTS_PATH="/registry/certs"
SELF_SIGNED=true

# Script
wget -qO- https://get.docker.com/ | sh
usermod -aG docker deploy
mkdir -p $NGINX_PATH
apt-get install -y apache2-utils
htpasswd -b -c $NGINX_PATH/docker-registry.htpasswd $HT_USERNAME $HT_PASSWORD
chown -R deploy:deploy $REGISTRY_PATH
chmod -R 775 $REGISTRY_PATH

if [ $SELF_SIGNED ] ; then
  openssl genrsa -out $CERTS_PATH/ca.key 2048
  openssl req -x509 -new -nodes -key $CERTS_PATH/ca.key -days 10000 -out $CERTS_PATH/ca.crt -subj "/CN=$HOSTNAME/O=Company/C=US"
fi

openssl genrsa -out $CERTS_PATH/docker-registry.key 2048
openssl req -new -key $CERTS_PATH/docker-registry.key -out $CERTS_PATH/docker-registry.csr -subj "/CN=$CERT_COMMON_NAME/O=Company/C=US"
openssl x509 -req -in $CERTS_PATH/docker-registry.csr -CA $CERTS_PATH/ca.crt -CAkey $CERTS_PATH/ca.key -CAcreateserial -out $CERTS_PATH/docker-registry.crt -days 10000
ln -s $CERTS_PATH/docker-registry.crt $NGINX_PATH/cert.pem
ln -s $CERTS_PATH/docker-registry.key $NGINX_PATH/key.pem

docker run -d -p 5000:5000 \
  -e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry \
  -v $REGISTRY_PATH:/var/lib/registry \
  --name registry registry:2

docker run -d -p 443:443 \
  -v $NGINX_PATH:/etc/nginx/external \
  --link registry:registry \
  --name nginx-registry-proxy marvambass/nginx-registry-proxy

# this one isn't working right
# docker run -d -p 443:443 -e REGISTRY_HOST="registry" \
#   -e REGISTRY_PORT="5000" \
#   -e SERVER_NAME="localhost" \
#   --link registry:registry \
#   -v $(pwd)/.htpasswd:/etc/nginx/.htpasswd:ro \
#   -v $(pwd)/certs:/etc/nginx/ssl:ro \
#   --name registry-proxy containersol/docker-registry-proxy

# client
# cp -v certs/ca.crt /etc/docker/certs.d/$CERT_COMMON_NAME/ca.crt
# service docker restart
# docker login -u <username> -p <password> -e <email> localhost:443
# docker pull hello-world
# docker tag hello-world:latest localhost:443/hello-secure-world:latest
# docker push localhost:443/hello-secure-world:latest
