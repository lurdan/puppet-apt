# = Define: apt::key
#
#
# Parameters:
#   $ensure
#     present|absent
#   $source
#     URL where public key exists
#   $keysig
#     signature of gpg key
#
# Defines:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   apt::key { 'my-repo':
#     ensure => present,
#     keysig => 'ABCDEFGH',
#     source => 'http://localhost/apt-key.pub',
#   }
#
define apt::key( $ensure = 'present', $source = false, $keysig ) {
  case $ensure {
    present: {
      exec { "apt-key-$name":
        command => $source ? {
          false => "/usr/bin/gpg --keyserver pgp.mit.edu --recv-key '$keysig' && gpg --export --armor '$keysig' | /usr/bin/apt-key add -",
          default => "/usr/bin/wget -O - $source | /usr/bin/apt-key add -",
        },
        unless => "/usr/bin/apt-key list | /bin/grep -Fqe '$keysig'",
#        refreshonly => true,
      }
    }
    absent: {
      exec { "/usr/bin/apt-key del $name":
        onlyif => "/usr/bin/apt-key list | /bin/grep -Fqe '$keysig'",
      }
    }
  }
}
