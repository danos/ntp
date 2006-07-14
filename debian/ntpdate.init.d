#!/bin/sh

### BEGIN INIT INFO
# Provides:        $time
# Required-Start:  $remote_fs $network hwclock
# Required-Stop:   $remote_fs $network hwclock
# Default-Start:   S 1 2 3 4 5
# Default-Stop:    0 6
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin

. /lib/lsb/init-functions

NAME=ntpdate
PROG=/usr/sbin/ntpdate

test -x $PROG || exit 5

if [ -r /etc/default/$NAME ]; then
	. /etc/default/$NAME
fi

test -n "$NTPSERVERS" || exit 6

case $1 in
	start|force-reload)
		log_action_begin_msg "Running ntpdate to synchronize clock"
		$PROG -b -s $NTPOPTIONS $NTPSERVERS
		log_action_end_msg $?
		;;
	restart|try-restart|reload)
		# Drop -b to slew clock rather than step it if called after system is up
		log_action_begin_msg "Running ntpdate to synchronize clock"
		$PROG -s $NTPOPTIONS $NTPSERVERS
		log_action_end_msg $?
		;;
	stop)
		exit 0
		;;
	status)
		exit 0
		;;
	*)
		echo "Usage: $0 {start|stop|restart|try-restart|force-reload|reload}"
		exit 2
		;;
esac
