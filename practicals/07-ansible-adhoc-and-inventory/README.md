# Practical 7 — Ansible installation, inventory and ad-hoc commands

## 🎯 Aim
Install Ansible on the control node, set up key-based SSH to the managed nodes, build an inventory, and run ad-hoc commands.

## 🪜 Steps (on `control`)
1. **Install**
   ```bash
   sudo apt update && sudo apt install -y ansible
   ansible --version
   ```
2. **SSH keys** (no password prompts)
   ```bash
   ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
   ssh-copy-id vagrant@192.168.56.11
   ssh-copy-id vagrant@192.168.56.12
   ```
3. **Project files** – use [`ansible.cfg`](ansible.cfg) and [`inventory.ini`](inventory.ini) from this folder (`cd` here first).
   ```bash
   ansible-inventory --list -y
   ansible all --list-hosts
   ```
4. **Connectivity test**
   ```bash
   ansible all -m ping
   ```
5. **Ad-hoc commands** – full list in [`adhoc_commands.sh`](adhoc_commands.sh)
   ```bash
   ansible all -a "uptime"
   ansible web -b -m apt -a "name=nginx state=present update_cache=yes"
   ansible web -b -m service -a "name=nginx state=started enabled=yes"
   ansible all -m setup -a "filter=ansible_distribution*"
   ```
6. Run the install command **twice** – the second run reports `"changed": false` (idempotency).

## ✅ Expected output
`ping` returns `"ping": "pong"` in green for every host; `apt` shows `CHANGED` the first time and `SUCCESS` afterwards.

## 🛠️ Troubleshooting
| Symptom | Fix |
|---------|-----|
| `UNREACHABLE! Permission denied (publickey)` | Re-run `ssh-copy-id`; check `ansible_user` |
| `Missing sudo password` | Add `-K` or configure passwordless sudo (Vagrant has it) |
| Host key prompt | `host_key_checking = False` in `ansible.cfg` (lab only) |

## 📝 Viva questions
- What does "agentless" mean? What is required on managed nodes?
- Difference between `command`, `shell` and `raw` modules.
- What is the role of `-b`?
- Where does Ansible look for `ansible.cfg` (order of precedence)?
