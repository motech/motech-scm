class ruby {
	package { "ruby" :
		ensure  =>  "present"
	}

    exec { "install_rubygem_sinatra":
        command => "gem install sinatra",
        require => [Package["ruby"]]

    }
}

class ruby::rubygem_stomp {
  package { "rubygem-stomp":
    ensure => present,
  }
}
