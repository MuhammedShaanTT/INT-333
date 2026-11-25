#!/usr/bin/env bash
# Install Nagios Core + Nagios Plugins from source on Ubuntu 22.04
# Usage: sudo ./install_nagios.sh '<nagiosadmin-password>'
set -euo pipefail

# --- versions: check https://www.nagios.org/downloads/ for the newest ones ---
NAGIOS_VER="4.5.5"
PLUGINS_VER="2.4.10"

[[ $EUID -eq 0 ]] || { echo "Run as root (sudo)."; exit 1; }
ADMIN_PASS="${1:-}"
[[ -n "$ADMIN_PASS" ]] || { echo "Usage: sudo $0 '<nagiosadmin-password>'"; exit 1; }

echo "==> Installing dependencies"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php \
  libgd-dev openssl libssl-dev bc gawk dc snmp libnet-snmp-perl gettext build-essential

cd /tmp

echo "==> Building Nagios Core ${NAGIOS_VER}"
wget -q -O "nagios-${NAGIOS_VER}.tar.gz" \
  "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-${NAGIOS_VER}/nagios-${NAGIOS_VER}.tar.gz"
tar xzf "nagios-${NAGIOS_VER}.tar.gz"
cd "nagios-${NAGIOS_VER}"
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install-groups-users
usermod -aG nagios www-data
make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
a2enmod rewrite cgi
cd /tmp

echo "==> Creating web user nagiosadmin"
htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin "$ADMIN_PASS"
chown nagios:nagios /usr/local/nagios/etc/htpasswd.users

echo "==> Building Nagios Plugins ${PLUGINS_VER}"
wget -q -O "nagios-plugins-${PLUGINS_VER}.tar.gz" \
  "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-${PLUGINS_VER}/nagios-plugins-${PLUGINS_VER}.tar.gz"
tar xzf "nagios-plugins-${PLUGINS_VER}.tar.gz"
cd "nagios-plugins-${PLUGINS_VER}"
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

echo "==> Verifying configuration"
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

echo "==> Starting services"
systemctl enable --now apache2
systemctl enable --now nagios
systemctl restart apache2

IP=$(hostname -I | awk '{print $1}')
echo
echo "Done. Open http://${IP}/nagios  (user: nagiosadmin)"
