#!/bin/bash

PARTITION_UUID="56ddf4d1-2be3-40a5-ae3f-06eeb9ce0794" # Replace with yours
USERNAME="moutasim"

MOUNT_SOURCE="/mnt/source"
MOUNT_DEST="/home/$USERNAME"

sudo mkdir -p "$MOUNT_SOURCE"

if ! grep -q "UUID=$PARTITION_UUID $MOUNT_SOURCE" /etc/fstab; then
    echo "UUID=$PARTITION_UUID $MOUNT_SOURCE ext4 defaults 0 2" | sudo tee -a /etc/fstab
fi

sudo mount -a

sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/Desktop" "$MOUNT_DEST/Desktop"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/Development" "$MOUNT_DEST/Development"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/Documents" "$MOUNT_DEST/Documents"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/Downloads" "$MOUNT_DEST/Downloads"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/Pictures" "$MOUNT_DEST/Pictures"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/VMs" "$MOUNT_DEST/VMs"
sudo mount --bind -o x-gvfs-hide "$MOUNT_SOURCE/ssh" "$MOUNT_DEST/.ssh"


echo "Partition mounting script completed."
