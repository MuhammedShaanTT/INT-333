# hello.pp — first Puppet manifest
package { 'tree':
  ensure => installed,
}

file { '/tmp/hello_puppet.txt':
  ensure  => file,
  mode    => '0644',
  content => "Managed by Puppet on ${facts['networking']['hostname']} (${facts['os']['name']} ${facts['os']['release']['full']})\n",
}
