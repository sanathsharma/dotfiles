### Updating timezone in a docker container
```sh
rm -rf /etc/localtime
rm -rf /etc/timezone
```

and link timezone from /usr/share/zoneinfo (folder exists only if `tzdate` exists in the container)
```sh
ln -s /usr/share/zoneinfo/Asia/Calcutta /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Calcutta /etc/timezone
```
