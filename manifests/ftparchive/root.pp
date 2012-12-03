# Usage:
#  apt::ftparchive { 'repo-name':
#    rootdir => '/path/to/repo/debian',
#    gpgid => 'abcde123',
#  }
define apt::ftparchive::root (
  $rootdir,
  $owner = 'root',
  $group = 'root',
  $gpgid ) {

#  exec { "make-${rootdir}":
#    command => "/bin/mkdir -p ${rootdir}/dists ${rootdir}/pool/dists ${rootdir}/.scratch",
#  }
  file { "$rootdir":
    owner => $owner, group => $group,
    source => 'puppet:///modules/apt/ftparchive-rootdir',
    recurse => true,
#    ensure => directory,
#    before => Exec["make-$rootdir"],
  }

  concat { "${rootdir}/apt-ftparchive.conf":
    require => File["$rootdir"],
  }
  concat::fragment { 'apt-ftparchive.conf-general':
    target => "${rootdir}/apt-ftparchive.conf",
    content => template('apt/apt-ftparchive.conf.erb'),
    order => '00',
  }

  exec { "update-apt-archive-${rootdir}":
    command => "/usr/local/bin/update-apt-archive ${rootdir} ${gpgid}",
    require => [ File['/usr/local/bin/update-apt-archive'],
                 Concat["${rootdir}/apt-ftparchive.conf"], ]
  }
  Apt::Ftparchive::Dist <| |> -> Exec["update-apt-archive-${rootdir}"]
}

