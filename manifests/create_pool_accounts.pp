# Define: create_pool_accounts
#
define grid_pool_accounts::create_pool_accounts (
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
  $create_gridmapdir_entry = false,
  $gridmapdir              = '/etc/grid-security/gridmapdir',
) {

  # create virtual resources
  grid_pool_accounts::virtual::create_pool_accounts { $title:
    ensure               => $ensure,
    account_prefix       => $account_prefix,
    account_number_start => $account_number_start,
    account_number_end   => $account_number_end,
    user_ID_number_start => $user_ID_number_start,
    user_ID_number_end   => $user_ID_number_end,
    shell                => $shell,
    manage_home          => $manage_home,
    primary_group        => $primary_group,
    groups               => $groups,
    comment              => $comment,
    gridmapdir           => $gridmapdir,
  }

  # collect virtual resources to create them
  User<| tag == 'grid_pool_accounts::pool_account::useraccount' |>

  if $create_gridmapdir_entry {
    File<| tag == 'grid_pool_accounts::pool_account::gridmapdir' |>
  }
}
