#!/bin/bash

PARTITION_UUID="uuid_here"
USERNAME="moutasim"

declare -A DIRECTORY_MAPPING=(
    ["Development"]="/mnt/development"
    ["Documents"]="/mnt/documents"
    ["Downloads"]="/mnt/downloads"
    ["Pictures"]="/mnt/pictures"
    ["VMs"]="/mnt/vms"
    [".ssh"]="/mnt/ssh"
)

for mount_point in "${DIRECTORY_MAPPING[@]}"; do
    sudo mkdir -p "$mount_point"
done

for dir in "${!DIRECTORY_MAPPING[@]}"; do
    echo "UUID=$PARTITION_UUID ${DIRECTORY_MAPPING[$dir]} ext4 defaults 0 2" | sudo tee -a /etc/fstab
done

sudo mount -a

echo "Partition mounting script completed."
