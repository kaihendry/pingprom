# GOAL

Implement Pingdom type functionality with https://prometheus.io/ with least LOC possible.

	wc -l *.{yml,service} prometheus/* | tail -n1
	 129 total

* Monitor lots of Websites: foo.example.com, bar.example.com, google.com ....
* Email when site goes down with alertmanager & AWS SES
* Graph history of outages ... http://%H:9090/graph?g0.range_input=1h&g0.expr=probe_success&g0.tab=0

Features:

* Keeps upto date between reboots
* Containerized

# Setup

Assuming you are sshing to a [CoreOS](https://coreos.com/) machine. "pingprom" **requires systemd & Docker**.

	ssh core@ip
	docker network create --driver bridge pingprom
	git clone https://github.com/kaihendry/pingprom.git
	cd /etc/systemd/system
	for i in ~/pingprom/*.service; do ln $i; done
	systemctl daemon-reload
	systemctl start $(for i in ~/pingprom/*.service; do echo $(basename $i); done)
	systemctl enable $(for i in ~/pingprom/*.service; do echo $(basename $i); done)

Now you need to `systemctl status` or `journalctl -b -f` to debug the failing ones and once everything looks OK.

# Caddy configuration for nicer URLs

	prom.example.com {
		tls youremail@example.com
		proxy / prom:9090
	}
	alerts.example.com {
		tls youremail@example.com
		proxy / alertmanager:9093
	}
