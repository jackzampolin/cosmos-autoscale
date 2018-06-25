# Autoscaling Sentry Node Architecture on GCE

- Create new Project, setup billing
- Use Default network or create new network
- [Create instance template](https://cloud.google.com/compute/docs/instance-templates/) for sentry nodes
  - Disks need special tag on them for snapshotting
  - Will need a disk image to put in here. Maybe start with a blank snapshot?
  - These nodes will also need to register themselves with the validator
- [Create instance template](https://cloud.google.com/compute/docs/instance-templates/) for validator node
- Create instance of validator node instance template
  - Need to figure out what peers/seeds to input here. Can we add all the peers/peers dynamically, or will process fail?
- Create managed instance group for sentry nodes
- [Create instance of managed instance group for sentry nodes](https://cloud.google.com/compute/docs/instance-groups/distributing-instances-with-regional-instance-groups)
  - [Setup autoscaling here](https://cloud.google.com/compute/docs/autoscaler/)
  - [Autoscaling on metrics](https://cloud.google.com/compute/docs/autoscaler/scaling-stackdriver-monitoring-metrics)
- Setup automatic snapshotting to overwrite the disk image used in the sentry node instance template
  - [gcp-autosnapshot.sh](./gcp-autosnapshot.sh)

# Doing it on Kubernetes - Not really an option yet

- Network Bootstrap
  - nginx-ingress / kube-lego for endpoint
  - 1 ingress that specifies common tag on sentry node services
  - Spin up sentry nodes with helm chart
  - Spin up validator with helm chart
- That whole snapshotting fiasco to get current volumes for new nodes. Lé sigh
  - https://blog.jetstack.io/blog/volume-snapshotting/
  - https://github.com/kubernetes-incubator/external-storage/blob/master/snapshot/doc/user-guide.md
  - https://github.com/kubernetes-incubator/external-storage/blob/master/snapshot/doc/examples/gce/README.md
  - https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/
- Spinning up nodes to mitigate ddos
  - No autoscaling method here currently :(
  - Would need to manually create more sentries with the helm chart
  - Sentries would also need to be manually cleaned up
  - "fix" would be to write a custom controller for this that scaled based on metrics
