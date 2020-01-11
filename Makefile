deploy:
	scp -r *[^.git] pi@home.local:~/.homeassistant
	echo "sudo systemctl restart home-assistant@pi && sudo journalctl -f -u home-assistant@pi" | ssh pi@home.local
logs:
	echo "sudo journalctl -f -u home-assistant@pi" | ssh pi@home.local
