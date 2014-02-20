# Define: create_pool_accounts_from_usersconf
#
define grid_pool_accounts::create_pool_accounts_from_usersconf (
  $vo                      = $title,
  $users_conf              = '/etc/puppet/files/grid/users.conf',
  $create_home_dir         = true,
  $create_gridmapdir_entry = false,
) {

  # These custom functions parse file defined by $users_conf. It has be available at puppet server.
  $users         = get_pool_users($vo, $users_conf)
  $uids          = get_pool_uid($vo, $users_conf)
  $primary_group = get_pool_gid($vo, $users_conf)
  $primary_gname = get_pool_gname($vo, $users_conf)
  $pilot_users   = get_pilot_users($vo, $users_conf)
  $pilot_uid     = get_pilot_uid($vo, $users_conf)
  $pilot_gid     = get_pilot_gid($vo, $users_conf)
  $pilot_gname   = get_pilot_gname($vo, $users_conf)

  $uid_size  = size($uids)
  $user_size = size($users)

  $defaults = {
    manage_home             => $create_home_dir,
    primary_group           => $primary_gname,
    create_gridmapdir_entry => $create_gridmapdir_entry,
  }

  $defaults_pilot = {
      manage_home             => $create_home_dir,
      primary_group           => $pilot_gname,
      groups                  => $primary_gname,
      create_gridmapdir_entry => $create_gridmapdir_entry,
  }

  if $uid_size == $user_size {

    # Check if there is any pilot account required for VO
    if empty($pilot_gid) {

      grid_pool_accounts::pool_group { $primary_gname:
        gid => $primary_group,
      }

      $accounts = create_account_hash($users, $uids)
      create_resources('grid_pool_accounts::pool_account', $accounts, $defaults)

    } else {

      grid_pool_accounts::pool_group { $primary_gname:
        gid => $primary_group,
      }
      grid_pool_accounts::pool_group {$pilot_gname:
        gid => $pilot_gid,
      }

      $accounts = create_account_hash($users, $uids)
      $pilot_accounts = create_account_hash($pilot_users, $pilot_uid)

      create_resources('grid_pool_accounts::pool_account', $accounts, $defaults)
      create_resources('grid_pool_accounts::pool_account', $pilot_accounts, $defaults_pilot)
    }

  } else {
    notify { "create_pool_accounts_from_usersconf_error_${title}":
      message => "configuration error in ${users_conf}, UID range is not the same as account range. number of UID: ${uid_size}, number of accounts: ${user_size}",
    }
  }
}
