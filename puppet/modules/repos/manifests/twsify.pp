class repos::twsify {
  yumrepo { twsify:
    descr    => 'Thoughtworks Sify yum repository',
    baseurl  => 'http://sifylinuxrepo01.thoughtworks.com/CentOS/6.2/os/x86_64/',
    enabled  => 1,
    gpgcheck => 0,
    priority => 10,
  }
}
