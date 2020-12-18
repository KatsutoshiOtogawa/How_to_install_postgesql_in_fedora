dnf -y update

# install firewalld. firewalld is rhel,centos default dynamic firewall.
dnf -y install firewalld

# enabla firewalld.
systemctl enable firewalld
systemctl start firewalld

# port forwarding postgrsql port 5432.
firewall-cmd --add-port=5432/tcp --zone=public --permanent

# reload firewall settings.
firewall-cmd --reload

# install expect and pexpect for silent install.
# dnf install -y expect
# pip3 install pexpect

# install postgresql
dnf -y install postgresql-server

# install postgresql dataafile and clustor to /var/lib/pgsql/data
su - postgres -c 'pg_ctl initdb'

# update postgresql use memory,postgresql_log,style
sed -i 's/^shared_buffers.*$/shared_buffers = 1024MB                 # min 128kB/' /var/lib/pgsql/data/postgresql.conf
sed -i "s/^log_filename.*$/log_filename = 'postgresql-%Y-%m-%d.log'    # log file name pattern,/" /var/lib/pgsql/data/postgresql.conf

echo "===> you want to "

systemctl enable postgresql
systemctl start postgresql

echo "you CREATE DATABASE dependending your locale data, you use these options"
echo "LC_COLLATE [=] lc_collate"
echo "LC_CTYPE [=] lc_ctype" 

cat << END >> ~/.bash_profile
# reference from [postgrsql tutorial](https://www.postgresqltutorial.com/postgresql-sample-database/)
# if you need ER diagram,
# curl -o printable-postgresql-sample-database-diagram.pdf -L https://sp.postgresqltutorial.com/wp-content/uploads/2018/03/printable-postgresql-sample-database-diagram.pdf
function enable_dvdrental () {
    curl -o dvdrental.zip -L https://sp.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip
    mv dvdrental.zip ~postgres
    chown postgres:postgres ~postgres/dvdrental.zip
    su - postgres << EOF
    unzip dvdrental.zip


    # CREATE DATABASE AND CREATE USER FOR migrating data.
    psql << EOF2
    CREATE ROLE DVDRENTAL WITH LOGIN PASSWORD 'dvdrentalpw';
    CREATE DATABASE DVDRENTAL WITH OWNER DVDRENTAL;
EOF2
    pg_restore -d dvdrental dvdrental.tar

    # remove zip and tar files.
    rm -f dvdrental.zip dvdrental.tar
EOF

}

function disable_dvdrental () {
    # drop dvd_rental database.
    su - postgres << EOF
    psql << EOF2
    DROP DATABASE DVDRENTAL;
    DROP ROLE DVDRENTAL;
EOF2

EOF
}

END


# erase fragtation funciton. this function you use vagrant package.
cat << END >> ~/.bash_profile
# eraze fragtation.
function defrag () {
    dd if=/dev/zero of=/EMPTY bs=1M; rm -f /EMPTY
}
END

echo "finish install!"

reboot
