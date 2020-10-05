#!/usr/bin/env bash

# get the number of outdated packages
# https://forums.freebsd.org/threads/complete-server-monitoring-tool.61056/#post-351396
pkg_number=$(pkg version --quiet --verbose --remote --like '<' | grep --count '<')

# script from https://github.com/mkhon/zabbix-freebsd-release
# sample json created from that script
# { "running": "12.1-RELEASE-p1", "latest": "12.1-RELEASE-p1", "eol": 1604793600 }

# I don't want to use /var/db/zabbix/ so lets set the location as the same as this script.
CURRENT_DIR=$(dirname "$0")
export FREEBSD_UPDATE_PUB_SSL=$CURRENT_DIR"/freebsd-update-pub.ssl"

# get running and latest version so we can compare them 
# borrowed from https://stackoverflow.com/a/43293515
# fails shellcheck, need to investigate why
read -r running latest < <(echo $("$CURRENT_DIR"/freebsd-release-stats.sh |jq '.running, .latest'))

if [[ $running == "$latest" ]]; then
	outdated=0
else
	outdated=1
fi

# using |tee instead of > to avoid a build up of file like /tmp/sh-np.WzhcIS
echo '{"pkg":'"$pkg_number"', "system":'"$outdated"'}'
