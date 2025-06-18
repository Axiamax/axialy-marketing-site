#!/usr/bin/env bash
# Usage: ./update_namesilo_dns.sh ui axialy.ai 203.0.113.10
set -euo pipefail
HOST=$1
DOMAIN=$2
IP=$3
API_KEY=${NAMESILO_API_KEY:?Need API key}

XML=$(curl -s "https://www.namesilo.com/api/dns/listRecords?version=1&type=xml&key=$API_KEY&domain=$DOMAIN")
RRID=$(echo "$XML" | xmllint --xpath "string(//resource_record[host='$HOST.$DOMAIN']/record_id)" - 2>/dev/null || true)

if [[ -z "$RRID" ]]; then
  echo "Creating A $HOST.$DOMAIN -> $IP"
  curl -s "https://www.namesilo.com/api/dns/addRecord?version=1&type=A&key=$API_KEY&domain=$DOMAIN&rrhost=$HOST&rrvalue=$IP&rrttl=3600"
else
  echo "Updating A $HOST.$DOMAIN -> $IP"
  curl -s "https://www.namesilo.com/api/dns/updateRecord?version=1&type=A&key=$API_KEY&domain=$DOMAIN&rrid=$RRID&rrhost=$HOST&rrvalue=$IP&rrttl=3600"
fi
