#
#
#
module Puppet::Parser::Functions
  newfunction(:create_account_hash, :type => :rvalue, :doc => <<-'ENDOFDOC'
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
    usernames=arguments[0]
    uids=arguments[1]

    # Check that both args are arrays.
    unless usernames.is_a?(Array) and uids.is_a?(Array)
      raise(Puppet::ParseError, 'create_account_hash(): Requires two arrays to work with')
    end

    accounts = Hash.new()
    usernames.zip(uids).each do |username, uid|
      accounts[username] = Hash.new()
      accounts[username]['uid'] = uid
    end

    return accounts
  end
end
