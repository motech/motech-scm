# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base {
  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444';
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555';
  }

  case $::operatingsystem {
    'Debian','Ubuntu': {
      include logrotate::defaults::debian
    }
    default: { }
  }
}
