#!/bin/bash

echo "Mise à jour des paquets"
apt-get update

echo "Installation d'Apache"
apt-get install apache2 -y

echo "Configuration du nom de la machine"
hostnamectl set-hostname www

echo "Création de l'utilisateur admin et configuration du mot de passe"
useradd -m -s /bin/bash admin
echo "admin:vitrygtr" | chpasswd
usermod -aG sudo admin

echo "Création des répertoires nécessaires"
mkdir -p /var/www/html/images
mkdir -p /var/www/html/private

echo "Création des fichiers index.html, perdu.html et erreur.html"
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
bash -c 'echo "Vous êtes perdu sur internet ?" > /var/www/html/perdu.html'
bash -c 'echo "<h1>Cette page est une page derreur personalisé</h1> > /var/www/html/erreur.html'

cp image.jpg /var/www/html/images/

echo "Configuration de la protection par mot de passe du répertoire private"
htpasswd -c /etc/apache2/.htpasswd admin
bash -c 'echo "AuthType Basic
AuthName "Accès restreint"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'

echo "Autoriser l'utilisation des fichiers .htaccess"
sed -i '/</VirtualHost>/i <Directory "/var/www/html/private">\n AllowOverride All\n</Directory> ErrorDocument 404 /erreur.html' /etc/apache2/sites-available/000-default.conf

echo "Redémarrage d'Apache"
systemctl restart apache2

echo "Le déploiement est terminé."

systemctl status apache2
