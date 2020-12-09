#!/bin/bash

# Stop script on any failure
set -e 

usage() { 
    echo "Usage: $0 [-e <environment dev|test|prod>] [-r <aws region e.g. us-east-1>] [-a <the application this resource belongs to e.g. awesomeapp>]" 1>&2
    exit 1 
}

while getopts ":e:r:o:g:a:h:" o; do
    case "${o}" in
        e)
            env=${OPTARG}
            ;;
        r)
            region=${OPTARG}
            ;;
        a)
            app=${OPTARG}
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

if [ -z "${env}" ] || [ -z "${region}" ] || [ -z "${app}" ] ; then
    usage
fi

# Test if aws cli is installed
r=$(aws --version)
if [ $? -ne 0 ]; then
  echo "awscli is not installed, this is a fatal error"
  exit 1
fi

# Set the aws region
export AWS_DEFAULT_REGION=${region}

# Create ui ECR
service="ui"
echo "Deploying ${env} ${app} ${service} repo"
aws cloudformation deploy --template-file cfn/ecr.yaml --stack-name "${env}-${app}-${service}-ecr" --parameter-overrides \
Environment=${env} \
AppName=${app} \
Service=${service} \
--tags \
app=${app} \
env=${env} \