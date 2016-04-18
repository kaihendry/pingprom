# GOAL

Implement Pingdom type functionality with https://prometheus.io/ with least LOC possible.

	wc -l *.{yml,service} prometheus/* | tail -n1
	 161 total

* Monitor lots of Websites: foo.example.com, bar.example.com, google.com ....
* Email when site goes down with alertmanager & AWS SES
* Graph history of outages with grafana http://0.0.0.0:3000

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

**Edit alertmanager.env** to get your email notifications working with <https://us-west-2.console.aws.amazon.com/ses/home?region=us-west-2#verified-senders-email:>
