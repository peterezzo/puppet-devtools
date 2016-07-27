# install some development tools that are hard to fit in hiera
# due to different distro naming and install methods
class devtools() {

  # not sure if boto3 is in repo for ubuntu yet
  case $::osfamily {
    'Debian': {
      $packages = [
          'build-essential',
          'python-docopt',
        ]
      }
    'RedHat': {
      $packages = [
          'python2-boto3',
          'python-docopt',
        ]

      # yum groups are not installed through puppet
      exec { 'developmenttools':
        path    => '/usr/bin/:/bin/',
        unless  => 'yum grouplist "Development tools" | grep "^Installed Groups"',
        command => 'yum -y groupinstall "Development tools"',
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  # install some packages
  package { $packages:
    ensure  => 'present',
  }
}
