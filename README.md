### How to Run ###

1. Install dependecies

```bash
pip3 install -r requirements.txt
```

2. Set environment vars for getting access to AWS (no need have configured `aws-cli`)

```bash
export AWS_ACCESS_KEY_ID=<aws_secret_access_key>
export AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
```

3. Run script

```bash
python3 main.py
```

### Extend list of services ###

1. If service is region-based add to global variable `SERVICES` in `main.py`

2. If service is global add to global variable `SERVICES` in `main.py`

3. Some resource doesn't have separate API. In this case extend special variable in `main.py/get_regions` function

For example `vpc` and `security-groups` are part of `ec2` API. 

So, `ec2` variable was created and added needed services.

```
def get_regions(aws_session, service):
    ec2 = ["security-groups", "vpc"]
    if service in ec2:
        regions = aws_session.get_available_regions("ec2")
    else:
        regions = aws_session.get_available_regions(service)
    return regions
```

Example if new variable has to be added

```
def get_regions(aws_session, service):
    ec2 = ["security-groups", "vpc"]
    new_api = ["service-name"]
    if service in ec2:
        regions = aws_session.get_available_regions("ec2")
    if service in new_api:
        regions = aws_session.get_available_regions("new_api")
    else:
        regions = aws_session.get_available_regions(service)
    return regions
```

4. In module `aws_service_info.py` extend `self.service_map` in `__init_`.

Example:

```
self.service_map = {
    "ec2": self.get_ec2_info,
    "security-groups": self.get_sg_info,
    "s3": self.get_s3_info,
    "vpc": self.get_vpc_info,
    "elb": self.get_elb_info,
    <new-service>: self.get_<new-service>_info
}
```

5. Finally just need to implement `get_<new-service>_info` function inside `aws_service_info.py`