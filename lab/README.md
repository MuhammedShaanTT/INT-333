# 🧪 Lab environment

All practicals run on three Ubuntu 22.04 machines. Use **Vagrant + VirtualBox** (below), or any three VMs / cloud instances that can reach each other.

| Host    | IP              | Role                                                  |
|---------|-----------------|-------------------------------------------------------|
| control | `192.168.56.10` | Puppet server · Nagios server · Ansible control node  |
| node1   | `192.168.56.11` | Managed node                                          |
| node2   | `192.168.56.12` | Managed node                                          |

```bash
cd lab
vagrant up            # creates all 3 VMs (first run downloads the box)
vagrant ssh control   # log in
vagrant halt          # stop VMs when you are done
vagrant destroy -f    # delete everything
```

> **Tip:** the `control` VM needs ~3 GB RAM because Puppet Server (a JVM app) is memory-hungry.
> If your laptop is short on RAM, do the Puppet practicals first, then Nagios, then Ansible.
