class grid_pool_accounts::edg_mkgridmap {
  file { '/etc/edg-mkgridmap.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/edg-mkgridmap.conf",
  }

  $log_file = '/var/log/edg-mkgridmap.log'
  $output   = '/etc/grid-security/dn-grid-mapfile'

  cron { 'edg_gridmap_cron':
    command     => "(date; edg-mkgridmap --output=${output} --safe) >> ${log_file} 2>&1",
    minute      => '31',
    hour        => '0,6,12,18',
    environment => [
      '/sbin',
      '/bin',
      '/usr/sbin',
      '/usr/bin'],
  }
}
