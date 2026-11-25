# Ansible cheat-sheet

| Task | Command |
|------|---------|
| Version | `ansible --version` |
| Ping all | `ansible all -m ping` |
| Ad-hoc command | `ansible web -m command -a "uptime"` |
| With sudo | `ansible web -b -m apt -a "name=git state=present"` |
| Gather facts | `ansible node1 -m setup` |
| Show inventory | `ansible-inventory --list -y` |
| Run playbook | `ansible-playbook site.yml` |
| Syntax check | `ansible-playbook site.yml --syntax-check` |
| Dry run + diff | `ansible-playbook site.yml --check --diff` |
| Limit hosts / tags | `-l node1` · `--tags x` · `--skip-tags y` |
| Extra vars | `-e "http_port=8081"` · `-e @vars.yml` |
| Ask sudo / vault pw | `-K` · `--ask-vault-pass` |
| Docs for a module | `ansible-doc ansible.builtin.copy` |
| Role skeleton | `ansible-galaxy init roles/webserver` |
| Install role | `ansible-galaxy install geerlingguy.nginx` |
| Vault | `ansible-vault create|edit|view|encrypt|decrypt|rekey file.yml` |
| Lint | `ansible-lint playbook.yml` |

**Playbook skeleton**
```yaml
---
- name: Describe the play
  hosts: web
  become: true
  vars: { x: 1 }
  tasks:
    - name: Do something
      ansible.builtin.apt: { name: nginx, state: present }
      notify: Restart nginx
  handlers:
    - name: Restart nginx
      ansible.builtin.service: { name: nginx, state: restarted }
```
