define grid_pool_accounts::virtual::pool_account (
  $ensure                  = 'present',
  $username                = $title,
  $password                = '*NP*',
  $shell                   = '/bin/bash',
  $manage_home             = true,
  $home_dir                = "/home/${title}",
  $primary_group           = undef,
  $uid                     = undef,
  $groups                  = [],
  $comment                 = "mapped user for group ${primary_group}",
  $gridmapdir              = '/etc/grid-security/gridmapdir',
) {
  case $ensure {
    'present': {
      $dir_owner  = $username
      $dir_group  = $primary_group
      if $primary_group {
        Group[$primary_group] -> User[$title]
      }
    }
    'absent': {
      $dir_owner  = undef
      $dir_group  = undef
      # removing users / groups inverses the relationship between them, meaning
      # the group requires the user because the users have to be removed before
      # the group can be removed: http://projects.puppetlabs.com/issues/9622
      if $primary_group {
        User[$title] -> Group[$primary_group]
      }
    }
    default : {
      err("Invalid value given for ensure: ${ensure}. Must be one of present, absent.")
    }
  }

  @user { $username:
    tag        => 'grid_pool_accounts::pool_account::useraccount',
    ensure     => $ensure,
    name       => $username,
    comment    => $comment,
    uid        => $uid,
    password   => $password,
    shell      => $shell,
    gid        => $primary_group,
    groups     => $groups,
    home       => $home_dir,
    managehome => $manage_home,
  }

  @file { "${gridmapdir}/${username}":
    tag     => 'grid_pool_accounts::pool_account::gridmapdir',
    ensure  => $ensure,
    require => File[$gridmapdir],
  }
}
