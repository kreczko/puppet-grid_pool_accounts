#
#
#
module Puppet::Parser::Functions
  newfunction(:get__groupinfo, :type => :rvalue, :doc => <<-'ENDOFDOC'
This function takes an array of users and an array of UIDs and combines them in the form
{username => {uid => $uid}}
Usage:
  create_account_hash([user1, user2], [1111, 1112])
returns:
{user1 => {uid => 1111}, user2 => {uid => 1112}}
  
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = '/var/cache/users.conf'
    groupinfo = Array.new()
    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
        if tmp[5] != 'pilot'
          groupinfo[0] = tmp[3]  # primary group name
          groupinfo[1] = ids[2]   # primary group id
        end

      end
    end
    return groupinfo
  end
end 
