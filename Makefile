deploy:
	scp -r *[^.git] pi@home.local:~/.homeassistant
	echo "sudo systemctl restart home-assistant@pi" | ssh pi@home.local
	make logs

logs:
	echo "sudo journalctl -f -u home-assistant@pi" | ssh pi@home.local

upgrade:
	echo "/srv/homeassistant/bin/python3 -m pip install homeassistant --upgrade" | ssh pi@home.local
	make deploy
