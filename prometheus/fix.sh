#!/usr/bin/env bash
docker run -v $(pwd):/pingprom:rw -it --entrypoint=promtool prom/prometheus check config /pingprom/prometheus.yml
