# Prometheus uptime monitoring quickstart

Refactored as a simple starting point to help introduce you to Prometheus
based monitoring.

	docker-compose up

To clean up:

	docker-compose down -v

# Generating config files

	make

The alert manager configuration needs a email SMTP host, user and password for example. As well as the email address of whom to alert.

`targets.yml` are where you list out the hosts you want to monitor.
