#!/bin/sh -e

PATH=/sbin:/bin:/usr/bin

test -f /usr/sbin/ntpd || exit 0

RUNASUSER=ntp
UGID=$(getent passwd $RUNASUSER | cut -f 3,4 -d:) || true

if [ -z "$UGID" ]; then
  echo "User $RUNASUSER does not exist" >&2
  exit 1
fi

case "$1" in
	start)
		echo -n "Starting NTP server: ntpd"
  		start-stop-daemon --start --quiet --oknodo --pidfile /var/run/ntpd.pid --startas /usr/sbin/ntpd -- -p /var/run/ntpd.pid -u $UGID
		echo "."
  		;;
	stop)
		echo -n "Stopping NTP server: ntpd"
  		start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/ntpd.pid
		echo "."
		rm -f /var/run/ntpd.pid
  		;;
	restart|force-reload)
		echo -n "Restarting NTP server: ntpd... "
  		start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/ntpd.pid
  		sleep 2
  		start-stop-daemon --start --quiet --oknodo --pidfile /var/run/ntpd.pid --startas /usr/sbin/ntpd -- -p /var/run/ntpd.pid -u $UGID
		echo "done."
  		;;
	reload)
		echo "Not supported, sorry. Use 'restart' or 'force-reload'." >&2
		exit 1
		;;
	*)
  		echo "Usage: /etc/init.d/ntp-server {start|stop|restart|force-reload}"
  		exit 1
		;;
esac

exit 0
