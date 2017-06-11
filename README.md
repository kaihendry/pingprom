# GOAL

Implement Pingdom type functionality with https://prometheus.io/ with least LOC possible.

	wc -l *.{yml,service} prometheus/* | tail -n1
	 181 total

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
	for i in ~/pingprom/*.service; do echo sudo ln $i; done
	echo sudo systemctl start $(for i in ~/pingprom/*@.service; do echo $(basename $i .service)$USER; done)

Now you need to `systemctl status` or `journalctl -u alertmanager@${USER}.service -f` to debug the failing ones and once everything looks OK.

# Caddy configuration for nicer URLs

	prom.example.com {
		tls youremail@example.com
		proxy / prom:9090
	}
	alerts.example.com {
		tls youremail@example.com
		proxy / alertmanager:9093
	}
