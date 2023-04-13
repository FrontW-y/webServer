#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2


sudo mkdir -p /var/www/html/images
sudo echo "ma page" | sudo tee /var/www/html/index.html
sudo echo "<h1>Lost on internet ?</h1><br><h3>Don't panic we're going to help you</h3><br><br><h5>* <----- yu're here</h5>" | sudo tee /var/www/html/perdu.html
# Copiez une image de votre choix dans le répertoire /var/www/html/images/

# Créer un répertoire privé et protégé par mot de passe
sudo mkdir /var/www/html/private
sudo touch /var/www/html/private/.htaccess
sudo apt-get install -y apache2-utils
sudo htpasswd -c /var/www/html/private/.htpasswd username esma
# Entrez le mot de passe pour "username"

sudo bash -c "cat << EOT > /var/www/html/private/.htaccess
AuthType Basic
AuthName \"Restricted Access\"
AuthUserFile /var/www/html/private/.htpasswd
Require valid-user
EOT"

sudo echo "Désolé cette page n'existe pas ! Page d'erreur perso" | sudo tee /var/www/html/404.html
sudo sed -i 's|</VirtualHost>|    ErrorDocument 404 /404.html\n</VirtualHost>|' /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2
