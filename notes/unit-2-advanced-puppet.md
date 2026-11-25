# Unit 2 — Advanced Puppet

[← Unit 1](unit-1-puppet-basics.md) · [Notes index](README.md) · [Next: Unit 3 →](unit-3-nagios-overview.md)

## 1. Classes
A class groups resources and is **declared** to apply it.
```puppet
class webserver (
  String $package = 'nginx',
  Integer $port   = 80,
) {
  package { $package: ensure => installed }
  service { $package: ensure => running, enable => true, require => Package[$package] }
}

include webserver                         # declare with defaults
class { 'webserver': port => 8080 }       # resource-like declaration with parameters
```

## 2. Modules
Modules live in `/etc/puppetlabs/code/environments/production/modules/`.
```
mymodule/
├── manifests/init.pp      # class mymodule { }
├── manifests/config.pp    # class mymodule::config { }
├── files/                 # static files  -> puppet:///modules/mymodule/file
├── templates/             # .epp / .erb templates
├── lib/                   # custom facts, functions, types
├── examples/              # sample usage
├── spec/                  # tests
└── metadata.json
```
Naming rule: file `manifests/config.pp` must contain class `mymodule::config`.

## 3. Templates
**EPP** (Puppet's own) vs **ERB** (Ruby).
```puppet
file { '/etc/motd':
  content => epp('mymodule/motd.epp', { 'owner' => 'Shaan' }),
}
```
`templates/motd.epp`:
```
<%- | String $owner | -%>
Welcome to <%= $facts['networking']['fqdn'] %> — managed by <%= $owner %>
```

## 4. Hiera (data separation)
`hiera.yaml` defines the lookup hierarchy; data lives in YAML.
```yaml
# data/common.yaml
webserver::port: 8080
```
Classes automatically look up `class::parameter` keys (**automatic parameter lookup**).

## 5. Defined types
Reusable, *multiple-instance* resources.
```puppet
define mywebsite ($docroot = "/var/www/${title}") {
  file { $docroot: ensure => directory }
}
mywebsite { 'example.com': }
mywebsite { 'demo.org':    }
```

## 6. Node definitions & classification
`manifests/site.pp`:
```puppet
node 'node1.example.com' { include webserver }
node /^db\d+/            { include mysql::server }
node default             { include base }
```
Alternatives: **ENC** (external node classifier), Hiera-based classification, **roles & profiles** pattern (role → profiles → component modules).

## 7. Environments
Directories under `/etc/puppetlabs/code/environments/` (`production`, `development`…). Each has its own `manifests/` and `modules/`. An agent picks one with `environment = development` in `puppet.conf`.

## 8. Master–agent setup & certificates
```bash
# On master (control)
sudo systemctl enable --now puppetserver
# On agent (node1)
sudo /opt/puppetlabs/bin/puppet config set server control --section main
sudo /opt/puppetlabs/bin/puppet agent -t            # creates cert request
# Back on master
sudo /opt/puppetlabs/bin/puppetserver ca list
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname node1
# Agent again
sudo /opt/puppetlabs/bin/puppet agent -t            # applies catalog
```
Communication is SSL-secured; every agent needs a signed certificate.

## 9. Other useful features
- **Facts**: custom and external facts; `$facts` hash.
- **Resource collectors** `File <| tag == 'x' |>`, **virtual** (`@user`) and **exported** resources (`@@`).
- **Puppet lint** & **PDK** (Puppet Development Kit) for quality and testing.
- **Reports & catalogs** inspected via PuppetDB / Puppet Enterprise console.

## ✍️ Quick revision questions
1. Difference between `include` and resource-like class declaration?
2. Folder layout of a module and the naming rule.
3. EPP vs ERB.
4. Why use Hiera? Show a lookup example.
5. List the steps to connect an agent to a master.
