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


echo "Création des fichiers index.html et perdu.html"
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html'

cp image.jpg /var/www/html/images/

echo "Configuration de la protection par mot de passe du répertoire private"
htpasswd -c /etc/apache2/.htpasswd admin
bash -c 'echo "AuthType Basic
AuthName \"Accès restreint\"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'

echo "Configuration de la page d'erreur personnalisée"
bash -c 'echo "ErrorDocument 404 /erreur.html" > /etc/apache2/conf-available/custom-errors.conf'
bash -c 'echo "<h1>Désolé cette page nexiste pas !</h1>" > /var/www/html/erreur.html'
a2enconf custom-errors



echo "Redémarrage d'Apache"
systemctl restart apache2

echo "Le déploiement est terminé."
