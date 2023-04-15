#!/bin/bash

# Couleur vert clair saturé
GREEN="\e[1;32m"
PINK="\e[1;35m"
# Réinitialiser la couleur
RESET="\e[0m"

echo -e "${GREEN}Mise à jour des paquets${RESET}"
echo -e "${PINK}Mise à jour des paquets${RESET}"
apt-get update

echo -e "${GREEN}Installation d'Apache${RESET}"
echo -e "${PINK}Installation d'Apache${RESET}"
apt-get install apache2 -y

echo -e "${GREEN}Configuration du nom de la machine${RESET}"
echo -e "${PINK}Configuration du nom de la machine${RESET}"
hostnamectl set-hostname www

echo -e "${GREEN}Création de l'utilisateur admin et configuration du mot de passe${RESET}"
echo -e "${PINK}Création de l'utilisateur admin et configuration du mot de passe${RESET}"
useradd -m -s /bin/bash admin
echo "admin:vitrygtr" | chpasswd
usermod -aG sudo admin

echo -e "${GREEN}Création des répertoires nécessaires${RESET}"
echo -e "${PINK}Création des répertoires nécessaires${RESET}"
mkdir -p /var/www/html/images
mkdir -p /var/www/html/private

echo -e "${GREEN}Création des fichiers index.html et perdu.html${RESET}"
echo -e "${PINK}Création des fichiers index.html et perdu.html${RESET}"
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html'
bash -c 'echo "<h1>Erreur 404 perso</h1>" > /var/www/html/erreur.html'

cp /root/webServer/image.jpg /var/www/html/images/

echo -e "${GREEN}Configuration de la protection par mot de passe du répertoire private${RESET}"
echo -e "${PINK}Configuration de la protection par mot de passe du répertoire private${RESET}"
htpasswd -c /etc/apache2/.htpasswd admin
bash -c 'echo "AuthType Basic
AuthName \"Accès restreint\"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'

echo -e "${GREEN}Autoriser l'utilisation des fichiers .htaccess et activer le module rewrite${RESET}"
echo -e "${PINK}Autoriser l'utilisation des fichiers .htaccess et activer le module rewrite${RESET}"
sed -i '/<\/VirtualHost>/i <Directory "/var/www/html/private">\n    AllowOverride All\n<\/Directory> ErrorDocument 404 /erreur.html' /etc/apache2/sites-available/000-default.conf
a2enmod rewrite


echo -e "${GREEN}Redémarrage d'Apache${RESET}"
echo -e "${PINK}Redémarrage d'Apache${RESET}"
systemctl restart apache2

echo -e "${GREEN}Le déploiement est terminé.${RESET}"
echo -e "${PINK}Le déploiement est terminé.${RESET}"

systemctl status apache2
