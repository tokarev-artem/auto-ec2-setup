#!/bin/bash
apt-add-repository ppa:ansible/ansible
apt update
echo "Install tools"
apt install ansible git python3-pip snapd -yqq
echo "Fetch the setup repository"
cd /root && git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2 && cd auto-ec2-setup/ansible/
echo "Setup the server"
ansible_playbook_command="ansible-playbook setup.yml --extra-vars \"domain_name=${domain_name} php_version=${php_version} web_framework=${web_framework} wordpress_hardening=${wordpress_hardening}%{ if web_framework == "nodejs" } upstream_port=${upstream_port} nodejs_version=${nodejs_version}%{ endif }\""
echo "Running $${ansible_playbook_command}"
$${ansible_playbook_command}
