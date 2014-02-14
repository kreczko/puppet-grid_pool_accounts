class grid_pool_accounts::simple(
  $id_width     = 3,
  $id_start     = 1,
  $single_group = false,
  $accounts     = {},
) {
  $yaml = inline_template('
---
<% @accounts.keys.sort.each do |vo|
  count = @accounts[vo]["count"].to_i
  pgroup = @accounts[vo].has_key?("group") ? @accounts[vo]["group"] : (@single_group ? vo : nil)
-%>
<%= vo %>:
  account_number_start: <%= sprintf("%0#{@id_width}i", @id_start) %>
  account_number_end: <%= sprintf("%0#{@id_width}i", @id_start.to_i + count - 1) %>
  user_ID_number_start: <%= @accounts[vo]["uid_start"] %>
  user_ID_number_end: <%= @accounts[vo]["uid_start"].to_i + count - 1 %>
  <%- if pgroup -%>
  primary_group: <%= pgroup %>
  <%- end -%>
<%- end -%>
')
#  notify { $yaml: }
  $accountdata = parseyaml($yaml)
  create_resources('grid_pool_accounts', $accountdata)
}
