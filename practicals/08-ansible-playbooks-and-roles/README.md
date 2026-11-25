# Practical 8 — Playbooks, templates, handlers, vault and roles

## 🎯 Aim
Write playbooks to configure a web server, use variables/templates/handlers, encrypt secrets with Vault, and refactor into a role.

## 📁 Files
```
08-ansible-playbooks-and-roles/
├── ansible.cfg · inventory.ini        # same as practical 7
├── 01_install_nginx.yml               # first playbook
├── 02_vars_templates_handlers.yml     # variables + template + handler
├── 03_vault_demo.yml                  # uses an encrypted variable file
├── 04_site_with_role.yml              # same result using a role
├── templates/index.html.j2
└── roles/webserver/{defaults,tasks,handlers,templates}/…
```

## 🪜 Steps
1. **Syntax check & dry run**
   ```bash
   ansible-playbook 01_install_nginx.yml --syntax-check
   ansible-playbook 01_install_nginx.yml --check --diff
   ansible-playbook 01_install_nginx.yml
   curl http://192.168.56.11
   ```
2. **Variables, template, handler**
   ```bash
   ansible-playbook 02_vars_templates_handlers.yml
   ansible-playbook 02_vars_templates_handlers.yml -e http_port=8081   # extra var wins
   ```
   Change the template text and re-run – the **handler runs only when the file changed**.
3. **Vault**
   ```bash
   ansible-vault create secrets.yml        # add:  db_password: "S3cret!"
   ansible-playbook 03_vault_demo.yml --ask-vault-pass
   ansible-vault view secrets.yml --ask-vault-pass
   ```
   (Do **not** commit your real `secrets.yml` password; commit only the encrypted file.)
4. **Role**
   ```bash
   ansible-playbook 04_site_with_role.yml
   ```
5. Optional: lint → `pip install ansible-lint && ansible-lint .`

## ✅ Expected output
`PLAY RECAP` shows `ok=… changed=… failed=0`. `curl` prints the page generated from `index.html.j2` with the node's hostname.

## 📝 Viva questions
- Play vs playbook vs task.
- What are handlers and when do they run?
- Explain the Jinja2 syntax `{{ }}` and `{% %}`.
- How does Vault work? How do you supply the password non-interactively?
- Why are roles useful? Show the directory structure.
