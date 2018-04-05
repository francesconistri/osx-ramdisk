#!/usr/bin/env bash

subcommand="$1"
ramdisk_script="ramdisk.sh"

if [ -z "$subcommand" ]; then
echo "Usage: $0 [start|stop|restart] "
    exit 1
fi

# Source the common setup functions for startup scripts
test -r /etc/rc.common || exit 1
# shellcheck disable=SC1091
. /etc/rc.common

StartService () {
    ConsoleMessage "Starting ramdisks ..."
    $ramdisk_script create /private/tmp 256
    $ramdisk_script create /private/var/run 64
    $ramdisk_script create /private/var/folders 1024
}

StopService () {
    ConsoleMessage "Stopping ramdisks ..."
    $ramdisk_script delete /private/tmp
    $ramdisk_script delete /private/var/run
    $ramdisk_script delete /private/var/folders
}

RestartService () {
    ConsoleMessage "Restarting ramdisks ..."
    StopService
    StartService
}

RunService "$subcommand"