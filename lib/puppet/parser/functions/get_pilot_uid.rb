#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pilot_uid, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns an array of pilot uid by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]

    filename = arguments[1]
    uids = Array.new()
    File.open(filename).each_line do | line |
    tmp = line.split(":")
    if tmp[4] == vo
      if tmp[5] == 'pilot'
      uids.push(tmp[0])
      end
    end
    end
    return uids
 end
end
