# Practical 5 — Monitor remote hosts and services with Nagios

## 🎯 Aim
Add `node1` and `node2` to Nagios, monitor ping, SSH and HTTP, group them, and test an alert.

## 🪜 Steps (on `control`)
1. Create a folder for your own objects and enable it
   ```bash
   sudo mkdir -p /usr/local/nagios/etc/servers
   echo 'cfg_dir=/usr/local/nagios/etc/servers' | sudo tee -a /usr/local/nagios/etc/nagios.cfg
   ```
2. Copy the definitions from this folder
   ```bash
   sudo cp servers/*.cfg /usr/local/nagios/etc/servers/
   sudo chown -R nagios:nagios /usr/local/nagios/etc/servers
   ```
3. Edit the e-mail address in [`servers/contacts.cfg`](servers/contacts.cfg).
4. **Validate, then reload** (never restart without validating)
   ```bash
   sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
   sudo systemctl restart nagios
   ```
5. Open the dashboard → *Hosts*: `node1`, `node2` appear. Initial status may be *PENDING* for a minute.
6. **Test alerting**: on `node1` run `sudo systemctl stop ssh` (or `sudo ufw deny 22` ) → *SSH* turns **CRITICAL** after the retries. Start it again and watch it return to **OK** (recovery).
7. Try *Acknowledge problem*, *Schedule downtime* and *Re-schedule next check* from the service page.

## ✅ Expected output
Hosts **UP**, services **OK**; after stopping SSH, the service goes SOFT CRITICAL → HARD CRITICAL and a notification is generated.

## 📝 Viva questions
- Soft vs hard state; which setting controls how many retries?
- What does `use linux-server` do?
- Why validate the configuration before restarting?
- Difference between hostgroup and servicegroup?
