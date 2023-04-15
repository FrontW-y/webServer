#!/bin/bash


echo -e "Mise à jour des paquets"
apt-get update

echo -e "Installation d'Apache"
apt-get install apache2 -y

echo -e "Configuration du nom de la machine"
hostnamectl set-hostname www

echo -e "Création de l'utilisateur admin et configuration du mot de passe"
useradd -m -s /bin/bash admin
echo "admin:vitrygtr" | chpasswd
usermod -aG sudo admin

echo -e "Création des répertoires nécessaires"
mkdir -p /var/www/html/images
mkdir -p /var/www/html/private

echo -e "Création des fichiers index.html et perdu.html"
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html'
bash -c 'echo "<h1>Erreur 404 personalise</h1>" > /var/www/html/erreur.html'

cp /root/webServer/image.jpg /var/www/html/images/

echo -e "Configuration de la protection par mot de passe du répertoire private"
htpasswd -c /etc/apache2/.htpasswd admin
bash -c 'echo "AuthType Basic
AuthName "Accès restreint"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'

echo -e "Autoriser l'utilisation des fichiers .htaccess et activer le module rewrite"
sed -i '/</VirtualHost>/i <Directory "/var/www/html/private">\n AllowOverride All\n</Directory> ErrorDocument 404 /erreur.html' /etc/apache2/sites-available/000-default.conf
a2enmod rewrite

echo -e "Redémarrage d'Apache"
systemctl restart apache2

echo -e "Le déploiement est terminé."
systemctl status apache2
