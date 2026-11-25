# Practical 4 — Install Nagios Core and Nagios Plugins

## 🎯 Aim
Compile and install **Nagios Core** with the standard plugins on Ubuntu 22.04 and open the web dashboard.

## 🧰 Requirements
`control` VM, 2 GB+ RAM, sudo, internet. Port 80 reachable from your browser (Vagrant: `http://192.168.56.10/nagios`).

## 🪜 Steps
1. Check the latest versions on <https://www.nagios.org/downloads/> and edit `NAGIOS_VER` / `PLUGINS_VER` at the top of the script if needed.
2. Run
   ```bash
   chmod +x install_nagios.sh
   sudo ./install_nagios.sh 'ChooseAPassword'
   ```
   The script installs dependencies, builds Nagios and plugins, creates the `nagiosadmin` web user, verifies the config and starts the services.
3. Verify
   ```bash
   sudo systemctl status nagios apache2 --no-pager
   sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
   ```
4. Browse to `http://192.168.56.10/nagios`, log in as **nagiosadmin**. Open *Hosts* and *Services* – `localhost` should be monitored.

## ✅ Expected output
Config check ends with `Total Warnings: 0 / Total Errors: 0`; the dashboard lists `localhost` as **UP** with services like *Ping*, *Root Partition*, *HTTP*, *Total Processes*.

## 🛠️ Troubleshooting
| Symptom | Fix |
|---------|-----|
| 403/404 on `/nagios` | `sudo a2enmod cgi rewrite && sudo systemctl restart apache2` |
| `Could not open command file` | `sudo usermod -aG nagios www-data` then restart apache |
| Plugin not found | Make sure the plugins build finished into `/usr/local/nagios/libexec` |

## 📝 Viva questions
- Why do we create a separate `nagios` user/group?
- Where are plugins and config files stored after installation?
- What does `nagios -v` do?
