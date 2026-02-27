#!/bin/bash

# CoinGecko skill script
# Usage: coingecko.sh --action get_price|get_market_data --coin <id> [--vs <currency>]

set -euo pipefail

while [[ $# -gt 0 ]]; do
  case $1 in
    --action) ACTION="$2"; shift 2 ;;
    --coin)   COIN="$2";   shift 2 ;;
    --vs)     VS="$2";     shift 2 ;;
    *) echo "Unknown argument: $1"; echo "Usage: $0 --action <action> --coin <coin> [--vs <vs>]"; exit 1 ;;
  esac
done

if [ -z "${ACTION:-}" ] || [ -z "${COIN:-}" ]; then
  echo "Error: --action and --coin are required"
  exit 1
fi

if [ "$ACTION" = "get_price" ] && [ -z "${VS:-}" ]; then
  echo "Error: --vs is required for get_price action"
  exit 1
fi

case "$ACTION" in
  get_price)
    URL="https://api.coingecko.com/api/v3/simple/price?ids=${COIN}&vs_currencies=${VS}"
    ;;
  get_market_data)
    URL="https://api.coingecko.com/api/v3/coins/${COIN}"
    ;;
  *)
    echo "Error: Invalid action '${ACTION}'. Use: get_price or get_market_data"
    exit 1
    ;;
esac

RESPONSE=$(curl -s -f -m 10 "$URL" || echo "")

if [ -z "$RESPONSE" ]; then
  echo "Error: CoinGecko API request failed (network issue, invalid coin, rate limit, or timeout)"
  exit 1
fi

# Try pretty-print with jq if available, else raw
if command -v jq &> /dev/null; then
  echo "$RESPONSE" | jq . || echo "$RESPONSE"
else
  echo "$RESPONSE"
fi