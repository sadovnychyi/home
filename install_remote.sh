sudo apt-get install nginx python-certbot-nginx
ZONE=home.dmit.ro
ZONENAME=dmit-ro
gcloud dns record-sets transaction start --zone="${ZONENAME}"
gcloud dns record-sets transaction remove --zone="${ZONENAME}" --name="${ZONE}." --ttl=30 --type=A `gcloud dns record-sets list --zone="${ZONENAME}" --name="${ZONE}" | awk '{ print $4 }' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"`
gcloud dns record-sets transaction add --zone="${ZONENAME}" --name="${ZONE}" --ttl=30 --type=A `curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google"`
gcloud dns record-sets transaction execute --zone="${ZONENAME}"
sudo sh -c "cat >/etc/nginx/sites-available/default" <<-EOF
map \$http_upgrade \$connection_upgrade {
  default upgrade;
  ''      close;
}
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name $ZONE;
    if (\$scheme = http) {
        return 301 https://\$host\$request_uri;
    }
    location / {
        proxy_pass http://localhost:8123;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
    }
    location /api/websocket {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_pass http://localhost:8123/api/websocket;
    }
}
EOF
sudo nginx -t
sudo certbot --nginx --non-interactive --agree-tos -m webmaster@dmit.ro -d $ZONE
sudo systemctl restart nginx
