# 02 - Networking

Learn VPC, subnets, and networking concepts in CloudFormation.

## 📋 Templates in this folder

### 1. `single-vpc-ec2-stack.yaml` - Complete VPC with EC2
**What it creates:**
- VPC with DNS support
- Public subnet in one Availability Zone
- Internet Gateway and Route Table
- Security Group with HTTP/SSH access
- EC2 instance in the public subnet

**Key concepts learned:**
- VPC fundamentals
- Subnets and Availability Zones
- Internet Gateway and routing
- Security Groups vs NACLs
- Complete networking stack

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file single-vpc-ec2-stack.yaml \
  --stack-name vpc-ec2-demo \
  --parameter-overrides KeyPairName=your-key-pair
```

## 🎯 Learning Objectives

After completing this template, you should understand:
- How to create a complete VPC from scratch
- Relationship between VPC, subnets, and route tables
- How Internet Gateway enables internet access
- Security Group configuration for web applications
- How to place EC2 instances in specific subnets

## 🏗️ Architecture Overview

```
Internet
    |
Internet Gateway
    |
VPC (10.0.0.0/16)
    |
Public Subnet (10.0.1.0/24)
    |
EC2 Instance
```

## 🔍 What to Observe

1. **VPC Creation**: Notice CIDR block and DNS settings
2. **Subnet Configuration**: Public subnet with auto-assign public IP
3. **Route Table**: Default route (0.0.0.0/0) pointing to Internet Gateway
4. **Security Group**: Inbound rules for SSH (22) and HTTP (80)
5. **EC2 Placement**: Instance automatically gets public IP

## 📊 Resource Dependencies

Understanding the order of resource creation:
1. **VPC** - The foundation
2. **Internet Gateway** - For internet access
3. **Subnet** - Network segment within VPC
4. **Route Table** - Defines routing rules
5. **Security Group** - Virtual firewall
6. **EC2 Instance** - Compute resource

## 🚀 Next Steps

Once comfortable with networking:
- **03-nested-stacks** - Learn to split this into reusable components
- Try adding a private subnet
- Experiment with multiple Availability Zones
- Add NAT Gateway for private subnet internet access

## 💡 Networking Tips

1. **CIDR Planning**: Understand IP address ranges
2. **Public vs Private**: Public subnets have route to Internet Gateway
3. **Security Groups**: Stateful - return traffic automatically allowed
4. **Route Tables**: Control where network traffic is directed
5. **Availability Zones**: Use multiple AZs for high availability

## 🔧 Common Issues

- **No Internet Access**: Check route table has 0.0.0.0/0 → IGW
- **SSH Connection Failed**: Verify security group allows port 22
- **Instance Not Accessible**: Ensure subnet has auto-assign public IP
- **Wrong AZ**: Some regions have limited AZ availability

## 📖 Additional Resources

- [VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Subnet Routing](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
- [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)