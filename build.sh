#! /bin/bash

apt update

apt install -y git libicu-dev clang lld bazel-bootstrap openssl clang


touch WORKSPACE

curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-arm64 -o /usr/local/bin/bazelisk

chmod +x /usr/local/bin/bazelisk

ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout leaf_cert.pkcs8 -out leaf_cert.pem \
  -subj "/CN=localhost"

echo "7.4.1" > .bazelversion

CC=clang bazelisk build --jobs=4 --enable_bzlmod -c opt //quiche:quic_server //quiche:quic_client


#./bazel-bin/quiche/quic_server \
#  --certificate_file=leaf_cert.pem \
#  --key_file=leaf_cert.pkcs8 \
#  --quic_response_cache_dir=/tmp/quic-data/localhost \
#  --port=6121

#export SSLKEYLOGFILE="$PWD/sslkeylog.log"

#./bazel-bin/quiche/quic_client \
#  --host=127.0.0.1 \
#  --port=6121 \
#  --disable_certificate_verification \
#  --quic_version=Q050 \
#  https://localhost/index.html

