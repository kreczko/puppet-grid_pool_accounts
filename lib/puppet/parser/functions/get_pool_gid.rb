#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pool_gid, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns gid of the group by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    gid = ''
    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
        if tmp[5] != 'pilot'
          gid = tmp[2]   # primary group id
        end

      end
    end
    return gid
  end
end 
