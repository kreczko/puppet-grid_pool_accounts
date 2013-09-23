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
  $account_prefix          = $title,
  $account_number_start    = '000',
  $account_number_end      = '001',
  $user_ID_number_start    = 90000,
  $user_ID_number_end      = 90001,
  $primary_group           = undef,
  $groups                  = [],
  $comment                 = "mapped user for group $title",
  $create_home_dir         = true,
  $create_gridmapdir_entry = false) {
  $users     = range("${account_prefix}${account_number_start}", 
  "${account_prefix}${account_number_end}")
  $uids      = range("${user_ID_number_start}", "${user_ID_number_end}")

  $uid_size  = size($uids)
  $user_size = size($users)

  if $uid_size == $user_size {
    grid_pool_accounts::pool_account { $users:
      manage_home             => $create_home_dir,
      primary_group           => $primary_group,
      groups                  => $groups,
      uid                     => $uids,
      create_gridmapdir_entry => $create_gridmapdir_entry,
    }
  } else {
    notify { "grid_pool_accounts_error_$title": message => "UID range is not the same as account range. UID range :$user_ID_number_start - $user_ID_number_end, account range: $account_number_start - $account_number_end", 
    }
  }

}
