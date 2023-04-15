# Steam Deck installation
## Install script
- Set user password if not set with
```sh
passwd
```
 - Run script
```sh
bash <(curl -s https://raw.githubusercontent.com/rafalb8/ZeroTierOne-Static/main/SteamDeck.sh)
```

## Manual
```sh
# Create and enter zerotier data directory
mkdir ~/.zerotier-one && cd ~/.zerotier-one

# Download zerotier
curl -LJO https://github.com/rafalb8/ZeroTierOne-Static/releases/latest/download/zerotier-one-x86_64.tar.gz

# Unpack downloaded archive
tar --strip-components=1 -xvf zerotier-one-x86_64.tar.gz

# If you want, you can remove the archive
rm zerotier-one-x86_64.tar.gz

# Join network
mkdir networks.d
touch networks.d/<Network_ID>.conf

# Set user password if not set
passwd

# Binary will be run as a user service, but needs root, so add permission to run sudo without password for zerotier-one
echo "%wheel ALL=(ALL) NOPASSWD: /home/deck/.zerotier-one/zerotier-one" | sudo tee /etc/sudoers.d/zerotier

# Add service file to run at startup
mkdir -p ~/.config/systemd/user

# Paste whole command
cat <<EOF > ~/.config/systemd/user/zerotier-one.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/bin/sudo %h/.zerotier-one/zerotier-one %h/.zerotier-one
Restart=on-failure

[Install]
WantedBy=default.target
EOF
# -----

# Enable service
systemctl --user daemon-reload
systemctl --user enable --now zerotier-one.service
```