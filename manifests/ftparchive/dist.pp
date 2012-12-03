# Usage:
#   apt::ftparchive::dist { 'squeeze':
#     rootdir => '/path/to/root',
#     sections => 'main',
#     archs => 'i386',
#     source => true,
#     vendor => 'mydomain'
#   }
#
define apt::ftparchive::dist (
  $rootdir,
  $owner = 'root',
  $group = 'root',
  $archs,
  $sections = 'main',
  $source = 'false',
  $vendor,
  $keysig ) {

  File {
    require => File["$rootdir"],
    notify => Exec["update-apt-archive-${rootdir}"],
    recurse => true,
  }

  file {
    "$rootdir/dists/$name":
      ensure => directory, owner => $owner, group => $group,
      source => 'puppet:///modules/apt/ftparchive-distsdir';
    "$rootdir/pool/dists/$name":
      ensure => directory, owner => $owner, group => $group,
      source => 'puppet:///modules/apt/ftparchive-pooldir';
    "$rootdir/apt-release-$name.conf":
      content => template('apt/apt-release.conf.erb');
  }

  concat::fragment { "apt-ftparchive.conf-${name}":
    target => "${rootdir}/apt-ftparchive.conf",
    content => template('apt/apt-ftparchive.conf-dist.erb'),
  }
}
