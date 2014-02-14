define grid_pool_accounts::pool_group (
  $ensure = 'present',
  $group  = $title,
  $gid    = undef,
  $roles  = [],
) {
  group { $group:
    ensure => $ensure,
    gid    => $gid,
  }
  # create groups
  # update /etc/grid-security/grid-mapfile
  # update /etc/grid-security/groupmapfile
}
