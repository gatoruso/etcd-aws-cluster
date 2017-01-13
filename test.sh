export HOST_ETCD_CONFDIR=/tmp/etcd/
export HOST_ETCD_CLIENT_CERTDIR=/etc/pf9/kube.d/certs/apiserver/etcd/
docker run \
  --name etcd-aws-cluster \
  --entrypoint /bin/sh \
  -it \
  --rm \
  -v "$HOST_ETCD_CONFDIR":/etc/sysconfig/ \
  -v "$HOST_ETCD_CLIENT_CERTDIR":/etc/certs/ \
  -e "ETCD_CLIENT_PORT=4001" \
  -e "ETCD_PEER_PORT=2379" \
  -e "ETCD_CLIENT_SCHEME=https" \
  -e "ETCD_CURL_OPTS=--cacert /etc/certs/ca.crt --cert /etc/certs/request.crt --key /etc/certs/request.key" \
  pf9:etcd-aws-cluster
