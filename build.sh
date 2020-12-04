#!/bin/bash

# Stop script on any failure
set -e 

usage() { 
    echo "Usage: $0 [-e <environment dev|test|prod>] [-r <aws region e.g. us-east-1>]" 1>&2
    exit 1 
}

while getopts ":e:r:h:" o; do
    case "${o}" in
        e)
            env=${OPTARG}
            ;;
        r)
            region=${OPTARG}
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${env}" ] || [ -z "${region}" ] ; then
    usage
fi

opco="cyt"
group="host"
app="gear"

# Test if aws cli is installed
r=$(aws --version)
if [ $? -ne 0 ]; then
  echo "awscli is not installed, this is a fatal error"
  exit 1
fi

# Set the aws region
export AWS_DEFAULT_REGION=${region}

# Create ui ECR
echo "Deploying ui ECR"
aws cloudformation deploy --template-file cfn/ecr.yaml --stack-name "${env}-${app}-ui-ecr" --parameter-overrides \
Environment=${env} \
AppName=${app} \
Opco=${opco} \
Group=${group} \
Service=ui \
--tags \
dhr-opco=${opco} \
dhr-group=${group} \
dhr-app=${app} \
dhr-env=${env} \

# Create engine ECR
echo "Deploying engine ECR"
aws cloudformation deploy --template-file cfn/ecr.yaml --stack-name "${env}-${app}-engine-ecr" --parameter-overrides \
Environment=${env} \
AppName=${app} \
Opco=${opco} \
Group=${group} \
Service=engine \
--tags \
dhr-opco=${opco} \
dhr-group=${group} \
dhr-app=${app} \
dhr-env=${env} \
