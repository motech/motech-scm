class repos {
  include repos::puppetlabs
  include repos::jenkins
  include repos::epel
  include repos::jpackage
  include repos::motech
  include repos::epelcouchdb
}
