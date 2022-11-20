#!/bin/bash
RPC_PATH="bitcoin-cli --rpcport=17600"
DATA_DIR="$HOME/.bitcoin"
SIZE=$(df --output=size $DATA_DIR | tail -1)
MIN_FREE=$((SIZE / 20))	# Prune when <5% free remains
prev_space=$SIZE
start_time=$(date +%s)
delay=30
hours=168
while test -f "$DATA_DIR/bitcoin.pid"; do
	avail_space=$(df --output=avail $DATA_DIR | tail -1 | head -c-2)
	speed=$(( (prev_space - avail_space) / (start_time - $(date +%s))))
	if (( avail_space < MIN_FREE )); then
		# performs a maximum prune so the dbcache gets flushed less often, not necessarily faster but wears the flash drive less.
		"$RPC_PATH" pruneblockchain $("$RPC_PATH" getblockcount)
		avail_space=$(df --output=avail $DATA_DIR | tail -1 | head -c-2)
		prev_space=$avail_space
		start_time=$(date +%s)
		hours=168
	fi
	delay=$(( (avail_space - MIN_FREE) / speed ))
	(( delay / 3600 < hours )) && zenity --notification --text="Bitcoin Core will prune in $((hours/24)) days $((hours%24)) hours. Open any closed\nwallets before then to avoid having to resync the entire chain." && hours=$(( delay / 3600 ))
	delay=$(( delay > 60 ? 30 : $((delay < 2 ? 1 : delay/2)) ))
	sleep $delay
done
