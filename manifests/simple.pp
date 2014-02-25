# == Class: grid_pool_accounts::simple
#
# A wrapper class to make creating pool accounts and pool groups easier.
#
# === Parameters:
#
# [*poolaccounts*]
#       This is a hash which defines the sets of pool accounts that should be
#       created. The hash key defines the name of the set and the value is
#       another hash with the configuration options for each set of accounts.
#       See 'Accounts Definiton' below for a description of the hash contents.
# [*accounts*]
#       This is a hash which defines a number of single accounts that can be
#       used to map groups of users to single accounts.
# [*id_width*]
#       Defines how many digits should be used for the pool account ID.
#       The default width is 3 which creates 3 digit IDs, e.g. 027.
# [*id_start*]
#       Defines at which number the pool account IDs should start.
#       The default is 1 which means the IDs start at 001.
# [*poolgroups*]
#       Specifies whether pool groups should be used for the pool accounts.
#       The default is false, every pool account will have its own primary
#       group. If it is set to true then every set of pool accounts will use
#       the same primary group. The name of the set is used as group name
#       unless a different group name is defined in the accounts hash.
#       A group definition in the pool account configuration (accounts)
#       overrides this option for the set of pool accounts for which it is
#       defined.
# [*gridmapdir*]
#       Specifies the path of the gridmapdir. If it is defined then the
#       gridmapdir file for each pool account is created in that directory.
#
# === Accounts Definition:
#
#
#
# === Example:
#
# class { grid_pool_accounts::simple:
#   id_width   => 4,                # use 0000 to 9999 as IDs
#   id_start   => 0,                # start with 0000 rather than 0001
#   poolgroups => true,
#   gridmapdir => '/etc/grid-security/gridmapdir',
#   poolaccounts   => {
#     atlas => {                    # uses 'atlas' as primary group
#       uid_start => 10000,
#       count     => 1000,          # 1000 accounts, highest ID is 0999
#     },
#     northg  => {
#       uid_start => 12000,
#       count     => 50,            # 50 accounts, highest ID is 0050
#       group     => 'northgrid',   # use northgrid as primary group, not northg
#     }
#   },
# }
class grid_pool_accounts::simple(
  $enable          = [],
  $poolaccounts    = {},
  $accounts        = {},
  $groups          = {},
  $id_width        = 3,
  $id_start        = 1,
  $use_auto_groups = false,
  $gridmapdir      = undef,
) {
  if $gridmapdir {
    file { $gridmapdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  $groupdata = simple_create_group_hash($groups, $enable, $use_auto_groups, $poolaccounts, $accounts)
  create_resources('@group', $groupdata)

  $pool_vos = unique(flatten([$enable, keys($poolaccounts)]))
  $single_vos = unique(flatten([$enable, keys($accounts)]))

#  $pa_options = [ 'ensure' ]

  # IMPORTANT: the account id numbers starting with a 0 have to be quoted in the yaml, otherwise
  # the create_resources call will fail
  # it's causing problem with the range calls in grid_pool_accounts,
  # the ruby process on the server will run out of memory and die
  $pa_yaml = inline_template('
---
<% @pool_vos.each do |vo|
  if @poolaccounts.has_key?(vo)
    count = @poolaccounts[vo]["count"].to_i
    pgroup = @poolaccounts[vo].has_key?("pgroup") ? @poolaccounts[vo]["pgroup"] : (@poolgroups ? vo : nil)
-%>
<%= vo %>:
  ensure: <%= (@enable.include?(vo) ? "present" : "absent") %>
  account_number_start: "<%= sprintf("%0#{@id_width}i", @id_start) %>"
  account_number_end: "<%= sprintf("%0#{@id_width}i", @id_start.to_i + count - 1) %>"
  user_ID_number_start: "<%= @poolaccounts[vo]["uid_start"] %>"
  user_ID_number_end: "<%= @poolaccounts[vo]["uid_start"].to_i + count - 1 %>"
    <%- if pgroup -%>
  primary_group: <%= pgroup %>
    <%- end -%>
    <%- if @gridmapdir -%>
  gridmapdir: <%= @gridmapdir %>
    <%- end -%>
<%- end
end -%>
')
#  <%- @pa_options.each do |opt|
#    if @poolaccounts[vo].has_key?(opt) -%>
#  <%= opt %>: <%= @poolaccounts[vo][opt] %>
#    <%- end
#  end -%>
  notify { "${title} pa_yaml: ${pa_yaml}": }
  $accountdata = parseyaml($pa_yaml)
  create_resources('@grid_pool_accounts::create_pool_accounts', $accountdata)

  $mf_yaml = inline_template('
---
<% i=1
@pool_vos.each do |vo|
  if @poolaccounts[vo].has_key?("role") -%>
<%= @poolaccounts[vo]["role"] %>:
  ensure: <%= (@enable.include?(vo) ? "present" : "absent") %>
    <%- if @poolaccounts[vo].has_key?("pgroup") -%>
  group: <%= @poolaccounts[vo]["pgroup"] %>
  order: <%= i %>
  account: .<%= vo %>
    <%- else -%>
  group: <%= vo %>
    <%- end -%>
<%- end
  i=i+1
end -%>
')
  notify { "${title} mf_yaml: ${mf_yaml}": }
  $gmdata = parseyaml($mf_yaml)
  create_resources('@grid_pool_accounts::gmapfile', $gmdata)
}
