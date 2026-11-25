# 🛠️ Practicals

Run order matters: do **Puppet → Nagios → Ansible**. Prepare the [lab](../lab) first.

| #  | Practical | Tool | Key skills |
|:--:|-----------|:----:|------------|
| 1 | [Install Puppet & first manifest](01-puppet-installation) | Puppet | `puppet apply`, facts, `--noop`, idempotency |
| 2 | [Resources, ordering & classes](02-puppet-resources-and-classes) | Puppet | package/service/file/user/cron/exec, classes, `notify` |
| 3 | [Modules, templates & master–agent](03-puppet-modules-and-master-agent) | Puppet | module layout, EPP, certificates, `site.pp` |
| 4 | [Install Nagios Core](04-nagios-installation) | Nagios | build from source, Apache, plugins |
| 5 | [Monitor hosts & services](05-nagios-monitor-hosts-and-services) | Nagios | host/service/contact objects, soft/hard states |
| 6 | [NRPE remote monitoring](06-nagios-nrpe) | Nagios | `check_nrpe`, custom plugin |
| 7 | [Ansible install, inventory & ad-hoc](07-ansible-adhoc-and-inventory) | Ansible | SSH keys, inventory, modules |
| 8 | [Playbooks, templates, vault & roles](08-ansible-playbooks-and-roles) | Ansible | handlers, Jinja2, Vault, roles |

Each practical folder contains a `README.md` with **Aim · Steps · Expected output · Troubleshooting · Viva questions**, plus the code/config files used.

> 📸 **Tip for submission:** add your own screenshots to a `screenshots/` folder inside each practical and link them from its README.
