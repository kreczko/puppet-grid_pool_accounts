define add_grid_role ($role = $title,
  $user = undef,
  $group = undef,
){
   #update /etc/grid-security/grid-mapfile
   #actually, this should go into /etc/edg-mkgridmap.conf and make sure to run the command (edg-mk..)
   #group -> role .group
   #user -> role user
   #use augeas lense
}