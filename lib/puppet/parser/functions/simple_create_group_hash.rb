module Puppet::Parser::Functions
  newfunction(:simple_create_group_hash, :type => :rvalue) do |args|
    groups = args[0]
    enabled_vos = args[1]
    use_auto_groups = args[2]
    allow_remove = args[5]
    raise(Puppet::ParseError, "simple_create_group_hash, first argument has to be a hash") unless groups.is_a?(Hash)
    raise(Puppet::ParseError, "simple_create_group_hash, second argument has to be an array") unless enabled_vos.is_a?(Array)
    raise(Puppet::ParseError, "simple_create_group_hash, fourth argument has to be a hash") unless args[3].is_a?(Hash)
    raise(Puppet::ParseError, "simple_create_group_hash, fifth argument has to be a hash") unless args[4].is_a?(Hash)
    enabled_groups = []
    all_groups = []
    all_accounts = args[3].merge(args[4])
    all_accounts.keys.uniq.each do |vo|
      vo_enabled = enabled_vos.include?(vo)
      if all_accounts[vo].has_key?('pgroup')
        all_groups.push(all_accounts[vo]['pgroup'])
        enabled_groups.push(all_groups.last) if vo_enabled
      else
        # use the VO name as primary group name
        all_groups.push(vo)
        enabled_groups.push(vo) if vo_enabled
      end
      if all_accounts[vo].has_key?('sgroup')
        sgroups = all_accounts[vo]['sgroup'].split(',')
        all_groups.push(sgroups).flatten!
        enabled_groups.push(sgroups).flatten! if vo_enabled
      end
    end
    all_groups.sort!.uniq!
    enabled_groups.sort!.uniq!
    groupdef = {}
    all_groups.each do |group|
      if enabled_groups.include?(group)
        if use_auto_groups or groups.has_key?(group)
          groupdef[group] = {
            'ensure' => 'present',
            'tag'    => 'grid_pool_accounts::simple::group',
          }
          groupdef[group]['gid'] = groups[group] if groups and groups.has_key?(group)
        else
          raise(Puppet::ParseError, "simple_create_group_hash, ERROR: group #{group} is enabled, but not configured and automatic groups generation is disabled")
        end
      elsif allow_remove
        groupdef[group] = {
          'ensure' => 'absent',
          'tag'    => 'grid_pool_accounts::simple::group',
        }
      end
    end
    groupdef
  end
end
