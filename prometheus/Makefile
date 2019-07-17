SECRETS := ../.env

prometheus.yml: prometheus.yml.in
	test -f $(SECRETS) ; set -a ; . $(SECRETS) ; envsubst < $< > $@
	docker run -v $(shell pwd):/pingprom:rw -it --entrypoint=promtool prom/prometheus check config /pingprom/prometheus.yml

clean:
	rm prometheus.yml
