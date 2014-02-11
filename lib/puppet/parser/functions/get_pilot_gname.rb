#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pilot_gname, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns name of pilot group by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = '/var/cache/users.conf'
    gname = ''
    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
        if tmp[5] == 'pilot'
        gids_tmp = tmp[3].split(",")
        gname = gids_tmp[0]
        end

      end
    end
    return gname
  end
end 
