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
  $vo                      = $title,
  $grid_users_conf         = true,
  $users_conf              = '/etc/puppet/files/grid/users.conf',
  $account_prefix          = 'test',
  $account_number_start    = '000',
  $account_number_end      = '001',
  $user_ID_number_start    = 90000,
  $user_ID_number_end      = 90001,
#  $primary_group           = $title,
  $groups                  = [],
  $comment                 = "mapped user for group $title",
  $create_home_dir         = true,
  $create_gridmapdir_entry = false) {

  if $grid_users_conf {
       # These custom functions parse file defined by $users_conf. It has be available at puppet server. 
       $users = get_pool_users($vo, $users_conf)
       $uids = get_pool_uid($vo, $users_conf)
       $primary_group = get_pool_gid($vo, $users_conf)
       $primary_gname = get_pool_gname($vo, $users_conf)
       $pilot_users = get_pilot_users($vo, $users_conf)
       $pilot_uid   = get_pilot_uid($vo, $users_conf)
       $pilot_gid   = get_pilot_gid($vo, $users_conf)
       $pilot_gname = get_pilot_gname($vo, $users_conf)
   
       $defaults = {
          manage_home             => $create_home_dir,
          primary_group           => $primary_group,
          create_gridmapdir_entry => $create_gridmapdir_entry,
        }
    } 

  
  else {
       $users     = range("${account_prefix}${account_number_start}","${account_prefix}${account_number_end}")
       $uids      = range("${user_ID_number_start}", "${user_ID_number_end}")
       $defaults = {
          manage_home             => $create_home_dir,
          primary_group           => $primary_group,
          groups                  => $groups,
          create_gridmapdir_entry => $create_gridmapdir_entry,
        }
    } 
  
  $uid_size  = size($uids)
  $user_size = size($users)
  
  $defaults_pilot = {
      manage_home             => $create_home_dir,
      primary_group           => $pilot_gid,
      groups                  => $primary_gname,
      create_gridmapdir_entry => $create_gridmapdir_entry,
  }  

  if $uid_size == $user_size {
       # Check if there is any pilot account required for VO
       if empty($pilot_gid) {
           grid_pool_accounts::pool_group {$primary_gname : gid => "$primary_group" }
           $accounts = create_account_hash($users, $uids)
           create_resources('grid_pool_accounts::pool_account', $accounts, $defaults)
       }
       else { 
           grid_pool_accounts::pool_group {$primary_gname : gid => "$primary_group" }
           grid_pool_accounts::pool_group {$pilot_gname   : gid => "$pilot_gid" }
    
           $accounts = create_account_hash($users, $uids)
           $pilot_accounts = create_account_hash($pilot_users, $pilot_uid)

           create_resources('grid_pool_accounts::pool_account', $accounts, $defaults)
           create_resources('grid_pool_accounts::pool_account', $pilot_accounts, $defaults_pilot)
       }

  } else {
        notify { "grid_pool_accounts_error_$title": message => "UID range is not the same as account range. UID range :$user_ID_number_start - $user_ID_number_end, account range: $account_number_start - $account_number_end", 
     }
   } 
}
