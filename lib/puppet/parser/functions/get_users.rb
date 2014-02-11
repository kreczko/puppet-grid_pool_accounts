#
#
#
module Puppet::Parser::Functions
  newfunction(:get_users, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns an array of normal users  by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]

    filename = '/var/cache/users.conf'
    users = Array.new()
    File.open(filename).each_line do | line |
    tmp = line.split(":")
    if tmp[4] == vo
      if tmp[5] != 'pilot'
      users.push(tmp[1])
      end
    end
    end
    return users
  end
end 
