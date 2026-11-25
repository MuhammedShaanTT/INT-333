# webserver.pp — Nginx deployment with a parameterised class
class webserver (
  Integer $port    = 8080,
  String  $docroot = '/var/www/demo',
) {

  # OS-specific package name (kept simple for Debian/Ubuntu + RedHat)
  case $facts['os']['family'] {
    'Debian': { $pkg = 'nginx' }
    'RedHat': { $pkg = 'nginx' }
    default : { fail("Unsupported OS family: ${facts['os']['family']}") }
  }

  package { $pkg:
    ensure => installed,
  }

  file { $docroot:
    ensure => directory,
    owner  => 'root',
    mode   => '0755',
  }

  file { "${docroot}/index.html":
    ensure  => file,
    content => "<h1>Hello from Puppet on ${facts['networking']['hostname']}</h1>\n",
    require => File[$docroot],
  }

  file { '/etc/nginx/conf.d/demo.conf':
    ensure  => file,
    content => "server {\n  listen ${port};\n  root ${docroot};\n  index index.html;\n}\n",
    require => Package[$pkg],
    notify  => Service['nginx'],          # restart nginx when this file changes
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package[$pkg],
  }

  # other common resource types
  user { 'deploy':
    ensure     => present,
    shell      => '/bin/bash',
    managehome => true,
  }

  cron { 'log-uptime':
    command => '/usr/bin/uptime >> /tmp/uptime.log',
    user    => 'root',
    minute  => '*/30',
  }

  exec { 'mark-provisioned':
    command => '/bin/touch /var/tmp/provisioned_by_puppet',
    creates => '/var/tmp/provisioned_by_puppet',
  }
}

include webserver
# To override: class { 'webserver': port => 9090 }
