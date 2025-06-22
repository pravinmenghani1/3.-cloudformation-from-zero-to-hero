# 05 - Advanced Features

Learn advanced CloudFormation patterns including Lambda-backed custom resources.

## 📋 Templates in this folder

### 1. `lambda-custom-resource.yaml` - Lambda-Backed Custom Resource
**What it creates:**
- Lambda function that generates secure passwords
- Custom resource that triggers the Lambda function
- SSM Parameter Store for secure password storage
- EC2 instance that retrieves and uses the generated password
- Complete IAM roles and permissions

**Key concepts learned:**
- Lambda-backed custom resources
- Custom resource lifecycle (Create, Update, Delete)
- SSM Parameter Store integration
- Secure password generation and storage
- Cross-service integration patterns

**Deploy:**
```bash
aws cloudformation deploy \
  --template-file lambda-custom-resource.yaml \
  --stack-name lambda-custom-demo \
  --parameter-overrides PasswordLength=20 \
  --capabilities CAPABILITY_IAM
```

## 🎯 Learning Objectives

After completing this template, you should understand:
- How to extend CloudFormation with custom functionality
- Lambda function integration with CloudFormation
- Secure credential management patterns
- Custom resource best practices
- Advanced IAM permission patterns

## 🏗️ Architecture Overview

```
CloudFormation Stack
    |
Custom Resource ──► Lambda Function
    |                      |
    ▼                      ▼
EC2 Instance ◄──── SSM Parameter Store
                   (Encrypted Password)
```

## 🔍 Component Deep Dive

### Lambda Function (Password Generator)
```python
def lambda_handler(event, context):
    if event['RequestType'] == 'Create':
        # Generate random password
        # Store in SSM Parameter Store
        # Return parameter name to CloudFormation
```

### Custom Resource
```yaml
Type: Custom::PasswordGenerator
Properties:
  ServiceToken: !GetAtt CustomResourceFunction.Arn
  PasswordLength: !Ref PasswordLength
```

### SSM Parameter Store
- **Type**: SecureString (encrypted at rest)
- **Access**: Controlled via IAM policies
- **Lifecycle**: Managed by Lambda function

### EC2 Integration
- **IAM Role**: Grants access to specific SSM parameter
- **UserData**: Retrieves password during instance startup
- **Security**: Password never exposed in CloudFormation

## 📊 Custom Resource Lifecycle

| Event | Lambda Action | CloudFormation Response |
|-------|---------------|------------------------|
| **Create** | Generate password → Store in SSM | Return parameter name |
| **Update** | Update password if length changed | Return updated info |
| **Delete** | Delete SSM parameter | Confirm cleanup |

## 🔍 What to Observe

1. **Lambda Execution**: Check CloudWatch logs for Lambda function
2. **SSM Parameter**: Verify encrypted parameter creation
3. **Custom Resource Outputs**: See returned values in stack outputs
4. **EC2 Integration**: Check instance can retrieve password
5. **Cleanup**: Verify parameter deletion when stack is deleted

## 🧪 Testing Your Deployment

```bash
# Get the SSM parameter name from stack outputs
PARAM_NAME=$(aws cloudformation describe-stacks \
  --stack-name lambda-custom-demo \
  --query 'Stacks[0].Outputs[?OutputKey==`ParameterName`].OutputValue' \
  --output text)

# Retrieve the generated password (requires appropriate permissions)
aws ssm get-parameter \
  --name "$PARAM_NAME" \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text

# Check EC2 instance logs
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=CustomResourceDemo" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text
```

## 🔧 Real-World Use Cases

### Database Password Management
```yaml
DatabaseInstance:
  Type: AWS::RDS::DBInstance
  Properties:
    MasterUsername: admin
    MasterUserPassword: !GetAtt PasswordGenerator.Password
```

### API Key Generation
```yaml
ApiKeyResource:
  Type: Custom::ApiKeyGenerator
  Properties:
    ServiceToken: !GetAtt ApiKeyFunction.Arn
    KeyLength: 32
```

### Certificate Management
```yaml
CertificateResource:
  Type: Custom::CertificateGenerator
  Properties:
    ServiceToken: !GetAtt CertFunction.Arn
    Domain: example.com
```

## 🚀 Advanced Patterns

### 1. Conditional Custom Resources
```yaml
ConditionalResource:
  Type: Custom::ConditionalLogic
  Condition: CreateProductionResources
  Properties:
    ServiceToken: !GetAtt CustomFunction.Arn
```

### 2. Custom Resource with External APIs
```python
def lambda_handler(event, context):
    if event['RequestType'] == 'Create':
        # Call external API
        # Register domain, create DNS records, etc.
        response = requests.post('https://api.example.com/register')
```

### 3. Multi-Step Custom Resources
```python
def lambda_handler(event, context):
    steps = ['validate', 'create', 'configure', 'test']
    for step in steps:
        execute_step(step, event['ResourceProperties'])
```

## 💡 Best Practices

1. **Error Handling**: Always send response to CloudFormation
2. **Idempotency**: Make operations safe to retry
3. **Timeouts**: Set appropriate Lambda timeout values
4. **Logging**: Use CloudWatch logs for debugging
5. **Security**: Follow least privilege principle
6. **Testing**: Test all lifecycle events (Create/Update/Delete)

## 🔧 Common Issues

- **Lambda Timeout**: Increase timeout for long-running operations
- **Permission Denied**: Check IAM roles and policies
- **Response Not Sent**: Always call send_response function
- **Stack Stuck**: Manual intervention may be needed if Lambda fails
- **Resource Not Cleaned**: Ensure Delete operation works properly

## 🚀 Next Steps

After mastering custom resources:
- Build your own custom resource for specific needs
- Integrate with external services and APIs
- Create reusable custom resource libraries
- Explore AWS CDK for more advanced infrastructure as code

## 📖 Additional Resources

- [Custom Resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html)
- [Lambda-backed Custom Resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/custom-resource-lambda-providers.html)
- [Custom Resource Examples](https://github.com/aws-samples/aws-cloudformation-templates)
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)

## 🎓 Congratulations!

You've completed all the CloudFormation learning modules! You now have the knowledge to:
- Create basic AWS resources
- Design networking architectures
- Build modular, reusable templates
- Implement scalable applications
- Extend CloudFormation with custom functionality

Keep practicing and building more complex infrastructures! 🚀