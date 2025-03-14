#!/bin/bash

if [[ $# -ne 1 ]]; then
fs=$(mktemp -d)
else
fs=$1
shift
fi

echo Working directory $fs
cd $fs

if [[ ! -e $fs/cfssl ]]; then
curl -s -L -o $fs/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o $fs/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod 755 $fs/cfssl*
fi

cfssl=$fs/cfssl
cfssljson=$fs/cfssljson

if [[ ! -e $fs/ca.pem ]]; then

cat << EOF | $cfssl gencert -initca - | $cfssljson -bare ca -
{
  "CN": "Wazuh",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "US",
    "L": "San Francisco",
    "O": "Wazuh",
    "OU": "Wazuh Root CA"
  }
 ]
}
EOF

fi

if [[ ! -e $fs/ca-config.json ]]; then
$cfssl print-defaults config > ca-config.json
fi

gencert_rsa() {
        name=$1
        profile=$2
cat << EOF | $cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=$profile -hostname="$name,127.0.0.1,localhost" - | $cfssljson -bare $name -
{
  "CN": "$i",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "US",
    "L": "California",
    "O": "Wazuh",
    "OU": "Wazuh"
  }
  ],
  "hosts": [
    "$i",
    "localhost"
  ]
}
EOF
openssl pkcs8 -topk8 -inform pem -in $name-key.pem -outform pem -nocrypt -out $name.key
}

gencert_ec() {
    openssl ecparam -name secp256k1 -genkey -noout -out jwt-private.pem
    openssl ec -in jwt-private.pem -pubout -out jwt-public.pem
}

hosts=(indexer dashboard api comms)
for i in "${hosts[@]}"; do
        gencert_rsa $i www
done

users=(admin)
for i in "${users[@]}"; do
        gencert_rsa $i client
done

gencert_ec
