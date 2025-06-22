# 01 - Basic Resources

Learn CloudFormation fundamentals with simple, single-resource templates.

## 📋 Templates in this folder

### 1. `ec2.yaml` - Basic EC2 Instance
**What it creates:**
- Single EC2 instance (t2.micro)
- Security group with SSH access
- Uses parameters for flexibility

**Key concepts learned:**
- Template structure (Parameters, Resources, Outputs)
- Intrinsic functions (`!Ref`, `!GetAtt`)
- Security groups and EC2 instances

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file ec2.yaml \
  --stack-name basic-ec2 \
  --parameter-overrides KeyPairName=your-key-pair
```

### 2. `s3.yaml` - Simple S3 Bucket
**What it creates:**
- S3 bucket with basic configuration
- Public read access (for learning purposes)

**Key concepts learned:**
- Simple resource creation
- Basic S3 properties
- Resource naming

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file s3.yaml \
  --stack-name basic-s3
```

### 3. `s3bucket-with-intrinsic-function.yaml` - Advanced S3
**What it creates:**
- S3 bucket with advanced configuration
- Versioning, encryption, and lifecycle policies
- Uses multiple intrinsic functions

**Key concepts learned:**
- Complex resource properties
- Intrinsic functions (`!Sub`, `!Join`, `!Select`)
- S3 advanced features

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file s3bucket-with-intrinsic-function.yaml \
  --stack-name advanced-s3
```

## 🎯 Learning Objectives

After completing these templates, you should understand:
- Basic CloudFormation template structure
- How to use parameters to make templates flexible
- How to reference resources using `!Ref` and `!GetAtt`
- How to create outputs for other stacks to use
- Basic AWS resource configuration

## 🔍 What to Observe

1. **Template Structure**: Notice the consistent YAML structure
2. **Parameters**: See how they make templates reusable
3. **Resources**: The main building blocks of your infrastructure
4. **Outputs**: Values that can be used by other stacks or applications

## 🚀 Next Steps

Once comfortable with basic resources, move to:
- **02-networking** - Learn about VPCs and networking
- Experiment with different parameter values
- Try modifying resource properties
- Check the AWS Console to see created resources

## 💡 Beginner Tips

1. **Start with ec2.yaml** - It's the simplest template
2. **Check AWS Console** - See resources being created in real-time
3. **Read the comments** - Each template has detailed explanations
4. **Modify parameters** - See how changes affect deployment
5. **Clean up** - Delete stacks after testing to avoid charges