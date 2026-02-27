---
name: coingecko
description: "Fetch cryptocurrency prices and market data from CoinGecko API"
version: 1.0.0
author: grok-assisted
requires_tools: [run_skill_script]
requires_binaries: [curl]
scripts: [coingecko.sh]
requires_api_keys: []
tags: [defi, crypto, price, market, api]
arguments:
  action:
    description: "Action to perform: get_price or get_market_data"
    required: true
  coin:
    description: "Coin ID (e.g., bitcoin, ethereum, solana)"
    required: true
  vs:
    description: "Quote currency (e.g., usd, eur, eth) - required for get_price"
    required: false
---

# CoinGecko Skill

This skill allows StarkBot to retrieve real-time cryptocurrency prices and detailed market data from the free CoinGecko public API.  
Very useful for DeFi autonomy: check prices before swaps, monitor risk, trigger rebalancing, alerts, etc.

## Supported Actions
- **get_price**: Current price in specified currency  
  Required: coin, vs  
  Example output: {"bitcoin":{"usd":95000.5}}
- **get_market_data**: Full coin data (market cap, 24h volume, price change %, etc.)  
  Required: coin  
  Example output: JSON from /coins/{id}

## How the agent should use it
1. Parse user request to determine action, coin, vs.
2. Call run_skill_script with:
   - script: "coingecko.sh"
   - args: "--action get_price --coin bitcoin --vs usd"
3. Parse JSON output and provide natural language response.
4. On error (invalid coin, network issue, missing param): inform user, suggest fix, or retry.

## Edge Cases Handled in Prompt & Script
- Missing required params → script exits with clear error
- Invalid coin ID → API returns empty → script errors out
- API failure / rate limit → script detects empty response
- No jq installed → falls back to raw JSON output

## Usage Example
User: "What's the current price of ETH in USD?"
→ Agent calls: run_skill_script("coingecko.sh", "--action get_price --coin ethereum --vs usd")
→ Parses → Responds: "Ethereum is currently trading at $3,450 USD."