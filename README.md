# README
This is a cloudformation template to create ECR

# How to deploy
To deploy the ECR, you can deploy from console using the ecr.yaml template in the cfn folder. Or you can run the build.sh script.

# How to use the build script
Build script is expecting the following arguments
- -e environment np-dev|np-stage|prod
- -r aws region e.g. us-east-1
- -a the application this resource belongs to e.g. gears

```bash
./build.sh -e np-dev -r us-east-1 -o cyt
```