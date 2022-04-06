alias aws='awscliv2'

echo $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 520713654638.dkr.ecr.us-east-1.amazonaws.com)

# The name of our algorithm
algorithm_name=lidar

cd container
account=$(aws sts get-caller-identity --query Account --output text)
remote_account=520713654638

# Get the region defined in the current configuration (default to us-east-1 if none defined)
region=$(aws configure get region)
region=${region:-us-east-1}


fullname="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}:latest"


# If the repository doesn't exist in ECR, create it.
aws ecr describe-repositories --repository-names "${algorithm_name}" > /dev/null 2>&1

if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${algorithm_name}" > /dev/null
fi

# Get the login command from ECR and execute it directly
echo $(aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.us-east-1.amazonaws.com)
# Get the login command from ECR in order to pull down the SageMaker PyTorch image

echo $(aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${remote_account}.dkr.ecr.${region}.amazonaws.com)

# Build the docker image locally with the image name and then push it to ECR
# with the full name.

docker build  -t ${algorithm_name} . --build-arg REGION=${region}
docker tag ${algorithm_name} ${fullname}

docker push ${fullname}