#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pool_gname, :type => :rvalue, :doc => <<-'ENDOFDOC'
This function takes a vo and returns name of the group by parsing groups.conf file
  
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    gname =''
    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
        if tmp[5] != 'pilot'
          gname = tmp[3]  # primary group name
        end

      end
    end
    return gname
  end
end 
