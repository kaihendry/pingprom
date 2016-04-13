# GOAL (not achieved)

Implement Pingdom type functionality with http://prometheus.io/ with least LOC possible.

	wc -l *.{yml,service,conf} prometheus/* | tail -n1
	 136 total


* Monitor lots of Websites: foo.example.com, bar.example.com, google.com ....
* Email when site goes down
* Graph history of outages

Features:

* Keeps upto date between reboots
* Containerized

# Setup

Assuming you are sshing to a [CoreOS](https://coreos.com/) machine. Basically "pingprom" requires systemd & Docker.

	ssh core@ip
	git clone https://github.com/kaihendry/pingprom.git
	cd /etc/systemd/system
	for i in ~/pingprom/*.service; do sudo ln $i; done
	sudo systemctl start *.service
	sudo systemctl enable *.service

Create alertmanager.env & edit alertmanager.conf

# alertmanager.env

Tested with <https://us-west-2.console.aws.amazon.com/ses/home?region=us-west-2#verified-senders-email:>

	HOST=email-smtp.us-west-2.amazonaws.com:587
	USER=AKIAINSHZHYMQYHXD4FQ
	PASS=secret
	FROM=youremail@example.com
