import os

import boto3

from aws_service_info import AWSServiceInfo

SERVICES = ["ec2", "security-groups", "s3", "vpc", "elb"]
GLOBAL_SERVICES = ["s3"]

"""
Create AWS session
Can be extended with getting creds from env vars
"""


def auth():
    aws_access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
    aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")
    return boto3.Session(aws_access_key_id=aws_access_key_id,
                         aws_secret_access_key=aws_secret_access_key)


"""
Get regions based on service.
Some resource we want to get info are part of other service
For example security group is a part of EC2, but we want to get information separately from ec2
"""


def get_regions(aws_session, service):
    ec2 = ["security-groups", "vpc"]
    if service in ec2:
        regions = aws_session.get_available_regions("ec2")
    else:
        regions = aws_session.get_available_regions(service)
    return regions


"""
Execute AWSServiceInfo module to get service info
"""


def get_service_info(service, region):
    try:
        service_info = AWSServiceInfo(service=service, region=region)
        print(service_info.get_service_info())
    except ValueError as e:
        print(f"{region}/{service}: {e}")
    except Exception as e:
        print(f"{region}/{service}: {e}")


if __name__ == "__main__":
    session = auth()
    for service in SERVICES:
        if service in GLOBAL_SERVICES:
            get_service_info(service, "global")
            continue
        regions = get_regions(session, service)
        # For dev
        # regions = ["eu-north-1"]
        for region in regions:
            get_service_info(service, region)
