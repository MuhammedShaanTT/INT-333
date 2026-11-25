# Practical 3 — Modules, templates and master–agent setup

## 🎯 Aim
(a) Build a reusable module with a template. (b) Configure a Puppet **server** (`control`) and **agent** (`node1`), sign the certificate, and deliver the module through `site.pp`.

## 🧰 Requirements
`control` (3 GB RAM) and `node1` from the [lab](../../lab); `/etc/hosts` must resolve `control`/`puppet`.

## Part A — Install the server (on `control`)
```bash
wget https://apt.puppet.com/puppet8-release-jammy.deb && sudo dpkg -i puppet8-release-jammy.deb
sudo apt update && sudo apt install -y puppetserver
# lower JVM memory for small VMs
sudo sed -i 's/-Xms[0-9a-z]*/-Xms512m/; s/-Xmx[0-9a-z]*/-Xmx512m/' /etc/default/puppetserver
sudo systemctl enable --now puppetserver
sudo ss -tlnp | grep 8140          # server is listening
```

## Part B — Create the module (on `control`)
```bash
MOD=/etc/puppetlabs/code/environments/production/modules
sudo mkdir -p $MOD/motd/{manifests,templates}
sudo cp motd/manifests/init.pp   $MOD/motd/manifests/
sudo cp motd/templates/motd.epp  $MOD/motd/templates/
sudo cp site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
sudo /opt/puppetlabs/bin/puppet parser validate $MOD/motd/manifests/init.pp
```

## Part C — Connect the agent (on `node1`)
```bash
wget https://apt.puppet.com/puppet8-release-jammy.deb && sudo dpkg -i puppet8-release-jammy.deb
sudo apt update && sudo apt install -y puppet-agent
sudo /opt/puppetlabs/bin/puppet config set server control --section main
sudo /opt/puppetlabs/bin/puppet agent -t          # first run: sends certificate request
```
Back on `control`:
```bash
sudo /opt/puppetlabs/bin/puppetserver ca list
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname node1
```
On `node1` again:
```bash
sudo /opt/puppetlabs/bin/puppet agent -t          # catalog applied
cat /etc/motd
```

## ✅ Expected output
`/etc/motd` on node1 contains the banner rendered from the template with the node's FQDN, and `puppet agent -t` ends with `Applied catalog`.

## 🛠️ Troubleshooting
| Symptom | Fix |
|---------|-----|
| `Could not resolve 'puppet'` | Add `192.168.56.10 control puppet` to `/etc/hosts` |
| `certificate verify failed` / clock skew | Sync time (`timedatectl`), clean cert: `puppetserver ca clean --certname node1` and delete `/etc/puppetlabs/puppet/ssl` on the agent |
| Server won't start | Not enough RAM – reduce `-Xmx` as above |

## 📝 Viva questions
- Walk through the certificate signing process.
- Which port does the server use? What happens if it is blocked?
- Where does `site.pp` live and what is it for?
- Why use templates instead of static files?
