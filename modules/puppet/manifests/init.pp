class puppet {
  file { '/etc/puppet/puppet.conf':
    content => template('puppet/puppet.erb'),
    notify => Service['puppet']
  }
  service { 'puppet':
    ensure => running,
    enable => true
  }
}
