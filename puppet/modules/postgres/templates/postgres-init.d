#!/bin/sh
#
# postgresql    This is the init script for starting up the PostgreSQL
#               server.
#
# chkconfig: - 64 36
# description: PostgreSQL database server.
# processname: postmaster
# pidfile: /var/run/postmaster-9.1.pid or  /var/run/postmaster-9.3.pid

# This script is slightly unusual in that the name of the daemon (postmaster)
# is not the same as the name of the subsystem (postgresql)

# Version 9.0 Devrim Gunduz <devrim@gunduz.org>
# Get rid of duplicate PGDATA assignment.
# Ensure pgstartup.log gets the right ownership/permissions during initdb

# Version 9.1 Devrim Gunduz <devrim@gunduz.org>
# Update for 9.1
# Add an option to initdb to specify locale (default is $LANG):
# service postgresql initdb tr_TR.UTF-8

# PGVERSION is the full package version, e.g., 9.1.0
# Note: the specfile inserts the correct value during package build
PGVERSION=<%= postgresVersion %>
# PGMAJORVERSION is major version, e.g., 9.1 (this should match PG_VERSION)
PGMAJORVERSION=<%= postgresMajorVersion %>

# Source function library.
INITD=/etc/rc.d/init.d
. $INITD/functions

# Get function listing for cross-distribution logic.
TYPESET=`typeset -f|grep "declare"`

# Get network config.
. /etc/sysconfig/network

# Find the name of the script
NAME=`basename $0`
if [ ${NAME:0:1} = "S" -o ${NAME:0:1} = "K" ]
then
	NAME=${NAME:3}
fi

# For SELinux we need to use 'runuser' not 'su'
if [ -x /sbin/runuser ]
then
    SU=runuser
else
    SU=su
fi

# Define variable for locale parameter:
LOCALEPARAMETER=$2

# Set defaults for configuration variables
PGENGINE=/usr/pgsql-<%= postgresMajorVersion %>/bin
PGPORT=5432
PGDATA=<%= pg_data_dir %>
PGLOG=<%= pg_log_dir %>/pgstartup.log

# Override defaults from /etc/sysconfig/pgsql if file is present
[ -f /etc/sysconfig/pgsql/${NAME} ] && . /etc/sysconfig/pgsql/${NAME}

export PGDATA
export PGPORT

lockfile="/var/lock/subsys/${NAME}"
pidfile="/var/run/postmaster-<%= postgresMajorVersion %>.pid"

[ -f "$PGENGINE/postmaster" ] || exit 1

script_result=0

start(){
	[ -x "$PGENGINE/postmaster" ] || exit 5

	PSQL_START=$"Starting ${NAME} service: "

	# Make sure startup-time log file is valid
	if [ ! -e "$PGLOG" -a ! -h "$PGLOG" ]
	then
		touch "$PGLOG" || exit 1
		chown <%= postgresUser %>:postgres "$PGLOG"
		chmod go-rwx "$PGLOG"
		[ -x /sbin/restorecon ] && /sbin/restorecon "$PGLOG"
	fi

	# Check for the PGDATA structure
	if [ -f "$PGDATA/PG_VERSION" ] && [ -d "$PGDATA/base" ]
	then
		# Check version of existing PGDATA

		if [ x`cat "$PGDATA/PG_VERSION"` != x"$PGMAJORVERSION" ]
		then
			SYSDOCDIR="(Your System's documentation directory)"
			if [ -d "/usr/doc/postgresql-$PGVERSION" ]
			then
				SYSDOCDIR=/usr/doc
			fi
			if [ -d "/usr/share/doc/postgresql-$PGVERSION" ]
			then
				SYSDOCDIR=/usr/share/doc
			fi
			if [ -d "/usr/doc/packages/postgresql-$PGVERSION" ]
			then
				SYSDOCDIR=/usr/doc/packages
			fi
			if [ -d "/usr/share/doc/packages/postgresql-$PGVERSION" ]
			then
				SYSDOCDIR=/usr/share/doc/packages
			fi
			echo
			echo $"An old version of the database format was found."
			echo $"You need to upgrade the data format before using PostgreSQL."
			echo $"See $SYSDOCDIR/postgresql-$PGVERSION/README.rpm-dist for more information."
			exit 1
		fi
	else
		# No existing PGDATA! Warn the user to initdb it.

		echo
		echo "$PGDATA is missing. Use \"service postgresql-$PGMAJORVERSION initdb\" to initialize the cluster first."
		echo_failure
		echo
		exit 1
 	fi

	echo -n "$PSQL_START"
	$SU -l <%= postgresUser %> -c "$PGENGINE/postmaster -p '$PGPORT' -D '$PGDATA' ${PGOPTS} &" >> "$PGLOG" 2>&1 < /dev/null
	sleep 2
	pid=`head -n 1 "$PGDATA/postmaster.pid" 2>/dev/null`
	if [ "x$pid" != x ]
	then
		success "$PSQL_START"
		touch "$lockfile"
		echo $pid > "$pidfile"
		echo
	else
		failure "$PSQL_START"
		echo
		script_result=1
	fi
}

