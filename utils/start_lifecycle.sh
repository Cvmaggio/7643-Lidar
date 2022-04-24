#!/bin/bash

set -e

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0f99c128a9971b1bf.efs.us-east-1.amazonaws.com:/ /home/ec2-user/SageMaker/efs
    
sudo chmod go+rw /home/ec2-user/SageMaker/efs