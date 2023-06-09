#!/bin/sh

set -e
SETTINGS=/etc/transmission-daemon/settings.json

if [[ ! -f ${SETTINGS}.bak ]]; then
	# Checks for USERNAME variable
	if [ -z "$USERNAME" ]; then
	  echo >&2 'Please set an USERNAME variable (ie.: -e USERNAME=john).'
	  exit 1
	fi
	# Checks for PASSWORD variable
	if [ -z "$PASSWORD" ]; then
	  echo >&2 'Please set a PASSWORD variable (ie.: -e PASSWORD=hackme).'
	  exit 1
	fi
	# Modify settings.json
	sed -i.bak -e "s/#rpc-password#/$PASSWORD/" $SETTINGS
	sed -i.bak -e "s/#rpc-username#/$USERNAME/" $SETTINGS
fi

unset PASSWORD USERNAME
pf=$( cat /manual-connections/PORT_FORWARDED )
echo "$pf"

sed -i.bak -e 's#"peer-port":.*#"peer-port": 0000000000,#' $SETTINGS
sed -i.bak -e "s/0000000000/$pf/" $SETTINGS


set +e
exec /usr/bin/transmission-daemon --foreground --config-dir /etc/transmission-daemon
