#!/usr/bin/env bash
#
# Installs the Eternal Terminal package
#
set -eu -o pipefail
codename=$(lsb_release -cs 2>/dev/null)

echo "💾 Installing Eternal Terminal (et) …"

echo "deb https://github.com/MisterTea/debian-et/raw/master/debian-source/ $codename main" | sudo tee -a /etc/apt/sources.list.d/et.list
curl -sSL https://github.com/MisterTea/debian-et/raw/master/et.gpg | sudo tee /etc/apt/trusted.gpg.d/et.gpg >/dev/null
sudo apt update
sudo apt install et

sudo perl -i -pe 's/telemetry = true/telemetry = false/;' /etc/et.cfg
sudo systemctl restart et
