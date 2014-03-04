# Class: grid_pool_accounts
#
# This module manages grid_pool_accounts
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define grid_pool_accounts (
  $vo_prefix               = $title,
  $grid_users_conf         = true,
  $users_conf              = '/etc/puppet/files/grid/users.conf',
  $account_number_start    = '000',
  $account_number_end      = '001',
  $user_ID_number_start    = 90000,
  $user_ID_number_end      = 90001,
  $primary_group           = $title,
  $groups                  = [],
  $comment                 = "mapped user for group ${title}",
  $create_home_dir         = true,
  $gridmapdir              = '/etc/grid-security/gridmapdir',
  $create_gridmapdir_entry = false,
) {

  if $create_gridmapdir_entry {
    file { $gridmapdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $grid_users_conf {
    grid_pool_accounts::create_pool_accounts_from_usersconf { $vo_prefix:
      users_conf              => $users_conf,
      create_home_dir         => $create_home_dir,
      gridmapdir              => $gridmapdir,
      create_gridmapdir_entry => $create_gridmapdir_entry,
    }
  } else {
    grid_pool_accounts::create_pool_accounts { $vo_prefix:
      account_number_start    => $account_number_start,
      account_number_end      => $account_number_end,
      user_ID_number_start    => $user_ID_number_start,
      user_ID_number_end      => $user_ID_number_end,
      primary_group           => $primary_group,
      groups                  => $groups,
      comment                 => $comment,
      manage_home             => $create_home_dir,
      gridmapdir              => $gridmapdir,
      create_gridmapdir_entry => $create_gridmapdir_entry,
    }
  }
}
