#Install dependencies
sudo apt-get 
DB_ROOT_PASS=root-pass
DB_WP_PASS=wp-pass

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DB_PASS'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DB_PASS'
sudo apt-get update -y
sudo apt-get install -y wordpress php libapache2-mod-php mysql-server php-mysql apache2 mysql-client ufw

sudo service mysql start
mkdir -p /etc/apache2/sites-available

#Configure mysql 
mysql -u "root" -p'$DB_ROOT_PASS' -e "CREATE DATABASE wordpress;"
mysql -u "root" -p'$DB_ROOT_PASS' -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost IDENTIFIED BY '$DB_WP_PASS';"
mysql -u "root" -p'$DB_ROOT_PASS' -e "FLUSH PRIVILEGES;"


#Configure Apache2 server
cat <<EOF | sudo tee /etc/apache2/sites-available/wordpress.conf
Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>	
EOF


mkdir -p /etc/wordpress


cat <<EOF | sudo tee /etc/wordpress/config-localhost.php 
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', '$DB_WP_PASS');
define('DB_HOST', 'localhost');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
EOF



sudo service mysql start
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo service apache2 reload
