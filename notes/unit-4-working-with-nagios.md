# Unit 4 — Working with Nagios

[← Unit 3](unit-3-nagios-overview.md) · [Notes index](README.md) · [Next: Unit 5 →](unit-5-ansible-basics.md)

## 1. Configuration layout
```
/usr/local/nagios/etc/
├── nagios.cfg            # main config (cfg_file / cfg_dir lines)
├── cgi.cfg               # web UI permissions
├── resource.cfg          # $USER1$ = plugin path, passwords
└── objects/
    ├── commands.cfg      # check commands
    ├── contacts.cfg
    ├── templates.cfg     # generic-host, generic-service, linux-server…
    ├── timeperiods.cfg
    └── localhost.cfg
```
Add your own folder and enable it in `nagios.cfg`:
```
cfg_dir=/usr/local/nagios/etc/servers
```

## 2. Object definitions
### Host
```cfg
define host {
    use                 linux-server          ; inherit template
    host_name           node1
    alias               Ubuntu Node 1
    address             192.168.56.11
    max_check_attempts  3
}
```
### Service
```cfg
define service {
    use                 generic-service
    host_name           node1
    service_description HTTP
    check_command       check_http
}
```
### Command
```cfg
define command {
    command_name  check_nrpe
    command_line  $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
```
### Groups, contacts, time periods
```cfg
define hostgroup  { hostgroup_name linux-servers  alias Linux Servers  members node1,node2 }
define contact    { contact_name shaan  use generic-contact  email you@example.com }
define timeperiod { timeperiod_name 24x7  alias 24 Hours  monday 00:00-24:00 ... }
```

### Macros
`$HOSTNAME$`, `$HOSTADDRESS$`, `$SERVICEDESC$`, `$ARG1$…$ARG32$`, `$USER1$` – substituted into command lines.

### Templates & inheritance
`use` + `register 0` templates avoid repetition. Objects inherit directives from templates.

## 3. Monitoring remote resources with NRPE
**NRPE** (Nagios Remote Plugin Executor) lets the server run plugins *on* the remote machine (disk, load, users, processes).

```mermaid
sequenceDiagram
    Nagios->>NRPE daemon (node1:5666): check_nrpe -c check_load
    NRPE daemon (node1:5666)->>Local plugin: run check_load
    Local plugin-->>NRPE daemon (node1:5666): output + exit code
    NRPE daemon (node1:5666)-->>Nagios: result
```

**Remote host (`/etc/nagios/nrpe.cfg`)**
```
allowed_hosts=127.0.0.1,192.168.56.10
command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10
command[check_load]=/usr/lib/nagios/plugins/check_load -w 5,4,3 -c 10,8,6
command[check_disk]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /
```
**Server** – service using it:
```cfg
define service {
    use                 generic-service
    host_name           node1
    service_description Load via NRPE
    check_command       check_nrpe!check_load
}
```
Port **5666/tcp** must be open.

## 4. Other monitoring methods
- **SNMP** (`check_snmp`) for network devices.
- **SSH** checks (`check_by_ssh`).
- **Passive** via NSCA.
- Write your own plugin – a script that prints `STATUS - message | perfdata` and exits 0–3.

## 5. Notifications & contacts
Flow: state change (hard) → check `notification_period`, `notification_options` (w,u,c,r) → send to `contact_groups` via `notify-host-by-email` / `notify-service-by-email`. Requires a working MTA (`mailutils`/`postfix`).

## 6. Validating & reloading
```bash
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg   # pre-flight check
sudo systemctl restart nagios
```
Always **verify before restart** – one typo stops Nagios from starting.

## 7. Web UI cheat-sheet
*Tactical Overview*, *Hosts*, *Services*, *Problems → Unhandled*, *Map*, *Reports → Availability / Alerts*, *System → Process Info*, acknowledge a problem, schedule downtime, force a check.

## ✍️ Quick revision questions
1. Write host + service definitions to monitor SSH on a server.
2. Why do we use NRPE? Explain its flow and port.
3. What does `use generic-service` do?
4. Write a custom plugin that checks free RAM and returns the right exit codes.
5. How do you validate Nagios configuration?
