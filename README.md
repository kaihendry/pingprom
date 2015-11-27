# Setup

Assuming you are sshing to a [CoreOS](https://coreos.com/) machine. Basically "pingprom" requires systemd & Docker.

	ssh core@ip
	git clone https://github.com/kaihendry/pingprom.git
	cd /etc/systemd/system
	for i in ~/pingprom/*.service; do sudo ln $i; done
	sudo systemctl start *.service
	sudo systemctl enable *.service

# GOAL (not achieved)

Implement Pingdom type functionality with http://prometheus.io/ with least LOC possible.

	wc -l *.{yml,service,conf} prometheus/* | tail -n1
	 131 total

* Monitor lots of Websites: foo.example.com, bar.example.com, google.com ....
* Email when site goes down
* Graph history of outages

# Features

* Keeps upto date between reboots
* Containerized, for example:


	CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                    NAMES
	7150415e7c66        prom/node-exporter:latest       "/bin/go-run"          4 minutes ago       Up 4 minutes                                 node-exporter       
	02aab1abd972        prom/blackbox-exporter:latest   "/bin/go-run -config   4 minutes ago       Up 4 minutes        0.0.0.0:9115->9115/tcp   blackboxprober      
	1609230dd89b        prom/alertmanager:latest        "/bin/go-run -config   4 minutes ago       Up 4 minutes        0.0.0.0:9093->9093/tcp   alertmanager        
	30cc9261b37f        prom/prometheus:latest          "/bin/prometheus -co   4 minutes ago       Up 4 minutes                                 prom                
