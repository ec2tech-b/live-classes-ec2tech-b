module "demo" {
    source = "./mymodule"
    instance_type = "t2.nano"
    Name = "devops-test-env"
    terraform = "true"
}

module "demo-1" {
    source = "./mymodule"
    instance_type = "t2.nano"
    Name = "devops-test-env-1"
    terraform = "true"
}

module "demo-1" {
    source = "./ec2"
    instance_type = "t2.nano"
    Name = "devops-test-env-1"
    terraform = "true"
}