#Install dependencies
sudo apt-get 

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root-pass'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root-pass'
sudo apt-get update -y
sudo apt-get install -y wordpress php libapache2-mod-php mysql-server php-mysql apache2 mysql-client ufw

sudo service mysql start
mkdir -p /etc/apache2/sites-available

#Configure mysql 
mysql -u "root" -proot-pass -e "CREATE DATABASE wordpress;"
mysql -u "root" -proot-pass -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost IDENTIFIED BY 'wp-pass';"
mysql -u "root" -proot-pass -e "FLUSH PRIVILEGES;"


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
define('DB_PASSWORD', 'wp-pass');
define('DB_HOST', 'localhost');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
EOF

#Data base config
sudo git clone  https://github.com/CMS-FFC/Miscellaneous.git
sudo mysql -u root -proot-pass < Miscellaneous/wordpress.db
sudo cp /etc/wordpress/config-localhost.php /etc/wordpress/config-168.5.50.php


sudo service mysql start
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo service apache2 reload
