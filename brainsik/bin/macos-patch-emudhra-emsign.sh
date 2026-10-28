#!/usr/bin/env bash
#
# Patch macOS /etc/ssl/cert.pem to not trust emSign certificates.
#
# See https://emudhra.we-have-a-problem.com/#macos-curl
#
set -eu -o pipefail

# Back up the file
if [[ -s /etc/ssl/cert.pem.orig ]]; then
    echo "✓ cert.pem.orig exists"
else
    echo "* Backing up cert.pem"
    sudo cp -av /etc/ssl/cert.pem /etc/ssl/cert.pem.orig
fi

# Remove emSign ECC Root CA - G3
echo "* Removing emSign ECC Root CA - G3"
t=$(mktemp) &&
awk -v s='=== /C=IN/OU=emSign PKI/O=eMudhra Technologies Limited/CN=emSign ECC Root CA - G3' \
  '/^(===|###) /{skip=0} $0==s{skip=1} !skip' /etc/ssl/cert.pem > "$t" &&
[[ -s "$t" ]] && sudo install -m 0644 -o root -g wheel "$t" /etc/ssl/cert.pem
rm -f "$t"

# Block the six Sectigo cross-signed intermediates, which chain to AAA Certificate Services.
# Note: This may break verification of unaffected websites that chain to AAA Certificate Services.
echo "* Removing intermediates chained to AAA Certificate Services"
t=$(mktemp) &&
awk -v s='=== /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services' \
  '/^(===|###) /{skip=0} $0==s{skip=1} !skip' /etc/ssl/cert.pem > "$t" &&
[[ -s "$t" ]] && sudo install -m 0644 -o root -g wheel "$t" /etc/ssl/cert.pem
rm -f "$t"

# Check for errors
echo "* Validating for errors"
if openssl crl2pkcs7 -nocrl -certfile /etc/ssl/cert.pem | openssl pkcs7 -print_certs -noout >/dev/null; then
    :
else
    echo "Should not receive an error. Original cert.pem will be restored."
    sudo cp -a /etc/ssl/cert.pem.orig /etc/ssl/cert.pem
    exit 1
fi

# Check the result does not contain certs
echo "* Validating certs have been removed"
if result=$(openssl crl2pkcs7 -nocrl -certfile /etc/ssl/cert.pem \
    | openssl pkcs7 -print_certs -noout \
    | grep -E 'emSign ECC Root CA - G3|AAA Certificate Services'); then
    echo "No roots should be present, but got:"
    echo "$result"
    exit 1
else
    if [[ $? -ne 1 ]]; then
        exit 1
    fi
fi

# Fix system python3
F="$(/usr/bin/python3 -c 'import sysconfig; print(sysconfig.get_path("stdlib"))')/sitecustomize.py"
if [[ -s "$F" ]] && grep 'os.environ.setdefault("PIP_CERT", "/etc/ssl/cert.pem")' "$F" >/dev/null; then
    echo "✓ System Python looks patched"
else
    echo "* Patching system Python"
    echo 'import os; os.environ.setdefault("PIP_CERT", "/etc/ssl/cert.pem")' | sudo tee -a "$F" > /dev/null &&
    sudo chmod 644 "$F"
fi
