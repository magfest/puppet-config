class emulators {
#  exec { '/usr/bin/pacman --noconfirm -U http://foreman.magfest.net/bootmedia/install/pkgs/challenges-13.0.0.4-1-any.pkg.tar.xz':
#    creates => "/opt/challenges"
#  }
  package { 'ttf-freefont':
    ensure => present
  }
  exec { '/usr/bin/pacman --noconfirm -U http://foreman.magfest.net/bootmedia/install/pkgs/antimicro-2.6-1-x86_64.pkg.tar.xz':
    creates => "/opt/antimicro"
  }
  file { ['/home/challenges/.config', '/home/challenges/.config/antimicro']:
    ensure => directory,
    owner => challenges
  }
  file { '/home/challenges/.config/antimicro/antimicro_settings.ini':
    ensure => file,
    source => 'puppet:///modules/emulators/antimicro_settings.ini',
    owner => challenges
  }
  package { 'stella':
    ensure => latest
  }
  package { 'zsnes':
    ensure => latest
  }
  package { 'fceux':
    ensure => latest
  }
  package { 'gens-gs':
    ensure => latest
  }
  exec { '/usr/bin/pacman --noconfirm -U http://foreman.magfest.net/bootmedia/install/pkgs/evrouter-0.4-2-i686.pkg.tar.xz':
    creates => '/usr/bin/evrouter'
  }
  user { 'challenges':
    ensure => present,
    password => '$1$ZUm6eWmc$ox8kBH436StQXy8Bv.rgK.',
    groups => ['autologin', 'input', 'wheel']
  }
  file { '/home/challenges':
    ensure => directory,
    owner => challenges,
    group => challenges
  } ->
#  file { '/home/challenges/.profile':
#    source => 'puppet:///modules/emulators/profile',
#    owner => challenges,
#    group => challenges,
#    mode => 755
#  }
  file { '/usr/bin/startchallenges':
    source => 'puppet:///modules/emulators/startchallenges',
    mode => 755
  } ->
  file { '/etc/systemd/system/challenge.service':
    source => 'puppet:///modules/emulators/challenge.service'
  } ->
  file { '/etc/lightdm/challenges.conf':
    source => 'puppet:///modules/emulators/challenges.conf'
  } ->
  service { 'challenge':
    enable => true,
    require => File['/etc/systemd/system/challenge.service']
  }
#  file { '/opt/challenges':
#    owner => challenges,
#    group => challenges,
#    recurse => true
#  }
  file { '/home/challenges/home.tar':
    ensure => file,
    owner => challenges,
    source => 'puppet:///modules/emulators/home.tar'
  }
  file { '/opt/challenges.tar':
    ensure => file,
    owner => challenges,
    source => 'puppet:///modules/emulators/challenges.tar'
  }
  exec { '/usr/bin/tar -xvf ./home.tar':
    cwd => '/home/challenges',
    creates => '/home/challenges/Challenge.py'
  }
  exec { '/usr/bin/tar -xvf ./challenges.tar':
    cwd => '/opt',
    creates => '/opt/challenges/roms/SNES'
  }
}
