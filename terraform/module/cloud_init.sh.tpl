#!/bin/bash
apt-add-repository ppa:ansible/ansible
apt update
apt install ansible git python3-pip snapd -yqq
cd /root && git clone https://github.com/RealArtemiy/auto-ec2-setup.git && cd auto-ec2-setup/ansible/
ansible-playbook setup.yml --extra-vars "domain_name=${domain_name} php_version=${php_version}"
