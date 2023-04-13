#!/bin/bash

apt-get update
apt-get install -y apache2


mkdir -p /var/www/html/images
echo "ma page" |   tee /var/www/html/index.html
echo "<h1>Lost on internet ?</h1><br><h3>Don't panic we're going to help you</h3><br><br><h5>* <----- yu're here</h5>" |   tee /var/www/html/perdu.html
# Copiez une image de votre choix dans le répertoire /var/www/html/images/

# Créer un répertoire privé et protégé par mot de passe
mkdir /var/www/html/private
touch /var/www/html/private/.htaccess
apt-get install -y apache2-utils
htpasswd -c /var/www/html/private/.htpasswd username esma
# Entrez le mot de passe pour "username"
bash -c "cat << EOT > /var/www/html/private/.htaccess
AuthType Basic
AuthName \"Restricted Access\"
AuthUserFile /var/www/html/private/.htpasswd
Require valid-user
EOT"

echo "Désolé cette page n'existe pas ! Page d'erreur perso" |   tee /var/www/html/404.html
sed -i 's|</VirtualHost>|    ErrorDocument 404 /404.html\n</VirtualHost>|' /etc/apache2/sites-available/000-default.conf

systemctl restart apache2
