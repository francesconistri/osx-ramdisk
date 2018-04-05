#!/usr/bin/env bash

subcommand="$1"
ramdisk_script="/usr/local/bin/ramdisk.sh"

if [ -z "$subcommand" ]; then
echo "Usage: $0 [start|stop|restart] "
    exit 1
fi

# Source the common setup functions for startup scripts
test -r /etc/rc.common || exit 1
# shellcheck disable=SC1091
. /etc/rc.common

StartService () {
    echo "Starting ramdisks ..."
    $ramdisk_script create /private/tmp 256 ramdisk-tmp
    $ramdisk_script create /private/var/run 64 ramdisk-var-run
    # $ramdisk_script create /private/var/folders 1024
    $ramdisk_script create /Users/francesconistri/local/tmp 1024 ramdisk-home-local-tmp
}

StopService () {
    echo "Stopping ramdisks ..."
    $ramdisk_script delete /private/tmp
    $ramdisk_script delete /private/var/run
    # $ramdisk_script delete /private/var/folders
    $ramdisk_script delete /Users/francesconistri/local/tmp
}

RestartService () {
    echo "Restarting ramdisks ..."
    StopService
    StartService
}

RunService "$subcommand"