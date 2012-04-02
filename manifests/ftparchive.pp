class apt::ftparchive {
  package { 'apt-utils': ensure => installed, }
  Package['apt-utils'] -> Apt::Ftparchive::Root <| |>
  file { '/usr/local/bin/update-apt-archive':
    mode => 750, owner => root, group => 0,
    source => 'puppet:///modules/apt/update-apt-archive',
  }
}

