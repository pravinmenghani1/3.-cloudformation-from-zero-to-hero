# 03 - Nested Stacks

Learn modular CloudFormation design with nested stacks and cross-stack references.

## 📋 Templates in this folder

### 1. `vpc-stack.yaml` - VPC Infrastructure Stack
**What it creates:**
- VPC with public subnet
- Internet Gateway and routing
- **Exports** VPC ID and Subnet ID for other stacks

**Key concepts learned:**
- Stack outputs with Export names
- Reusable infrastructure components
- Cross-stack references

### 2. `ec2-stack.yaml` - EC2 Application Stack
**What it creates:**
- Security Group in imported VPC
- EC2 instance in imported subnet
- **Imports** VPC values from vpc-stack

**Key concepts learned:**
- `Fn::ImportValue` function
- Stack dependencies
- Separation of concerns

### 3. `master-stack.yaml` - Orchestration Stack
**What it creates:**
- Manages both VPC and EC2 stacks
- Handles dependencies automatically
- Demonstrates nested stack pattern

**Key concepts learned:**
- Nested stack orchestration
- `DependsOn` attribute
- Stack parameter passing

### 4. `deploy.sh` - Deployment Script
**What it does:**
- Deploys stacks in correct order
- Waits for completion between deployments
- Shows stack outputs

## 🎯 Learning Objectives

After completing these templates, you should understand:
- How to break monolithic templates into modules
- Cross-stack communication using Export/Import
- Benefits of nested stack architecture
- Proper dependency management

## 🏗️ Architecture Overview

```
Master Stack
├── VPC Stack (Infrastructure)
│   ├── VPC
│   ├── Subnet
│   ├── Internet Gateway
│   └── Exports: VpcId, SubnetId
└── EC2 Stack (Application)
    ├── Imports: VpcId, SubnetId
    ├── Security Group
    └── EC2 Instance
```

## 🚀 Deployment Options

### Option 1: Individual Stacks (Recommended for learning)
```bash
# Deploy VPC first
aws cloudformation deploy \
  --template-file vpc-stack.yaml \
  --stack-name demo-vpc

# Deploy EC2 second (depends on VPC)
aws cloudformation deploy \
  --template-file ec2-stack.yaml \
  --stack-name demo-ec2 \
  --parameter-overrides VpcStackName=demo-vpc KeyPairName=your-key-pair
```

### Option 2: Using the deployment script
```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 3: Master stack (Advanced)
```bash
# First upload templates to S3, then:
aws cloudformation deploy \
  --template-file master-stack.yaml \
  --stack-name demo-master \
  --parameter-overrides KeyPairName=your-key-pair
```

## 🔍 What to Observe

1. **Export/Import**: Check CloudFormation console → Exports tab
2. **Stack Dependencies**: EC2 stack shows dependency on VPC stack
3. **Cross-Stack References**: Notice `Fn::ImportValue` usage
4. **Modular Design**: Each stack has single responsibility

## 📊 Benefits of Nested Stacks

| Aspect | Monolithic Stack | Nested Stacks |
|--------|------------------|---------------|
| **Reusability** | Low | High |
| **Maintenance** | Difficult | Easy |
| **Testing** | All-or-nothing | Component-wise |
| **Team Collaboration** | Conflicts | Independent |
| **Deployment Speed** | Slow | Faster (parallel) |

## 🚀 Next Steps

Once comfortable with nested stacks:
- **04-autoscaling-loadbalancer** - Learn scalable architectures
- Try creating your own nested stack design
- Experiment with more complex dependencies
- Practice with different parameter passing patterns

## 💡 Best Practices

1. **Single Responsibility**: Each stack should have one purpose
2. **Logical Separation**: Infrastructure vs Application stacks
3. **Export Naming**: Use consistent naming conventions
4. **Parameter Validation**: Add constraints and descriptions
5. **Documentation**: Comment complex cross-references

## 🔧 Common Issues

- **Export Already Exists**: Export names must be unique per region
- **Import Not Found**: Ensure exporting stack is deployed first
- **Circular Dependencies**: Stack A can't depend on Stack B if B depends on A
- **Stack Deletion Order**: Delete importing stacks before exporting stacks

## 📖 Additional Resources

- [Working with Nested Stacks](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html)
- [Cross-Stack References](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/walkthrough-crossstackref.html)
- [Stack Outputs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html)