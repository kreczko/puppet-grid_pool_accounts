# Define: create_pool_accounts
#
define grid_pool_accounts::virtual::create_pool_accounts (
  $ensure                  = 'present',
  $account_prefix          = $title,
  $account_number_start    = '000',
  $account_number_end      = '001',
  $user_ID_number_start    = 90000,
  $user_ID_number_end      = 90001,
  $shell                   = '/bin/bash',
  $manage_home             = true,
  $primary_group           = $title,
  $groups                  = [],
  $comment                 = "mapped user for group ${title}",
  $gridmapdir              = '/etc/grid-security/gridmapdir',
) {

  $users     = range("${account_prefix}${account_number_start}", "${account_prefix}${account_number_end}")
  $uids      = range("${user_ID_number_start}", "${user_ID_number_end}")
  $uid_size  = size($uids)
  $user_size = size($users)

  if $uid_size == $user_size {
    $defaults = {
      ensure                  => $ensure,
      manage_home             => $manage_home,
      primary_group           => $primary_group,
      groups                  => $groups,
      comment                 => $comment,
      gridmapdir              => $gridmapdir,
    }

    $accounts = create_account_hash($users, $uids)
    create_resources('grid_pool_accounts::virtual::pool_account', $accounts, $defaults)

  } else {
    notify { "create_grid_pool_accounts_error_${title}":
      message => "UID range is not the same as account range. UID range: ${user_ID_number_start} - ${user_ID_number_end}, account range: ${account_number_start} - ${account_number_end}",
    }
  }
}
