# How_to_install_postgresql_in_fedora

# example script
this project has Vagrantfile.
```shell
vagrant up
```
postgresql-fedora environment is being launch.

# install sample Database 

## DVDRental

```shell
# change user and read .bash_profile.
sudo su
source ~/.bash_profile

# execute bash function.
enable_dvdrental

# if you drop database, execute below function
disable_dvdrental
```

# if you want to create vagrant box from vagrant file.

```
# stop vagrant environment
vagrant halt

# search virtualbox environment.
ls -1 ~/VirtualBox\ VMs/

# packaging your vagrant virtualbox environment. 
vagrant package --base <yourvirtualbox_environment_name> --output fedora33-postgresql.box

# add box
vagrant box add localhost/fedora33-postgresql fedora33-postgresql.box
```