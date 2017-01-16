etcd-aws-cluster
==============

This container serves to assist in the creation of an etcd (2.x) cluster from an AWS auto scaling group. It writes the following etcd environment to `/etc/sysconfig/etcd.env`:

- `ETCD_INITIAL_CLUSTER_STATE`
  - either `new` or `existing`
- `ETCD_NAME`
  - the name of the machine joining the etcd cluster, need not be unique
  - set to the private dns name of the ec2 instance
- `ETCD_INITIAL_CLUSTER`
  - the list of the members (name and advertised peer URL) expected to be in the cluster, including the new instance

Workflow
--------

- Get the instance id and hostname from the ec2 instance metadata API
- Get the autoscaling group the instance belongs to from the autoscaling API
- Obtain the ip of every member of the autoscaling group
- For each member of the autoscaling group detect if they are running etcd and if so, who they see as members of the cluster
- If no machines respond OR there are existing peers but the instance is listed as a member of the cluster
  - Assume that the instance is part of a new cluster
  - Set the initial cluster to the instances listed by the autoscaling group
- Else
  - Assume that the instance is joining an existing cluster
  - Check whether any instance listed as a cluster member is not listed by the autoscaling group
    -  If so remove it from the etcd cluster
  - Make the instance a member of the existing cluster
  - Set the initial cluster to the members listed by an existing etcd  member
- Write the etcd environment

Usage
-----

Environment Variables
- `PROXY_ASG` - If specified forces into proxy=on and uses the vaue of PROXY_ASG as the autocaling group that contains the master servers
- `ASG_BY_TAG` - If specified in conjunction with PROXY_ASG uses the value of PROXY_ASG to look up the server by the Tag Name
- `ETCD_CLIENT_SCHEME` - defaults to http
- `ETCD_PEER_SCHEME` - defaults to http
- `DEBUG` - enables verbose logging

This is a fork of https://github.com/MonsantoCo/etcd-aws-cluster/
