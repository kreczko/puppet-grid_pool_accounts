define grid_pool_accounts::gmapfile(
  $ensure  = 'present',
  $role    = $title,
  $group   = undef,
  $order   = 1,
  $account = undef,
) {
  case $ensure {
    'present': {
      $rid = regsubst($role, '[/=]', '_', 'G')
      concat::fragment { "gridmapfile_${rid}":
        target  => '/etc/grid-security/grid-mapfile',
        order   => "${order}0",
        content => inline_template('<% pa = (@account ? @account : ".#{@group}") -%>
"<%= @role %>/Capability=NULL" <%= pa %>
"<%= @role %>" <%= pa %>
'),
      }
      concat::fragment { "groupmapfile_${rid}":
        target  => '/etc/grid-security/groupmapfile',
        order   => "${order}1",
        content => inline_template('"<%= @role %>/Capability=NULL" <%= @group %>
"<%= @role %>" <%= @group %>
'),
      }
    }
    'absent': {}
    default: {
      err("Invalid value given for ensure: ${ensure}. Must be one of present, absent.")
    }
  }
}
