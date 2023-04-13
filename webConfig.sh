#!/bin/bash

# Mettre à jour les paquets
echo "Mise à jour des paquets"
sudo apt-get update

# Installer Apache
echo "Installation d'Apache"
sudo apt-get install apache2 -y

# Configurer le nom de la machine
echo "Configuration du nom de la machine"
sudo hostnamectl set-hostname www

# Créer l'utilisateur admin et définir le mot de passe
echo "Création de l'utilisateur admin et configuration du mot de passe"
sudo useradd -m -s /bin/bash admin
echo "admin:vitrygtr" | sudo chpasswd
sudo usermod -aG sudo admin

# Créer les répertoires nécessaires
echo "Création des répertoires nécessaires"
sudo mkdir -p /var/www/html/images
sudo mkdir -p /var/www/html/private

# Créer les fichiers index.html et perdu.html
echo "Création des fichiers index.html et perdu.html"
sudo bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html'
sudo bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html'

# Copier l'image de votre choix dans le répertoire images
echo "Copier l'image de votre choix dans le répertoire images (à faire manuellement)"

# Configurer la protection par mot de passe du répertoire private
echo "Configuration de la protection par mot de passe du répertoire private"
sudo htpasswd -c /etc/apache2/.htpasswd admin
sudo bash -c 'echo "AuthType Basic
AuthName \"Accès restreint\"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess'

# Configurer la page d'erreur personnalisée
echo "Configuration de la page d'erreur personnalisée"
sudo bash -c 'echo "ErrorDocument 404 /erreur.html" > /etc/apache2/conf-available/custom-errors.conf'
sudo bash -c 'echo "<h1>Désolé cette page nexiste pas !</h1>" > /var/www/html/erreur.html'
sudo a2enconf custom-errors

# Redémarrer Apache pour prendre en compte les modifications
echo "Redémarrage d'Apache"
sudo systemctl restart apache2

echo "Le déploiement est terminé."
