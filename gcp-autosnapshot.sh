#!/bin/bash

# This script backs up all disks with the label `labels.backup=yes` set this on a cronjob. This will set backup frequency
gcloud compute disks list --format='value(name,zone)' --filter='labels.backup=yes' | while read DISK_NAME ZONE; do
  gcloud compute disks snapshot $DISK_NAME --zone $ZONE --snapshot-names auto-$DISK_NAME-$(date "+%s")
  gcloud compute snapshots delete auto-$DISK_NAME --quiet
  gcloud compute disks snapshot $DISK_NAME --zone $ZONE --snapshot-names auto-$DISK_NAME
done

# This deletes all snapshots older than a month. This can be changed in the `--filter=""` param
gcloud compute snapshots list --filter="name:(auto-*)" --filter="creationTimestamp<-P4W" --uri | while read SNAPSHOT_URI; do
  gcloud compute snapshots delete $SNAPSHOT_URI --quiet
done
