define apt::preseed ( $content ) {
  file {
    "/var/cache/debconf/$name.preseed":
      mode => 600,
      content => $content,
      before => Package["$name"],
  }
}
