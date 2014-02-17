define grid_pool_accounts::gmapfile(
  $role = $title,
  $group,
  $account = undef,
) {
  $rid = regsubst($role, '[/=]', '_', 'G')
  notify { "rid: ${rid}": }
  concat::fragment { "gridmapfile_${rid}":
    target  => '/etc/grid-security/grid-mapfile',
    order   => $rid,
    content => inline_template('<% pa = (@account ? @account : ".#{@group}") -%>
"<%= @role %>/Capability=NULL" <%= pa %>
"<%= @role %>" <%= pa %>
'),
  }
  concat::fragment { "groupmapfile_${rid}":
    target  => '/etc/grid-security/groupmapfile',
    order   => $rid,
    content => inline_template('"<%= @role %>/Capability=NULL" <%= @group %>
"<%= @role %>" <%= @group %>
'),
  }
}
