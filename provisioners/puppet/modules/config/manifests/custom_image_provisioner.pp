class config::custom_image_provisioner (
  $source_file,
  $install_dir,
  $enable_custom_image_provisioner = false,
) {

  if $enable_custom_image_provisioner {

    exec { "Extract Custom Image Provisioner to ${install_dir}":
      path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
      command => "mkdir -p ${install_dir} && tar -xvzf ${source_file} --directory ${install_dir}",
      onlyif  => "test -e ${source_file} && ! test -e ${install_dir}",
    }

  }

}

class config::custom_image_provisioner::pre (
  $timeout,
) {
  exec { 'Execute Custom Image Provisioner pre step':
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    command   => "${config::custom_image_provisioner::install_dir}/pre-common.sh",
    logoutput => true,
    timeout   => $timeout,
    onlyif    => "test -x ${config::custom_image_provisioner::install_dir}/pre-common.sh",
  }
}

class config::custom_image_provisioner::post (
  $timeout,
) {
  exec { 'Execute Custom Image Provisioner post step':
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    command   => "${config::custom_image_provisioner::install_dir}/post-common.sh",
    logoutput => true,
    timeout   => $timeout,
    onlyif    => "test -x ${config::custom_image_provisioner::install_dir}/post-common.sh",
  }
}
