# = Define: apt::source
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
define apt::source ( $type = 'both', $url, $dist, $components = 'main', $keyurl = '', $keysig = false ) {
  $lines = "$url $dist $components"
  $content = $type ? {
    'deb' => "deb $lines",
    'src' => "deb-src $lines",
    default => "deb $lines
deb-src $lines",
  }

  file { "/etc/apt/sources.list.d/${name}.list":
    ensure => present,
    content => $content,
    #before => Exec['apt-updated'];
  }

  if $keysig {
    apt::key { "$name":
      source => $keyurl,
      keysig => $keysig,
    }
  }
}

define apt::source::ppa () {
}
