define grid_pool_accounts::pool_group (
  $group = $title,
  $gid   = [],
  $roles = [],) {
  group { $group:
    ensure => present,
    gid    => $gid,
  }
  # create groups
  # update /etc/grid-security/grid-mapfile
  # update /etc/grid-security/groupmapfile
}
