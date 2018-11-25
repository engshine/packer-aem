# == Class: config::certs
#
# A Puppet module to retrieve a certificate from ACM and certificate key from AWS Secret Manager
# and store in the temp folder
#
# === Parameters
#
# [*certificate_arn*]
#   ARN of certificate to retrieve from AWS Certificate Manager (ACM)
#
# [*certificate_key_arn*]
#   ARN of certificate key to retrieve from AWS Secrets Manager
#
# [*tmp_dir*]
#   Directory to store the certs and key in before they are removed.
#
# [*region*]
#   The AWS region the certificate and secret are located in
#
# === Authors
#
# Ryan Siebert <ryan.siebert@shinesolutions.com>
#
# === Copyright
#
# Copyright © 2018	Shine Solutions Group, unless otherwise noted.
#
class config::certs (
  $certificate_arn,
  $certificate_key_arn,
  $tmp_dir,
  $region,
) {

  exec { "Create ${tmp_dir}/certs":
    creates => "${tmp_dir}/certs",
    command => "mkdir -p ${tmp_dir}/certs",
    path    => '/usr/local/bin/:/bin/',
  }

  file { "${tmp_dir}/certs":
    ensure => directory,
    mode   => '0700',
  }

  exec { 'Download Certificate from AWS Certificate Manager using cli':
    creates => "${tmp_dir}/certs/aem.cert",
    command => "aws acm get-certificate --region ${region} --certificate-arn ${certificate_arn} --output text --query Certificate > ${tmp_dir}/certs/aem.cert",
    path    => '/usr/local/bin/:/bin/',
    require => File["${tmp_dir}/certs"],
  }

  file { "${tmp_dir}/certs/aem.cert":
    ensure => file,
    mode   => '0600',
  }

  exec { 'Download Secret from AWS Secret Manager using cli':
    creates => "${tmp_dir}/certs/aem.key",
    command => "aws secretsmanager get-secret-value --region ${region} --secret-id ${certificate_key_arn} --output text --query SecretString > ${tmp_dir}/certs/aem.key",
    path    => '/usr/local/bin/:/bin/',
    require => File["${tmp_dir}/certs"],
  }

  file { "${tmp_dir}/certs/aem.key":
    ensure => file,
    mode   => '0600',
  }

}
