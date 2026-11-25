#!/usr/bin/env bash
# Ad-hoc command cookbook (run from the folder that contains ansible.cfg)
ansible all -m ping
ansible all -m command -a "uptime"
ansible all -m command -a "df -h /"
ansible all -m setup -a "filter=ansible_distribution*"
ansible all -m setup -a "filter=ansible_default_ipv4"

# packages & services (need sudo => -b)
ansible web -b -m apt     -a "name=nginx state=present update_cache=yes"
ansible web -b -m service -a "name=nginx state=started enabled=yes"
ansible web -b -m apt     -a "name=nginx state=absent"

# files
echo "managed by ansible" > /tmp/motd_demo
ansible all -b -m copy -a "src=/tmp/motd_demo dest=/etc/motd mode=0644"
ansible all -m file    -a "path=/tmp/demo_dir state=directory mode=0755"
ansible all -m fetch   -a "src=/etc/hostname dest=/tmp/hostnames/"

# users
ansible all -b -m user -a "name=deploy shell=/bin/bash state=present"

# reboot / parallelism
ansible all -b -m reboot -f 1          # -f = forks
