# == Class: phantomjs
#
# Full description of class phantomjs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
# ::phantomjs{ 'phantomjs': version => '2.1.1', force_update => false }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define phantomjs (
  $package_version = '1.9.7',
  $source_url = undef,
  $source_dir = '/opt',
  $install_dir = '/usr/local/bin',
  $force_update = false,
  $timeout = 300
) {

  $packages = [
    Package['curl'],
    Package['bzip2'],
    Package['libfontconfig1']
  ]

  $pkg_src_url = $source_url ? {
    undef   => "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${package_version}-linux-${::hardwaremodel}.tar.bz2",
    default => $source_url,
  }

  exec { 'get phantomjs':
    command => "/usr/bin/curl --silent --show-error --fail --location ${pkg_src_url} --output ${source_dir}/phantomjs.tar.bz2 \
      && mkdir ${source_dir}/phantomjs \
      && tar --extract --file=${source_dir}/phantomjs.tar.bz2 --strip-components=1 --directory=${source_dir}/phantomjs",
    creates => "${source_dir}/phantomjs/",
    require => $packages,
    timeout => $timeout
  }

  file { "${install_dir}/phantomjs":
    ensure => link,
    target => "${source_dir}/phantomjs/bin/phantomjs",
    force  => true,
  }

  if $force_update {
    exec { 'remove phantomjs':
      command => "/bin/rm -rf ${source_dir}/phantomjs",
      notify  => Exec[ 'get phantomjs' ]
    }
  }
}

