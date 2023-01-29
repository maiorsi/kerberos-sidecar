FROM alpine:3.17.1

# Install krb5
RUN apk add --no-cache krb5

# Configure krb5 directory
RUN mkdir -m 755 /krb5

# Add resources; kinit scripts and krb5 configuration
ADD Config/re-kinit.sh /re-kinit.sh
ADD Config/krb5.conf /etc/krb5.conf

# Make sure all files are readable by all - Relevent for OpenShift
RUN chmod +rx /re-kinit.sh

# Configure the exported volumes
## /krb5 - default keytab location
## /dev/shm - shared memory location used to write tokens to cache
## /etc/krb5.conf.d/ - directory for additional kerberos configuration
VOLUME ["/krb5", "/dev/shm", "/etc/krb5.conf.d"]

ENTRYPOINT [ "/re-kinit.sh" ]