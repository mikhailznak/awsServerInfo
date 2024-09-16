import boto3
from prettytable import PrettyTable


class AWSServiceInfo:
    def __init__(self, service: str, region=None):
        self.service = service
        self.region = region
        # Supported service to get info
        self.service_map = {
            "ec2": self.get_ec2_info,
            "security-groups": self.get_sg_info,
            "s3": self.get_s3_info,
            "vpc": self.get_vpc_info,
            "elb": self.get_elb_info
        }

    """
    Table format output
    """

    def format_output(self, data):
        if not data:
            return "No data available."

        table = PrettyTable()
        table.field_names = data[0].keys()

        for item in data:
            table.add_row(item.values())
        return table

    """
    Entrypoint for user to get service info
    """

    def get_service_info(self):
        if self.service in self.service_map:
            data = self.service_map[self.service]()
            return self.format_output(data)
        raise ValueError(f"Service '${self.service}' is not supported")

    def get_ec2_info(self):
        client = boto3.client("ec2", region_name=self.region)
        instances = client.describe_instances()
        ec2_info = []
        for reservation in instances["Reservations"]:
            for instance in reservation["Instances"]:
                security_groups = [sg["GroupId"] for sg in instance.get("SecurityGroups", [])]
                ec2_info.append({
                    "Region": self.region,
                    "Service": "EC2",
                    "InstanceId": instance["InstanceId"],
                    "InstanceType": instance["InstanceType"],
                    "State": instance["State"]["Name"],
                    "PrivateIpAddress": instance.get("PrivateIpAddress", "N/A"),
                    "PublicIpAddress": instance.get("PublicIpAddress", "N/A"),
                    "AvailabilityZone": instance["Placement"]["AvailabilityZone"],
                    "SecurityGroups": ", ".join(security_groups),
                    "LaunchTime": instance["LaunchTime"].strftime("%Y-%m-%d %H:%M:%S")
                })
        return ec2_info

    def get_sg_info(self):
        ec2 = boto3.client("ec2", region_name=self.region)
        security_groups = ec2.describe_security_groups()
        sg_info = []
        for sg in security_groups["SecurityGroups"]:
            sg_info.append({
                "Region": self.region,
                "Service": "SecurityGroups",
                "GroupId": sg["GroupId"],
                "GroupName": sg["GroupName"],
                "VpcId": sg.get("VpcId", "N/A"),
                "Description": sg["Description"]
            })
        return sg_info

    def get_s3_info(self):
        s3 = boto3.client("s3")
        buckets = s3.list_buckets()
        s3_info = []
        for bucket in buckets['Buckets']:
            s3_info.append({
                "Region": "global",
                "Service": "S3",
                "BucketName": bucket["Name"],
                "CreationDate": bucket["CreationDate"],
            })
        return s3_info

    def get_vpc_info(self):
        client = boto3.client("ec2", region_name=self.region)
        vpcs = client.describe_vpcs()
        vpc_info = []
        for vpc in vpcs["Vpcs"]:
            vpc_info.append({
                "Region": self.region,
                "Service": "VPC",
                "VpcId": vpc["VpcId"],
                "CidrBlock": vpc["CidrBlock"],
                "State": vpc["State"],
                "IsDefault": vpc["IsDefault"],
                "Tags": vpc.get("Tags", [])
            })
        return vpc_info

    def get_elb_info(self):
        client = boto3.client('elbv2', region_name=self.region)
        elb = client.describe_load_balancers()
        elb_info = []
        for load_balancer in elb['LoadBalancers']:
            elb_info.append({
                'Region': self.region,
                "Service": "ELB",
                'LoadBalancerName': load_balancer['LoadBalancerName'],
                'LoadBalancerArn': load_balancer['LoadBalancerArn'],
                'Type': load_balancer['Type'],
                'Scheme': load_balancer['Scheme'],
                'DNSName': load_balancer['DNSName'],
                'State': load_balancer['State']['Code']
            })
        return elb_info
