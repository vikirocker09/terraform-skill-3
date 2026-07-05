# Terraform EC2 Nginx Deployment (Ubuntu 20.04)

This project uses Terraform to provision a `t3.micro` Ubuntu 20.04 LTS EC2
instance inside the AWS **default VPC**, running an Nginx web server that
serves a custom HTML page. No new VPC, subnet, or internet gateway is
created — only the EC2 instance and a security group.

## Resources Created

| Resource | Purpose |
|---|---|
| `aws_security_group.nginx_sg` | Allows inbound HTTP (80) and SSH (22), and all outbound traffic |
| `aws_instance.nginx_server` | Ubuntu 20.04 t3.micro instance, installs & configures Nginx via `user_data` |
| `data.aws_vpc.default` | Looks up the existing default VPC (no new VPC created) |
| `data.aws_subnets.default` | Looks up a subnet inside the default VPC to launch the instance into |
| `data.aws_ami.ubuntu_20_04` | Looks up the latest official Canonical Ubuntu 20.04 AMI for the region |

## Prerequisites

1. [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3.0 installed.
2. An AWS account with credentials configured, e.g. via:
   ```bash
   aws configure
   ```
   or environment variables `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`.
3. (Optional, needed for SSH) An existing EC2 Key Pair in your target region:
   ```bash
   aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > my-key.pem
   chmod 400 my-key.pem
   ```

## Steps to Run

1. **Clone the repo and enter the directory**
   ```bash
   git clone <your-repo-url>
   cd terraform-nginx-ubuntu
   ```

2. **(Optional) Set your variables**
   Create a `terraform.tfvars` file (or pass `-var` flags) to override defaults:
   ```hcl
   aws_region       = "us-east-1"
   key_name         = "my-key"
   allowed_ssh_cidr = "YOUR_IP/32"
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Preview the execution plan**
   ```bash
   terraform plan
   ```

5. **Apply the configuration**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted. After completion, Terraform prints the
   instance's public IP, DNS, and URL.

6. **Verify Nginx is running**
   Wait ~1 minute for `user_data` to finish, then open the URL from the
   output in a browser, or run:
   ```bash
   curl http://<instance_public_ip>
   ```
   Expected response:
   ```
   Welcome to the Terraform-managed Nginx Server on Ubuntu
   ```

7. **(Optional) SSH into the instance**
   ```bash
   ssh -i my-key.pem ubuntu@<instance_public_ip>
   ```

8. **Tear down all resources**
   ```bash
   terraform destroy
   ```
   Type `yes` when prompted. This removes the EC2 instance and security
   group; the default VPC itself is untouched (it was never created by
   this project).

## Screenshots

1. `terraform apply` output with the public IP.
<img width="1207" height="1030" alt="image" src="https://github.com/user-attachments/assets/a2b16134-117d-40ed-b657-b7dccb5f6167" />
<img width="972" height="842" alt="image" src="https://github.com/user-attachments/assets/49b40965-d55a-4d94-85ce-3771eaab001c" />
3. The Nginx welcome page open in a browser at `http://<http://34.239.175.58/>`.
<img width="1380" height="543" alt="image" src="https://github.com/user-attachments/assets/d631ca50-c53d-481a-a84a-6580f56a29d6" />
4. `terraform destroy` completing successfully.
<img width="1262" height="898" alt="image" src="https://github.com/user-attachments/assets/dc58044f-c69c-4707-adfc-124ecdc04f9e" />
<img width="952" height="911" alt="image" src="https://github.com/user-attachments/assets/32794485-70a4-4f16-b93f-38d1174aeaa5" />
<img width="973" height="541" alt="image" src="https://github.com/user-attachments/assets/e4b9f60d-691e-4eb6-9540-1bcbf4facec3" />

## Notes

- Uses only Terraform CLI commands: `init`, `plan`, `apply`, `destroy`.
- No separate VPC, subnet, or internet gateway is created — the instance
  is launched into the account's existing default VPC/subnet.
- All resources are tagged with `Name` and `Project` for identification.
