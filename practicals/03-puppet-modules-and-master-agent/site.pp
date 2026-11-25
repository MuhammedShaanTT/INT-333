# /etc/puppetlabs/code/environments/production/manifests/site.pp
node 'node1', 'node2' {
  include motd
}

node default {
  # nothing for unknown nodes
}
