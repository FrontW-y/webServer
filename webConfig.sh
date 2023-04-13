#!/bin/bash

apt-get update
apt-get install apache2 -y
hostnamectl set-hostname www
useradd -m -s /bin/bash admin
echo "admin:vitrygtr" | chpasswd
usermod -aG sudo admin
mkdir -p /var/www/html/images
mkdir -p /var/www/html/private
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html'
cp webServer/image.jpg /var/www/html/images/
htpasswd -c /etc/apache2/.htpasswd admin
bash -c 'echo "AuthType Basic
AuthName \"Accès restreint\"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'
sed -i '/<\/VirtualHost>/i <Directory "/var/www/html/private">\n    AllowOverride All\n<\/Directory>' /etc/apache2/sites-available/000-default.conf
bash -c 'echo "ErrorDocument 404 /erreur.html" > /etc/apache2/conf-available/custom-errors.conf'
bash -c 'echo "<h1>Désolé cette page nexiste pas !</h1>" > /var/www/html/erreur.html'
systemctl restart apache2


