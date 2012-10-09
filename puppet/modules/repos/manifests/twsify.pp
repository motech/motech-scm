class repos::twsify {
  yumrepo { twsify:
    descr    => 'Thoughtworks Sify yum repository',
    baseurl  => 'http://sifylinuxrepo01.thoughtworks.com/CentOS/6.2/os/x86_64/',
    enabled  => 1,
    gpgcheck => 0,
    priority => 10,
  }

  yumrepo { twsify-github:
    descr    => 'Thoughtworks Sify yum repository mirrored from github motechrepo',
    baseurl  => 'http://sifylinuxrepo01.thoughtworks.com/pub/motech/6/x86_64/',
    enabled  => 1,
    gpgcheck => 0,
    priority => 11,
  }
}