stop(){
	echo -n $"Stopping ${NAME} service: "
	if [ -e "$lockfile" ]
	then
		$SU -l <%= postgresUser %> -c "$PGENGINE/pg_ctl stop -D '$PGDATA' -s -m fast" > /dev/null 2>&1 < /dev/null
		ret=$?
		if [ $ret -eq 0 ]
		then
			echo_success
			rm -f "$pidfile"
			rm -f "$lockfile"
		else
			echo_failure
			script_result=1
		fi
		else
			# not running; per LSB standards this is "ok"
			echo_success
		fi
		echo
}

restart(){
    stop
    start
}

initdb(){
			# If the locale name is specified just after the initdb parameter, use it:
			if [ -z $LOCALEPARAMETER ]
			then
				LOCALE=`echo $LANG`
			else
				LOCALE=`echo $LOCALEPARAMETER`
			fi
				LOCALESTRING="--locale=$LOCALE"

		if [ -f "$PGDATA/PG_VERSION" ]
		then
			echo "Data directory is not empty!"
			echo_failure
		else
			echo -n $"Initializing database: "
			if [ ! -e "$PGDATA" -a ! -h "$PGDATA" ]
			then
				mkdir -p "$PGDATA" || exit 1
				chown <%= postgresUser %>:postgres "$PGDATA"
				chmod go-rwx "$PGDATA"
			fi
			# Clean up SELinux tagging for PGDATA
			[ -x /sbin/restorecon ] && /sbin/restorecon "$PGDATA"

			# Make sure the startup-time log file is OK, too
			if [ ! -e "$PGLOG" -a ! -h "$PGLOG" ]
			then
				touch "$PGLOG" || exit 1
				chown <%= postgresUser %>:postgres "$PGLOG"
				chmod go-rwx "$PGLOG"
				[ -x /sbin/restorecon ] && /sbin/restorecon "$PGLOG"
			fi

			# Initialize the database
			$SU -l <%= postgresUser %> -c "$PGENGINE/initdb --pgdata='$PGDATA' --auth='ident' $LOCALESTRING" >> "$PGLOG" 2>&1 < /dev/null

			# Create directory for postmaster log
			mkdir "$PGDATA/pg_log"
			chown <%= postgresUser %>:postgres "$PGDATA/pg_log"
			chmod go-rwx "$PGDATA/pg_log"

			[ -f "$PGDATA/PG_VERSION" ] && echo_success
			[ ! -f "$PGDATA/PG_VERSION" ] && echo_failure
			echo
		fi
}
condrestart(){
	[ -e "$lockfile" ] && restart || :
}

reload(){
    $SU -l <%= postgresUser %> -c "$PGENGINE/pg_ctl reload -D '$PGDATA' -s" > /dev/null 2>&1 < /dev/null
}

# See how we were called.
case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  status)
	status -p /var/run/postmaster-<%= postgresMajorVersion %>.pid
	script_result=$?
	;;
  restart)
	restart
	;;
  initdb)
	initdb
	;;
  condrestart|try-restart)
	condrestart
	;;
  reload)
	reload
	;;
  force-reload)
	restart
	;;
  *)
	echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|initdb}"
	exit 2
esac

exit $script_result