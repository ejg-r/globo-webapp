#!/bin/bash
sudo yum update
sudo yum install git -y
sudo amazon-linux-extras install ansible2 -y
sudo mkdir /var/ansible_playbooks
#sudo git clone ${playbook_repository} /var/ansible_playbooks

sudo chown -R ec2-user /var
sudo chown -R ec2-user /home

eval "$(ssh-agent -s)"

# Setup SSH key for GitHub access
echo "${private_key}" > /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa
# Add GitHub to known hosts to avoid prompt
ssh-keyscan github.com >> /home/ec2-user/.ssh/known_hosts
# Clone the private repository
sudo git clone ${playbook_repository} /var/ansible_playbooks
# Delete the SSH key after cloning
shred -u /home/ec2-user/.ssh/id_rsa


aws secretsmanager get-secret-value --secret-id "${secret_id}" --region us-east-1 --query SecretString --output text > /var/ansible_playbooks/api_key.txt
aws ssm get-parameter --name "${host_list_ssm_name}" --region us-east-1 --query Parameter.Value --output text > /var/ansible_playbooks/host_list.txt
aws ssm get-parameter --name "${site_name_ssm_name}" --region us-east-1 --query Parameter.Value --output text > /var/ansible_playbooks/site_name.txt
ansible-playbook /var/ansible_playbooks/playbook.yml -i /var/ansible_playbooks/hosts