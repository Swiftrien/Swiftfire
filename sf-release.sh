#!/bin/bash
USED_SSL_ROOT="${PWD}/openssl/v1_1_0-macos_10_12/"
echo "Used openSSL root = $USED_SSL_ROOT"
swift build -c release -Xswiftc -I"${USED_SSL_ROOT}include" -Xlinker -L"${USED_SSL_ROOT}lib"
