#!/bin/sh

PATH=/sbin:/bin

test -f /usr/sbin/ntpdate || exit 0

if test -f /etc/default/ntpdate ; then
. /etc/default/ntpdate
else
NTPSERVERS="pool.ntp.org"
fi

test -n "$NTPSERVERS" || exit 0

case "$1" in
start|force-reload)
  echo -n "Running ntpdate to synchronize clock"
  /usr/sbin/ntpdate -b -s $NTPOPTIONS $NTPSERVERS
  echo "."
  ;;
restart|reload)
  # Drop -b to slew clock rather than step it if called after system is up
  echo -n "Running ntpdate to synchronize clock"
  /usr/sbin/ntpdate -s $NTPOPTIONS $NTPSERVERS
  echo "."
  ;;
stop)
  ;;
*)
  echo "Usage: /etc/init.d/ntpdate {start|stop|restart|reload|force-reload}"
  exit 1
esac

exit 0
