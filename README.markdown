# grid_pool_accounts #

CI status: [![build status](https://travis-ci.org/HEP-Puppet/puppet-grid_pool_accounts.png)](https://travis-ci.org/HEP-Puppet/puppet-grid_pool_accounts)

This module can create normal and pilot pool accounts by parsing users.conf file as described here
https://twiki.cern.ch/twiki/bin/view/LCG/YaimGuide400#users_conf

It uses custom functions  to parse users.conf file. This modules can be called repeatedly from other module or pass an array of VO's

```
$vo_list = ['atlas', 'alice', 'vo.southgrid.ac.uk']
){
  grid_pool_accounts { $vo_list: }
}
```

It is also possible to create pools account by passing a range of account number and user id.

gridmapdir can be created by enabling $create_gridmapdir_entry.



  
