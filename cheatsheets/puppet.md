# Puppet cheat-sheet

| Task | Command |
|------|---------|
| Version | `puppet --version` |
| Syntax check | `puppet parser validate x.pp` |
| Dry run | `puppet apply --noop x.pp` |
| Apply | `sudo puppet apply x.pp` |
| Agent run (verbose) | `sudo puppet agent -t` |
| Show facts | `facter` · `facter os.family` |
| Inspect resource | `puppet resource service nginx` |
| Describe a type | `puppet describe file` |
| Install module | `puppet module install puppetlabs-apache` |
| List signed certs | `puppetserver ca list --all` |
| Sign / clean cert | `puppetserver ca sign --certname n1` / `puppetserver ca clean --certname n1` |
| Config get/set | `puppet config print server` / `puppet config set server control --section main` |
| Lint | `puppet-lint file.pp` |

**Paths:** binaries `/opt/puppetlabs/bin` · config `/etc/puppetlabs/puppet/puppet.conf` · code `/etc/puppetlabs/code/environments/production/` · SSL `/etc/puppetlabs/puppet/ssl` · port **8140**.

**Syntax reminders**
```puppet
type { 'title': attr => value, }          # resource
Type['title']                             # reference
$var = 'x'                                # variable
Package['a'] -> Service['b']              # ordering   (~> also notifies)
class name ($p = 1) { }  include name     # class
define name ($p) { }                      # defined type
```
