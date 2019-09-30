# Prometheus uptime monitoring quickstart

Refactored as a simple starting point to help introduce you to Prometheus
based monitoring.

# Services

You only need visit

* Prometheus http://0.0.0.0:9090

Which integrates with these "targets" via the prometheus configuration.

* Blackbox exporter that does the httping http://0.0.0.0:9115
* Alert manager that does the alerting http://0.0.0.0:9093

# Generating config files

	make

The alert manager configuration needs `.env` file with at least `$FROM`, `$TO`, `$SMARTHOST` set at a minimum.

`targets.yml` are where you list out the hosts you want to monitor.

# Reference

<https://grafana.com/docs/administration/provisioning/>
