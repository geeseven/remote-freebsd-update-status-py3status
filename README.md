# remote-freebsd-update-status-py3status

This is my cobbled together solution to get update status of a remote FreeBSD system in [py3status][0].

## Setup

- Copy `freebsd-update-status.sh` and `freebsd-release-stats.sh` from [mkhon/zabbix-freebsd-release][1] into the same direcotry on the FreeBSD system.
- Set up root cronjob to run `pkg update`.
- Set up a non root cronjob to run `freebsd-update-status.sh |tee /usr/local/www/status.example.com/info.json`.
- Configure status.example.com in your webserver of choice with whatever secutiry you see fit.  I did SSL and basic access authentication.
- Configure py3status somelike like:

```
getjson freebsd {
    url = "https://status.example.com/info.json"
    username = "user"
    password = "pass"
    format = "FreeBSD {system}/{pkg}"
    cache_timeout = 300
}
```

## example output

```
FreeBSD 1/5
```

This means there is a pending system update via `freebsd-update` and five package upgrades via `pkg`.


[0]: https://github.com/ultrabug/py3status
[1]: https://github.com/mkhon/zabbix-freebsd-release
