# = Class: apt::source::backports
#
# If you want to use backports, please include this.
# It choose distribution based on lsb parameter.
#
# Requires:
#   lsb
#
# Usage:
#   class { 'apt::source::backports':
#     priority => '200',
#   }
class apt::source::backports ( $priority = '600' ) {
  if $::lsbdistcodename != 'sid' {
    apt::source { 'backports':
      url => $::lsbdistcodename ? {
        /(squeeze)/ => 'http://backports.debian.org/debian-backports',
        default => 'http://ftp.jp.debian.org/debian',
      },
      dist => "${::lsbdistcodename}-backports",
    }
    apt::preference { 'backports':
      package => '*',
      pin => "release a=${::lsbdistcodename}-backports",
      priority => $priority,
    }
  }
}

