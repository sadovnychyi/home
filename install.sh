sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 tzdata autossh
# Install Python 3.8.
sudo apt-get install -y libncursesw5-dev libreadline-gplv2-dev libgdbm-dev libc6-dev libsqlite3-dev libbz2-dev libffi-dev
wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz
tar zxf Python-3.8.10.tgz
rm -f Python-3.8.10.tgz
cd Python-3.8.10
./configure --enable-optimizations
make -j 4
sudo make altinstall
# Create venv with homeassistant.
sudo mkdir /srv/homeassistant
sudo chown pi:pi /srv/homeassistant
python3.8 -m venv /srv/homeassistant
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
ExecStart=/usr/bin/autossh -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3" -o StrictHostKeyChecking=no -N -R 8123:localhost:8123 dyriax_gmail_com@home.dmit.ro -i /home/pi/.ssh/id_rsa
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl --system daemon-reload
sudo systemctl enable home-assistant@pi
sudo systemctl enable autossh-tunnel
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8123
# Generate SSH key to use on cloud VM.
# ssh-keygen -t rsa -b 4096 -C "home@dmit.ro"
# ssh -v -nN -R 8123:localhost:8123 dyriax_gmail_com@home.dmit.ro
# autossh -N -R 8123:localhost:8123 dyriax_gmail_com@home.dmit.ro
# Install pi-hole, custom DNS server with filtering.
git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
sudo bash Pi-hole/automated\ install/basic-install.sh
