### Folder structure ###

Basically idea was to implement structure like `<env>/<region>/<feature>`

Strongly against separate by specific resource.

In `modules` were implemented only 2 functionality but for sure it can be more. For example `elb`, `route53`, `ec2`

In this solution were not implemented any logs and metrics because of lack of time. It has to be for sure.

Also missed variables description in `variables.tf`

### How to run ###

1. Run `vpc` scripts
2. Run `ec2` scripts
3. `ec2` key-pair is youth `id_rsa.pub`
```
resource "aws_key_pair" "main" {
  key_name   = "mixed_access"
  public_key = file("~/.ssh/id_rsa.pub")
}
```

### Improvements ###

0. pre-commit hook at least using `terraform fmt`

#### VPC ####

1. subnet has specific implementation and not appropriate for all requirements

Issue: 
```
length(subnet_az) == length(subnet_public_cidrs) == length(subnet_private_cidrs)
```

Need refactor and make smth like length(public_subnet_az) == length(subnet_public_cidrs);
length(private_subnet_az) == length(subnet_private_cidrs)

#### EC2 ####

1. Move `ELB` to separate module

It widely used resource and no need repeat your self every time

2. Move `Route53` zone creating on `feature` level.

Also `Route53` dns records creation resource can be moved to modules.

3. `EC2` also can be moved to module to simplify it creation in other folders

