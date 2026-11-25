# Practical 6 — Monitor remote resources with NRPE

## 🎯 Aim
Monitor private resources of `node1` (load, disk, logged-in users, processes) via **NRPE**.

```
 Nagios (control) --check_nrpe--> NRPE daemon (node1:5666) --> local plugins
```

## Part A — On the remote host `node1`
```bash
sudo apt update
sudo apt install -y nagios-nrpe-server monitoring-plugins-basic
sudo cp nrpe_local.cfg /etc/nagios/nrpe_local.cfg      # or edit /etc/nagios/nrpe.cfg
sudo sed -i 's/^allowed_hosts=.*/allowed_hosts=127.0.0.1,192.168.56.10/' /etc/nagios/nrpe.cfg
sudo systemctl restart nagios-nrpe-server
sudo systemctl enable nagios-nrpe-server
sudo ss -tlnp | grep 5666            # daemon listening
```
> Check where `monitoring-plugins-basic` put the binaries: `ls /usr/lib/nagios/plugins`. Adjust paths in `nrpe_local.cfg` if needed.

## Part B — On the Nagios server `control`
Install the NRPE plugin (client) — either from apt or build from source:
```bash
sudo apt install -y nagios-nrpe-plugin          # provides /usr/lib/nagios/plugins/check_nrpe
sudo ln -s /usr/lib/nagios/plugins/check_nrpe /usr/local/nagios/libexec/check_nrpe   # if installed from source Nagios
/usr/local/nagios/libexec/check_nrpe -H 192.168.56.11                 # prints NRPE version
/usr/local/nagios/libexec/check_nrpe -H 192.168.56.11 -c check_load   # run a remote check
```
Add the command and services:
```bash
sudo cp nrpe_services.cfg /usr/local/nagios/etc/servers/
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo systemctl restart nagios
```

## ✅ Expected output
`check_nrpe ... -c check_load` returns `OK - load average: 0.01, 0.02, 0.00 | load1=...`. The dashboard shows four new services on `node1`.

## 🛠️ Troubleshooting
| Symptom | Fix |
|---------|-----|
| `CHECK_NRPE: Error - Could not complete SSL handshake` | NRPE version/SSL mismatch – use matching versions on both sides; or `allowed_hosts` is wrong |
| `Connection refused` | Daemon not running, or port 5666 blocked: `sudo ufw allow from 192.168.56.10 to any port 5666` |
| `NRPE: Unable to read output` | Wrong plugin path in `command[...]` |
| `Command not defined` | `nrpe_local.cfg` not included / daemon not restarted |

## 📝 Viva questions
- Why can't Nagios check disk usage of a remote host with `check_ping`?
- Which port does NRPE use? What is `allowed_hosts`?
- Show the thresholds `-w` and `-c` meaning.
- NRPE vs SNMP vs `check_by_ssh`.

## ➕ Bonus — your own plugin
[`custom_check_mem.sh`](custom_check_mem.sh) is a custom plugin. Copy it to `/usr/lib/nagios/plugins/check_mem` on `node1`, make it executable, and add to `nrpe_local.cfg`:
```
command[check_mem]=/usr/lib/nagios/plugins/check_mem -w 20 -c 10
```
Then define a service `check_nrpe!check_mem` on the server.
