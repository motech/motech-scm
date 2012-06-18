class ruby {
	package { "ruby" :
		ensure  =>  "present"
	}

	package { "rubygems" :
		ensure  =>  "present",
        require => [Package["ruby"]]
	}

    exec { "install_rubygem_sinatra":
        command => "gem install sinatra",
        require => [Package["rubygems"]]
    }
}

class ruby::rubygem_stomp {
  package { "rubygem-stomp":
    ensure => present,
  }
}
