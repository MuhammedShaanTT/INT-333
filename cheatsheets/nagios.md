# Nagios cheat-sheet

| Task | Command / Path |
|------|----------------|
| Validate config | `sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg` |
| Start/stop/restart | `sudo systemctl restart nagios` |
| Main config | `/usr/local/nagios/etc/nagios.cfg` |
| Objects | `/usr/local/nagios/etc/objects/` |
| Plugins | `/usr/local/nagios/libexec/` (source) · `/usr/lib/nagios/plugins/` (apt) |
| Logs | `/usr/local/nagios/var/nagios.log` |
| Web | `http://<ip>/nagios` |
| Create web user | `sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin` |
| Run a plugin by hand | `/usr/local/nagios/libexec/check_http -H localhost` |
| NRPE test | `check_nrpe -H <host> -c check_load` |

**Exit codes:** `0 OK` · `1 WARNING` · `2 CRITICAL` · `3 UNKNOWN`  
**Ports:** web 80 · NRPE **5666** · NSCA 5667 · SNMP 161/udp

**Common plugins:** `check_ping` `check_http` `check_ssh` `check_disk` `check_load` `check_users` `check_procs` `check_swap` `check_tcp` `check_dns` `check_smtp` `check_mysql` `check_snmp` `check_by_ssh` `check_nrpe`

**Object skeletons**
```cfg
define host    { use linux-server   host_name h  address 1.2.3.4 }
define service { use generic-service host_name h service_description X check_command check_ssh }
define command { command_name c   command_line $USER1$/check_x -H $HOSTADDRESS$ }
```
