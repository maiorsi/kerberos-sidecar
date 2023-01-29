# Kerberos Sidecar

Kerberos Sidecar Container Image for Windows Auth to Kerberised Services.

## Building

```sh
docker build -t kerberos-sidecar:latest .
```

## Usage

The entry point for this container image is `re-kinit.sh` located at `Config/re-kinit.sh`.

This shell file initialises kerberos using `kinit` based on a host or client keytab (**at least one of these must be passed into the container as a mounted file at `/krb5/host.keytab` or `/krb5/client.keytab` respectively**).

Domain specific kerberos authentication needs to be mounted at `/etc/krb5.conf.d/` (See example at `Config/domain.example.conf`).

It periodically (default `5s`) re-initialises to keep the kerberos cache up-to-date.

The kerberos configuration defaults to storing the cache at `/dev/shm/ccache`.

This mount point is shared with the main application container at the **same location** with the **same kerberos configuration**.

### Keytab Generation Example 1

```powershell
ktpass -out client.keytab -princ HTTP/client.example.com@EXAMPLE.COM -mapuser service_client@EXAMPLE.COM -pass * -crypto AES256-SHA1 -ptype KRB5_NT_PRINCIPAL
```

### Keytab Generation Example 2

```sh
ktutil
ktutil> addent -password -p service_account@EXAMPLE.COM -k 0 -e rc4-hmac
# Enter password
ktutil> wkt client.keytab
ktutil> quit
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)