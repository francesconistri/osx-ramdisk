#!/usr/bin/env bash

create() {
    local mount_point="$1"
    local size_in_mb="$2"
    local label="$3"
    local device
    local total_ram_size
    local size_in_sectors
    local ramdisk_size_ratio_of_total=8
    # these local variable are set by eval
    local st_uid
    local st_gid
    local st_mode

    if [[ -z "$mount_point" ]]; then
        echo "must provide at least a mount point"
        exit 1
    fi

    if [[ -z "$size_in_mb" ]]; then
        total_ram_size=$(sysctl hw.memsize | awk '{print $2;}')
        default_size_in_mb=$((total_ram_size / 1024 / 1024 / ramdisk_size_ratio_of_total))
        size_in_mb="$default_size_in_mb"
    fi

    if [[ -z "$label" ]]; then
        label="RAMDisk-$(uuid)"
    fi

    size_in_sectors=$((size_in_mb*1024*1024/512))
    # create ram disk
    echo "Creating ramdisk of $size_in_mb mb..."

    device=$(hdiutil attach -nomount ram://${size_in_sectors} | xargs) || exit 1
    echo "Created ramdisk: $device"
    # seems to help with preventing issue where some disks did not mount
    sleep 1
    # success
    echo "Formatting ramdisk with hfs..."
    newfs_hfs -v "$label" "$device" || exit 1
    echo "Formatting ramdisk with hfs..."
    # Store permissions from old mount point.
    eval "$(/usr/bin/stat -s "$mount_point")"
    # Mount the RAM disk to the target mount point.
    sudo mount -t hfs -o noatime -o union -o nobrowse "$device" "$mount_point" || exit 1
    # Restore permissions like they were on old volume.
    sudo chown $st_uid:$st_gid "$mount_point" || exit 1
    sudo chmod $st_mode "$mount_point" || exit 1
}

delete() {
    local device="$1"
    sudo umount -f "$device" || exit 1
    sudo hdiutil detach "$device" || exit 1
}

set -x
subcommand="$1"
if [ "$subcommand" = "create" ]
then
    create "$2" "$3"
elif [ "$subcommand" = "delete" ]
then
    delete "$2"
fi
