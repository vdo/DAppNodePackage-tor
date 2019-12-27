#!/bin/sh

# Needed defaults
export SOCKS_PORT="${SOCKS_PORT:-9050}"
export NICKNAME="${NICKNAME:-NotProvided}"
export CONTACT_INFO="${CONTACT_INFO:-NotProvided}"
export OR_PORT="${OR_PORT:-9001}"
export DIR_PORT="${DIR_PORT:-9030}"
export BANDWIDTH_RATE="${BANDWIDTH_RATE:-1 MBits}"
export BANDWIDTH_BURST="${BANDWIDTH_BURST:-2 MBits}"
export MAX_MEM="${MAX_MEM:-512 MB}"

chmod 700 /data

# Generate key if not present
if [ ! -f /data/key ]; then
  shallot -f /data/key ^ipfs
  grep 'BEGIN RSA' -A 99 /data/key >/data/private_key
fi

# Show Tor hidden service address
address=$(grep Found /data/key | cut -d ':' -f 2)
echo "##############################################"
echo
echo "Hidden service address: ${address}"
echo
echo "##############################################"

# Re-generate config with env vars
echo -e "SOCKSPort 0.0.0.0:$SOCKS_PORT\n\
SOCKSPolicy accept *\n\
SOCKSPolicy accept6 *\n\
DisableDebuggerAttachment 0\n\
ORPort $OR_PORT\n\
Nickname $NICKNAME\n\
ContactInfo $CONTACT_INFO\n\
RelayBandwidthRate $BANDWIDTH_RATE\n\
RelayBandwidthBurst $BANDWIDTH_BURST\n\
MaxMemInQueues $MAX_MEM\n\
DirPort $DIR_PORT\n\
ExitRelay 0\n\
ExitPolicy reject *:*\n\
HiddenServiceDir /data/\n\
HiddenServicePort 80 172.33.1.5:8080" >"/etc/tor/torrc"

exec /usr/bin/tor
