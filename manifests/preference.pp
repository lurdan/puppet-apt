define apt::preference ( $package, $pin, $priority = '1000', $order = '' ) {
#  concat::fragment { "$name":
#    target => '/etc/apt/preferences',
#    order => $order,
  file { "/etc/apt/preferences.d/${order}${name}.pref":
    content => "Package: $package
Pin: $pin
Pin-Priority: $priority

",
  }
}
