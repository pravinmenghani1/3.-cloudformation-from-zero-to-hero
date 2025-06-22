# 04 - Auto Scaling & Load Balancer

Learn scalable architectures with Auto Scaling Groups, Load Balancers, and advanced deployment patterns.

## 📋 Templates in this folder

### 1. `asg-alb-creationpolicy.yaml` - Auto Scaling with Creation Policy
**What it creates:**
- VPC with 2 public subnets (multi-AZ)
- Application Load Balancer (ALB)
- Auto Scaling Group with Launch Template
- **CreationPolicy** ensures instances are ready before stack completion

**Key concepts learned:**
- Auto Scaling Groups (ASG)
- Application Load Balancer (ALB)
- Launch Templates
- CreationPolicy for deployment validation
- Multi-AZ architecture

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file asg-alb-creationpolicy.yaml \
  --stack-name asg-alb-demo \
  --parameter-overrides KeyPairName=your-key-pair \
  --capabilities CAPABILITY_IAM
```

### 2. `asg-alb-waitcondition.yaml` - Auto Scaling with Wait Condition
**What it creates:**
- Same infrastructure as above
- **WaitCondition** instead of CreationPolicy
- Demonstrates alternative deployment validation

**Key concepts learned:**
- WaitCondition vs CreationPolicy
- Lambda-backed custom signaling
- Complex deployment orchestration

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file asg-alb-waitcondition.yaml \
  --stack-name asg-wait-demo \
  --parameter-overrides KeyPairName=your-key-pair \
  --capabilities CAPABILITY_IAM
```

## 🎯 Learning Objectives

After completing these templates, you should understand:
- How to build highly available, scalable web applications
- Auto Scaling Group configuration and policies
- Load balancer setup and health checks
- Deployment validation techniques
- Multi-AZ architecture patterns

## 🏗️ Architecture Overview

```
Internet
    |
Application Load Balancer
    |
┌─────────────────┬─────────────────┐
│   AZ-1a         │      AZ-1b      │
│ Public Subnet   │  Public Subnet  │
│ EC2 Instance    │  EC2 Instance   │
└─────────────────┴─────────────────┘
         Auto Scaling Group
```

## 🔍 Key Components Explained

### Auto Scaling Group (ASG)
- **Min Size**: 2 (always have 2 instances)
- **Max Size**: 4 (can scale up to 4 instances)
- **Desired**: 2 (target number of instances)
- **Health Check**: ELB (load balancer determines health)

### Application Load Balancer (ALB)
- **Internet-facing**: Accessible from internet
- **Multi-AZ**: Spans across multiple Availability Zones
- **Health Checks**: Monitors `/` path on port 80
- **Target Group**: Routes traffic to healthy instances

### Launch Template
- **AMI**: Amazon Linux 2
- **Instance Type**: t2.micro (free tier eligible)
- **User Data**: Installs Apache web server
- **Security Group**: Allows HTTP from ALB, SSH from anywhere

## 📊 CreationPolicy vs WaitCondition

| Feature | CreationPolicy | WaitCondition |
|---------|----------------|---------------|
| **Use Case** | ASG, EC2 instances | Any resource |
| **Complexity** | Simple | More complex |
| **Flexibility** | Limited | High |
| **Best For** | Standard deployments | Custom logic |

## 🚀 Deployment Process

1. **Infrastructure Creation**: VPC, subnets, security groups
2. **Load Balancer Setup**: ALB with target group
3. **Launch Template**: Defines instance configuration
4. **Auto Scaling Group**: Launches instances
5. **Instance Initialization**: User data installs web server
6. **Signal Back**: Instances signal successful startup
7. **Stack Complete**: Only after all instances are ready

## 🔍 What to Observe

1. **Load Balancer DNS**: Access your application via ALB DNS name
2. **Target Group Health**: Check healthy/unhealthy targets
3. **Auto Scaling Activity**: View scaling events in ASG
4. **Instance Distribution**: Notice instances in different AZs
5. **Stack Events**: See creation policy waiting for signals

## 🧪 Testing Your Deployment

```bash
# Get the load balancer URL from stack outputs
aws cloudformation describe-stacks \
  --stack-name asg-alb-demo \
  --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerURL`].OutputValue' \
  --output text

# Test the application
curl http://your-alb-dns-name.region.elb.amazonaws.com
```

## 🚀 Next Steps

Once comfortable with auto scaling:
- **05-advanced-features** - Learn custom resources and advanced patterns
- Try adding auto scaling policies (CPU-based scaling)
- Experiment with different health check configurations
- Add HTTPS listener with SSL certificate

## 💡 Best Practices

1. **Multi-AZ**: Always deploy across multiple Availability Zones
2. **Health Checks**: Configure appropriate health check paths
3. **Security Groups**: Restrict access between tiers
4. **Instance Types**: Choose appropriate sizes for your workload
5. **Monitoring**: Set up CloudWatch alarms for scaling

## 🔧 Common Issues

- **Instances Not Healthy**: Check security group rules
- **Creation Policy Timeout**: Verify cfn-signal is working
- **Load Balancer 503**: No healthy targets available
- **SSH Access**: Ensure key pair exists in your account
- **AMI Not Found**: AMI IDs are region-specific

## 📖 Additional Resources

- [Auto Scaling User Guide](https://docs.aws.amazon.com/autoscaling/ec2/userguide/)
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [Launch Templates](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html)
- [CreationPolicy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-creationpolicy.html)