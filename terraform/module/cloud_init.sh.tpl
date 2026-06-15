#!/bin/bash
set -euxo pipefail

echo "=== Install Ansible and dependencies ==="

apt-get update -y
apt-get install -y software-properties-common git python3-pip snapd

add-apt-repository -y ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible


echo "=== Fetch repository ==="

cd /root
git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2
cd auto-ec2-setup/ansible/


echo "=== Prepare Ansible variables ==="

# Normalize booleans (important for Ansible JSON parsing)
INSTALL_MYSQL=${install_mysql:-true}
WORDPRESS_HARDENING=${wordpress_hardening:-true}

# Main variables file (SAFE JSON - no string parsing issues)
cat > /tmp/vars.json <<EOF
{
  "domain_name": "${domain_name}",
  "php_version": "${php_version}",
  "web_framework": "${web_framework}",
  "wordpress_hardening": ${WORDPRESS_HARDENING},
  "install_mysql": ${INSTALL_MYSQL}
}
EOF


echo "=== Prepare MySQL variables ==="

cat > /tmp/mysql_vars.json <<'EOF'
${mysql_databases}
EOF


echo "=== Add NodeJS variables if needed ==="

# We extend JSON safely if nodejs is used
if [ "${web_framework}" = "nodejs" ]; then
  tmp=$(mktemp)

  jq --arg port "${upstream_port}" \
     --arg version "${nodejs_version}" \
     '. + {
        upstream_port: ($port | tonumber? // $port),
        nodejs_version: $version
      }' /tmp/vars.json > "$tmp"

  mv "$tmp" /tmp/vars.json
fi


echo "=== Running Ansible ==="

ansible-playbook setup.yml \
  --extra-vars "@/tmp/vars.json" \
  --extra-vars "@/tmp/mysql_vars.json"