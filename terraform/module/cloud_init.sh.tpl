#!/bin/bash
apt-add-repository ppa:ansible/ansible
apt update
apt install ansible git python3-pip snapd -yqq
cd /root && git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2 && cd auto-ec2-setup/ansible/
ansible-playbook setup.yml --extra-vars "domain_name=${domain_name} php_version=${php_version} web_framework=${web_framework} wordpress_hardening=${wordpress_hardening}%{ if web_framework == "nodejs" } upstream_port=${upstream_port} nodejs_version=${nodejs_version}%{ endif }"
