sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev autossh
sudo mkdir /srv/homeassistant
sudo chown pi:pi /srv/homeassistant
python3 -m venv /srv/homeassistant
/srv/homeassistant/bin/python3 -m pip install wheel homeassistant
sudo sh -c "cat >/etc/systemd/system/home-assistant@pi.service" <<-EOF
[Unit]
Description=Home Assistant
After=network-online.target
[Service]
Type=simple
User=%i
ExecStart=/srv/homeassistant/bin/hass -c "/home/%i/.homeassistant"
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
sudo sh -c "cat >/etc/systemd/system/autossh-tunnel.service" <<-EOF
[Unit]
Description=AutoSSH tunnel service
After=network.target
[Service]
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3" -N -R 8123:localhost:8123 dyriax_gmail_com@146.148.70.148 -i /home/pi/.ssh/id_rsa
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl --system daemon-reload
sudo systemctl enable home-assistant@pi
sudo systemctl enable autossh-tunnel
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8123
# ssh-keygen -t rsa -b 4096 -C "home@dmit.ro"
# ssh -v -nN -R 8123:localhost:8123 dyriax_gmail_com@146.148.70.148
# autossh -N -R 8123:localhost:8123 dyriax_gmail_com@146.148.70.148
