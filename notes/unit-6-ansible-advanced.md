# Unit 6 — Ansible Advanced (Variables, Roles, Vault, Galaxy)

> ⚠️ **Check against your official handout.** The title is inferred; adjust if your unit 6 differs.

[← Unit 5](unit-5-ansible-basics.md) · [Notes index](README.md)

## 1. Variables
Defined in play `vars`, inventory, `group_vars/`, `host_vars/`, `vars_files`, or on the CLI (`-e`).
```yaml
vars:
  http_port: 8080
tasks:
  - debug: msg="Port is {{ http_port }}"
```
**Precedence** (low → high, simplified): role defaults → inventory vars → `group_vars` → `host_vars` → play vars → `-e` extra vars.

## 2. Facts & registered variables
```yaml
- name: Show OS
  debug: msg="{{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}"

- name: Check a file
  stat: path=/etc/motd
  register: motd

- debug: var=motd.stat.exists
```

## 3. Conditionals, loops, tags
```yaml
- apt: name={{ item }} state=present
  loop: [git, curl, vim]
  when: ansible_facts['os_family'] == "Debian"
  tags: packages
```
Run only some tasks: `ansible-playbook site.yml --tags packages` or `--skip-tags`.

## 4. Handlers
Run **once at the end** and only if notified by a changed task.
```yaml
tasks:
  - template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf
    notify: Restart nginx
handlers:
  - name: Restart nginx
    service: name=nginx state=restarted
```

## 5. Templates (Jinja2)
`templates/index.html.j2`
```jinja
<h1>Hello from {{ inventory_hostname }}</h1>
{% for pkg in packages %}<li>{{ pkg }}</li>{% endfor %}
```
`template: src=index.html.j2 dest=/var/www/html/index.html`

## 6. Roles
Roles package tasks, handlers, files, templates and defaults in a standard structure.
```bash
ansible-galaxy init roles/webserver
```
```
roles/webserver/
├── defaults/main.yml    # lowest-priority variables
├── vars/main.yml
├── tasks/main.yml
├── handlers/main.yml
├── templates/
├── files/
└── meta/main.yml        # dependencies
```
```yaml
- hosts: web
  become: true
  roles:
    - webserver
```

## 7. Ansible Vault (secrets)
```bash
ansible-vault create secrets.yml
ansible-vault encrypt vars.yml
ansible-vault edit   secrets.yml
ansible-vault view   secrets.yml
ansible-playbook site.yml --ask-vault-pass
```
Never commit plain-text passwords; commit only encrypted vault files.

## 8. Ansible Galaxy & collections
```bash
ansible-galaxy role install geerlingguy.nginx
ansible-galaxy collection install community.general
ansible-galaxy install -r requirements.yml
```

## 9. Error handling & good practice
`ignore_errors`, `failed_when`, `changed_when`, `block / rescue / always`, `serial` (rolling updates), `ansible-lint`, keep playbooks idempotent, use `--check` before production.

## 10. Ansible + CI/CD
Typical pipeline: **GitHub → Jenkins/Actions → ansible-playbook → servers**, with Nagios monitoring the result.

## ✍️ Quick revision questions
1. Explain role directory structure.
2. How do handlers differ from tasks?
3. Show how to encrypt a variable file and use it in a playbook.
4. What is Galaxy? How do you install a role from it?
5. Variable precedence – which wins: `group_vars` or `-e`?
