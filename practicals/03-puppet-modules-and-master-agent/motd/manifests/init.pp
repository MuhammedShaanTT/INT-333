# Module: motd — manages /etc/motd from a template
class motd (
  String $owner = 'Muhammed Shaan',
  String $course = 'INT333 DevOps',
) {
  file { '/etc/motd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('motd/motd.epp', {
      'owner'  => $owner,
      'course' => $course,
    }),
  }
}
