# == Define: Pool_Account
#  A defined type for managing grid pool accounts
#
# == Information
# https://twiki.cern.ch/twiki/bin/view/FIOgroup/PoolAccountEcosystem
#
# === Examples
#
#  pool_account { 'cmspil111':
#    home_dir      => '/home/cmspil111',
#    uuid          => 80111,
#    primary_group => 'cmspilot',
#    groups        => [ 'cms'],
#  }
define grid_pool_accounts::pool_account (
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
  $create_gridmapdir_entry = false,
) {

  # create virtual resources
  grid_pool_accounts::virtual::pool_account { $title:
    ensure        => $ensure,
    username      => $username,
    password      => $password,
    shell         => $shell,
    manage_home   => $manage_home,
    home_dir      => $home_dir,
    primary_group => $primary_group,
    uid           => $uid,
    groups        => $groups,
    comment       => $comment,
    gridmapdir    => $gridmapdir,
  }

  # collect virtual resources to create them
  User<| tag == 'grid_pool_accounts::pool_account::useraccount' |>

  if $create_gridmapdir_entry {
    File<| tag == 'grid_pool_accounts::pool_account::gridmapdir' |>
  }
}
