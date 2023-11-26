#!/bin/bash

PARTITION_UUID="uuid_here"

USERNAME="moutasim"

DIRECTORIES=("Development" "Documents" "Downloads" "Pictures" "VMs" ".ssh")

for dir in "${DIRECTORIES[@]}"; do
    echo "UUID=$PARTITION_UUID /home/$USERNAME/$dir ext4 defaults 0 2" | sudo tee -a /etc/fstab
done

sudo mount -a

echo "Partition mounting script completed."
