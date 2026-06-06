#!/bin/bash
echo "Waiting for Elasticsearch..."
until curl -s -u elastic:changeme http://elasticsearch:9200 > /dev/null 2>&1; do
  sleep 3
done
echo "Setting kibana_system password..."
curl -s -u elastic:changeme \
  -X POST http://elasticsearch:9200/_security/user/kibana_system/_password \
  -H "Content-Type: application/json" \
  -d '{"password":"KibanaPass123!"}'
echo ""
echo "Done."
