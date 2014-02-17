class grid_pool_accounts::gmapfiles(
) {
  concat { '/etc/grid-security/grid-mapfile':
    owner => 'root',
    group => 'root',
    mode  => '0644',
    order => 'alpha',
  }
  concat { '/etc/grid-security/groupmapfile':
    owner => 'root',
    group => 'root',
    mode  => '0644',
    order => 'alpha',
  }
}
