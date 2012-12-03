define apt::conf ( $content, $order = '' ) {
  file { "/etc/apt/apt.conf.d/${order}${name}":
    ensure => present,
    content => $content,
    before => Exec['apt-updated'];
  }
}
