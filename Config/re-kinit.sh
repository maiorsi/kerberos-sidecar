#!/bin/sh

[[ "$PERIOD_SECONDS" == "" ]] && PERIOD_SECONDS=3600

if [[ "$OPTIONS" == "" ]]; then
    [[ -e /krb5/krb5.keytab ]] && OPTIONS="-k" && echo "*** using host keytab"
    [[ -e /krb5/client.keytab ]] && OPTIONS="-k -i" && echo "*** using client keytab"
fi

[[ -z "$(ls -A /krb5)" ]] && echo "*** Warning default keytab (/krb5/krb5.keytab) or default client keytab (/krb5/client.keytab) not found"

while true; do
    # Report to stdout the time the kinit is being run
    echo "*** kinit at " $(date -R)

    # Run the kinit with the passed options, not APPEND_OPTIONS allows for additional parameters to be configured
    kinit -v $OPTIONS $APPEND_OPTIONS

    # Report the valid tokens
    klist -c /dev/shm/ccache

    # Sleep for the defined period, then repeat
    echo "*** Waiting for $PERIOD_SECONDS seconds"
    sleep $PERIOD_SECONDS
done