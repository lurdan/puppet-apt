# = Class: apt
#
#
# Parameters:
#
# Defines:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apt ( $repo = false ) {
  package {
    'debian-archive-keyring':
      ensure => latest;
  }

  case $repo {
    'ftparchive': {
      class { 'apt::ftparchive':; }
    }
    'mini-dinstall': {
    }
    'reprepro': {
    }
  }

  exec {
    'apt-updated': command => '/usr/bin/apt-get update';
## uncomment after puppet issues #6748, #7422, #8050 solved
#    'apt-preseed-cleanup':
#      command => '/usr/bin/rm -f /var/cache/debconf/*.preseed',
#      refreshonly => true;
  }

  Apt::Key <| |> -> Apt::Conf <| |> -> Exec['apt-updated']
  Apt::Source <| |> -> Exec['apt-updated']
  Apt::Preference <| |> -> Exec['apt-updated']
  Exec['apt-updated'] -> Package <| |> #-> Exec['apt-preseed-cleanup']
}
