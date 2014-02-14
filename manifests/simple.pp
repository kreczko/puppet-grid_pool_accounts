class grid_pool_accounts::simple(
  $id_width     = 3,
  $id_start     = 1,
  $poolgroups   = false,
  $gridmapdir   = undef,
  $accounts     = {},
) {
  if $gridmapdir {
    file { $gridmapdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  $pg_options = [ 'ensure', 'gid' ]

  $pg_yaml = inline_template('
---
<% @accounts.keys.sort.each do |vo|
  pgroup = @accounts[vo].has_key?("group") ? @accounts[vo]["group"] : (@poolgroups ? vo : nil)
-%>
<%= pgroup %>:
  <%- @pg_options.each do |opt|
    if @accounts[vo].has_key?(opt) -%>
  <%= opt %>: <%= @accounts[vo][opt] %>
    <%- end
  end -%>
<%- end -%>
')

#  notify { $pg_yaml: }
  $groupdata = parseyaml($pg_yaml)
  create_resources('grid_pool_accounts::pool_group', $groupdata)

  $pa_options = [ 'ensure' ]

  # IMPORTANT: the account id numbers starting with a 0 have to be quoted in the yaml, otherwise
  # the create_resources call will fail
  # it's causing problem with the range calls in grid_pool_accounts, the ruby process will run out of memory and die
  $pa_yaml = inline_template('
---
<% @accounts.keys.sort.each do |vo|
  count = @accounts[vo]["count"].to_i
  pgroup = @accounts[vo].has_key?("group") ? @accounts[vo]["group"] : (@single_group ? vo : nil)
-%>
<%= vo %>:
  account_number_start: "<%= sprintf("%0#{@id_width}i", @id_start) %>"
  account_number_end: "<%= sprintf("%0#{@id_width}i", @id_start.to_i + count - 1) %>"
  user_ID_number_start: "<%= @accounts[vo]["uid_start"] %>"
  user_ID_number_end: "<%= @accounts[vo]["uid_start"].to_i + count - 1 %>"
  <%- if pgroup -%>
  primary_group: <%= pgroup %>
  <%- end -%>
  <%- if @gridmapdir -%>
  gridmapdir: <%= @gridmapdir %>
  <%- end -%>
  <%- @pa_options.each do |opt|
    if @accounts[vo].has_key?(opt) -%>
  <%= opt %>: <%= @accounts[vo][opt] %>
    <%- end
  end -%>
<%- end -%>
')
#  notify { $pa_yaml: }
  $accountdata = parseyaml($pa_yaml)
  create_resources('grid_pool_accounts', $accountdata)
}
