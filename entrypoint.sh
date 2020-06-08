#!/bin/bash

# Hard enforcement of required environment variables
mkdir -p /certs/ca
mkdir -p /certs/server
mkdir -p /certs/user

echo "Creating Certificate Authority (CA) cert/key in '/certs/ca'.."
openssl genrsa -des3 -passout pass:$CERT_PASSWORD -out /certs/ca/cacert.key 2048
openssl req -x509 -new -nodes -passin pass:$CERT_PASSWORD -key /certs/ca/cacert.key -sha256 -days 1825 -out /certs/ca/cacert.pem -config /opt/openssl.cnf -subj "/CN=ca"
echo "Done."

echo ""

echo "Creating wildcard server certificate for '*.$DOMAIN'.."
openssl req -newkey rsa:2048 -nodes -passin pass:$CERT_PASSWORD -keyout "/certs/server/tls.key" -out "/certs/server/tls.csr" -subj "/CN=*.$DOMAIN" -config <(sed "s|REPLACE_ALT_NAME|\*.$DOMAIN|g" /opt/openssl.cnf) -sha256 -days 730
openssl ca -config <(sed  "s|REPLACE_ALT_NAME|*.$DOMAIN|g" /opt/openssl.cnf) -passin pass:$CERT_PASSWORD -cert "/certs/ca/cacert.pem" -keyfile "/certs/ca/cacert.key" -extensions v3_req -batch -out "/certs/server/tls.crt" -days 730 -infiles "/certs/server/tls.csr"
echo "Done."

echo ""

echo "Create user certificate and browser-compatible P12 for '$USERNAME' ($USER_EMAIL).."
openssl req -newkey rsa:2048 -nodes -passin pass:$CERT_PASSWORD -keyout "/certs/user/tls.key" -out "/certs/user/tls.csr" -subj /CN=$USERNAME/emailAddress=$USER_EMAIL -config <(sed "s|REPLACE_ALT_NAME|$USERNAME|g" /opt/openssl.cnf) -sha256 -days 730
openssl ca -config <(sed  "s|REPLACE_ALT_NAME|$USERNAME|g" /opt/openssl.cnf) -passin pass:$CERT_PASSWORD -cert "/certs/ca/cacert.pem" -keyfile "/certs/ca/cacert.key" -extensions v3_req -batch -out "/certs/user/tls.crt" -days 730 -infiles "/certs/user/tls.csr"
openssl pkcs12 -export -passin pass:$CERT_PASSWORD -passout pass:$CERT_PASSWORD -out "/certs/user/user.p12" -inkey "/certs/user/tls.key" -in "/certs/user/tls.crt"
echo "Done."
