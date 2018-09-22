# Kubernetes cluster

Foreword:

Amazon Web Services (AWS) has its own [managing service for kubernetes](https://aws.amazon.com/eks/). However it is still being worked on so the api will be likely to change in the near future, the "word on the street" is that it will integrate nicely with other aws services for monitoring and debugging!

In the meantime this doc will focus on getting you started with the Kubernetes Operations [kops](https://github.com/kubernetes/kops) manager.

## Requirements

- an AWS account and access keys
- a cup of coffee

## Local Setup

### Installation Steps

1. [Install brew](https://brew.sh/)
2. [Install python](https://docs.brew.sh/Homebrew-and-Python) 
3. [Install the AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
4. [Install kops](https://github.com/kubernetes/kops#installing)

### Configuration Steps

1. Configure aws:

    ```
    aws configure
    AWS Access Key ID [None]: AccessKeyValue
    AWS Secret Access Key [None]: SecretAccessKeyValue
    Default region name [None]: us-east-1
    Default output format [None]:
    ```

2. Create a bucket for kops:

    It is important that you specify the region as `us-east-1` to avoid extra configuration steps
    
    ```
    BUCKET_NAME=example-bucket-name
    
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region us-east-1
    
    aws s3api put-bucket-versioning \
        --bucket $BUCKET_NAME \
        --versioning-configuration Status=Enabled
    ```

3. Expose kops constants:
    
    There are different ways to configure the [dns lookup for the cluster](https://github.com/kubernetes/kops/blob/master/docs/aws.md#configure-dns).
    _Ensure your cluster name ends with `.k8s.local`_
    to enable [gossip protocol](https://en.wikipedia.org/wiki/Gossip_protocol)
    
    ``
    export KOPS_CLUSTER_NAME=explample-name.k8s.local
    export KOPS_STATE_STORE=s3://$BUCKET_NAME
    ``
    
    -   OPTIONAL: Add constants to your profile
    
    replace `.bash_profile` with your default shell `.zshrc` ... 

    ```
    echo "
    export KOPS_CLUSTER_NAME=explample-name.k8s.local
    export KOPS_STATE_STORE=s3://$BUCKET_NAME
    " >> ~/.bash_profile
    ```

## Create cluster

1.  Create a cluster definition
    
    At this point you should decide what resources to create [see link](https://github.com/kubernetes/kops/blob/master/docs/cli/kops_create_cluster.md). The script below has a simple config to get you started.
    
    NOTE: kops doesn't seem to support multi-user settings from aws, make sure your aws user for this cluster is set as default
    
    [ec2 instances](https://aws.amazon.com/ec2/pricing/on-demand/)

    
    ```
     sh kubernetes/cluster/cluster-definition.sh
    ```

2. Spin up the cluster on AWS

    ```
    sh kubernetes/cluster/cluster-update.sh
    ```

These are very simple commands that are written as bash scripts for revision purposes.

## Troubleshooting

1. Check cluster availability `kops validate cluster`

    ```
    $ kops validate cluster
    
    ...
    ...
    ...
    
    Your cluster KOPS_CLUSTER_NAME.k8s.local is ready
    ```
    
2. Check that your configuration setting have been stored at `~/.kube/config`


## Remove cluster

```
kops delete cluster ${KOPS_CLUSTER_NAME} --yes
```