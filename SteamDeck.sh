#!/bin/sh
set -e

echo "Downloading zerotier one binary..."
mkdir -p $HOME/.zerotier-one && cd $HOME/.zerotier-one
curl -LJ https://github.com/rafalb8/ZeroTierOne-Static/releases/latest/download/zerotier-one-x86_64.tar.gz \
    | tar --strip-components=1 -xzf -

echo "Enter network ID:"
read Network_ID

mkdir -p networks.d
touch networks.d/${Network_ID}.conf

echo "Configuring zerotier one..."
# Binary will be run as a user service, but needs root, so add permission to run sudo without password for zerotier-one
echo "%wheel ALL=(ALL) NOPASSWD: $HOME/.zerotier-one/zerotier-one" | sudo tee /etc/sudoers.d/zerotier 1> /dev/null

# Add service file to run at startup
mkdir -p $HOME/.config/systemd/user

# Paste whole command
cat <<EOF > $HOME/.config/systemd/user/zerotier-one.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/bin/sudo %h/.zerotier-one/zerotier-one %h/.zerotier-one
Restart=on-failure

[Install]
WantedBy=default.target
EOF
# -----

echo "Starting zerotier one..."
systemctl --user daemon-reload
systemctl --user enable --now zerotier-one.service
