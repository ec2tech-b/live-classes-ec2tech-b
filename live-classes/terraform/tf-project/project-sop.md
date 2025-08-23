object type of terraform "name of the Predefined object by Terraform" "my local name to identify the object" {
    attributes based on the type of Terraform object we are trying to create
}

resource "aws_instance" "myec2server" {
    ami = ""
    instance_type = ""
}


It is a folder based language ( fronetend, backend)
1. output -- Print any stateemnt or attributes
2. varibales -- int, string , bool , list , map
3. resource
4. Data Block
5. Conditions   --- condition ? true-value : false-value
6. Loops  --- > count = 10 , for_each

7. Modules --  to follow DRY principles ---> first write a module block and then call it (local)
   and also remote support

8. State Locking

## Step-05: Add State Locking Feature using DynamoDB Table
- Create Dynamo DB Table
  - **Table Name:** dev-project1-vpc
  - **Partition key (Primary Key):** LockID (Type as String)
  - **Table settings:** Use default settings (checked)
  - Click on **Create**

## Step-02: Create S3 Bucket
- Go to Services -> S3 -> Create Bucket
- **Bucket name:** terraform-on-aws-for-ec2
- **Region:** US-East (N.Virginia)
- **Bucket settings for Block Public Access:** leave to defaults
- **Bucket Versioning:** Enable
- Rest all leave to **defaults**
- Click on **Create Bucket**
- **Create Folder**
  - **Folder Name:** dev
  - Click on **Create Folder**
- **Create Folder**
  - **Folder Name:** dev/project1-vpc
  - Click on **Create Folder**  
