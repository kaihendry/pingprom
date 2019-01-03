# Kai Hendry's monitoring setup

This is _my setup_ for _my needs_. With my secrets removed. Initially I ran on
[CoreOS](https://groups.google.com/d/msg/prometheus-users/9d-cX5xtUi8/p_NM00FOCwAJ),
hence the systemd files. Currently I run on [Void](https://voidlinux.org/).

* Monitor lots of Websites: foo.example.com, bar.example.com, google.com ....
* Notify me when a site goes down with AWS SES
* Use Grafana to monitor

If you are looking for an easy hosted solution, I recommend https://apex.sh/ping/

# CoreOS setup notes

(not maintained)

Assuming you are sshing to a [CoreOS](https://coreos.com/) machine. "pingprom" **requires systemd & Docker**.

	ssh core@ip
	# docker network create --driver bridge pingprom
	# git clone https://github.com/kaihendry/pingprom.git
	# export PINGPROM=$(readlink -f pingprom) # make a note where the checkout is
	# echo PINGPROM=$PINGPROM > /etc/default/pingprom
	# cd /etc/systemd/system
	# for i in $PINGPROM/*.service; do ln $i; done
	# systemctl daemon-reload
	# systemctl start $(for i in $PINGPROM/*.service; do echo $(basename $i); done)
	# systemctl enable $(for i in $PINGPROM/*.service; do echo $(basename $i); done)

Now you need to `systemctl status` or `journalctl -b -f` to debug the failing ones and once everything looks OK.

# Voidlinux

Assuming [Docker](https://wiki.voidlinux.org/Docker) is setup.

Notice the Makefile and the .env file of my secrets which requires:

* PASSWORD
* USERNAME
* PRODTOKEN
* DEVTOKEN
* FROM
* TO
* SMTPAUTHUSERNAME
* SMTPAUTHPASSWORD
* SMARTHOST

## Blackbox exporter /etc/sv/blackbox-exporter/run

	#!/bin/sh
	PINGPROM=/home/hendry/pingprom
	/usr/bin/docker run --rm -p 9115:9115 --privileged -v ${PINGPROM}/blackbox.yml:/config/blackbox.yml \
	 --name blackboxprober \
	 prom/blackbox-exporter:master --config.file=/config/blackbox.yml

## Alertmanager /etc/sv/alertmanager/run

	#!/bin/sh
	PINGPROM=/home/hendry/pingprom
	/usr/bin/docker run --rm -p 9093:9093 \
	 --name alertmanager \
	 --network=pingprom \
	 -v ${PINGPROM}/alertmanager.yml:/alertmanager.yml \
	 prom/alertmanager \
	 --config.file=/alertmanager.yml \
	 --web.external-url=https://am.dabase.com/

## Grafana /etc/sv/grafana/run

I use Grafana to view my AWS CloudWatch metrics

	#!/bin/sh
	/usr/bin/docker run --rm -p 2000:3000 --user 1000 -v /home/hendry/grafana:/var/lib/grafana \
			-v "/home/hendry/.aws:/usr/share/grafana/.aws" \
			-e HOME=/usr/share/grafana \
			grafana/grafana

## Caddy /etc/sv/caddy/run

	#!/bin/sh
	CADDYPATH="/var/lib/caddy"
	export CADDYPATH
	mkdir -p "$CADDYPATH"
	chmod 0700 "$CADDYPATH"
	chown caddy:caddy "$CADDYPATH"
	cd /etc/caddy
	exec chpst -o 8192 -u caddy caddy

### /etc/caddy/caddy.conf.d/prom.conf

	prom.dabase.com {
		proxy / 192.168.1.5:9090
		basicauth / $USERNAME $PASSWORD
	}

### /etc/caddy/caddy.conf.d/am.conf

	alerts.dabase.com {
		proxy / 192.168.1.5:9093
		basicauth / $USERNAME $PASSWORD
	}

### /etc/caddy/caddy.conf.d/bbe.conf

	bbe.dabase.com {
		proxy / 192.168.1.5:9115
		basicauth / $USERNAME $PASSWORD
	}

### /etc/caddy/caddy.conf.d/grafana.conf

	grafana.dabase.com { proxy / 192.168.1.5:2000 }
