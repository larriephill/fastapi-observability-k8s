#!/usr/bin/env bash
set -euo pipefail

# Prometheus
kubectl -n observability port-forward svc/prometheus-server 9090:80 >/dev/null 2>&1 & echo "Prometheus: http://localhost:9090"
# Grafana
kubectl -n observability port-forward svc/grafana 3000:80 >/dev/null 2>&1 & echo "Grafana:    http://localhost:3000"
# Loki (API)
kubectl -n observability port-forward svc/loki 3100:3100 >/dev/null 2>&1 & echo "Loki API:   http://localhost:3100"
# Alertmanager
kubectl -n observability port-forward svc/alertmanager 9093:9093 >/dev/null 2>&1 & echo "Alertmanager: http://localhost:9093"

echo "Press Ctrl+C to stop all port-forwards."
wait
