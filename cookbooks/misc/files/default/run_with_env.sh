#!/bin/bash
#
# Usage:
#   run_with_env.sh <envfile> program [args...]
#
# This will load the environment in envfile and execute the program
# with the given environment set.
#
# The environment file should look like this:
#
#  VARNAME=value
#  VARSPACES="a string with spaces"
#
# The file is evaluated in the shell context, so you could also do:
#
#  THEDATE="`date`"
#
# Which would set the variable to the date at the time this program was
# invoked.
#
####

# Prints message to standard error
function errmsg()
{
	echo $* >&2
}

if [ $# -lt 2 ]; then
	errmsg "Usage: run_with_env.sh <envfile> program [args...]"
	exit 1
fi

ENVFILE=$1
shift

if [ -r $ENVFILE ]; then
	# Pull all lines that start with VAR=VALUE and prefix them with
	# an 'export ' to ensure those variables are propagated to the
	# sub-program. Everything else is left as is.
	#
	ENVSRC=`cat $ENVFILE | awk '/^[[:alnum:]][[:alnum:]_]*=/{print "export " $LN}!/^[[:alnum:]][[:alnum:]_]*=/{print $LN}'`
	if [ $? -ne 0 ]; then
		errmsg "Failed to parse $ENVFILE"
		exit 1
	fi

	eval "$ENVSRC"
	if [ $? -ne 0 ]; then
		errmsg "Failed to eval source file contents: $ENVSRC"
		exit 1
	fi
else
	errmsg "Can not read environment file: $ENVFILE"
	exit 1
fi

exec "$@"

# Don't get here unless failure
exit 127
