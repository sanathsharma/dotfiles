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

# Shortcuts

- `<prefix>?` - list all shortcuts (q - exit)
- `<prefix><` - current pane's options
- `<prefix>>` - current split's options
- `<prefix>num` - jump to `num` pane
- `<prefix>,` - rename current pane
- `<prefix>c` - open new pane
- `<prefix>$` - rename session
- `<prefix>%` - split vertical pane
- `<prefix>"` - split horizontal pane
- `<prefix>&` - kill current session
- `<prefix>x` - kill current pane
