# Define: glusterfs::mount
#
# Manage client-side GlusterFS mounts.
#
# Example Usage:
#  glusterfs::mount { '/var/www':
#      device => '192.168.12.1:/gv0',
#  }
#
define glusterfs::mount (
    $device,
    $options = 'defaults',
    $ensure  = 'mounted'
) {

    include glusterfs::client

    file { $title:
        ensure => 'directory'
    }

    mount { $title:
        require => File[$title],
        device  => $device,
        fstype  => 'glusterfs',
        options => $options,
        ensure  => $ensure,
    }
}

