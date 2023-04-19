#!/bin/bash
apt-get update # Mettre à jour la liste des paquets disponibles
apt-get install apache2 -y # Installer le serveur web Apache2
hostnamectl set-hostname www # Définir le nom de l'hôte sur "www"
useradd -m -s /bin/bash admin # Créer un utilisateur "admin" avec un répertoire personnel et un shell bash
echo "admin:vitrygtr" | chpasswd # Définir le mot de passe de l'utilisateur "admin" sur "vitrygtr"
usermod -aG sudo admin # Ajouter l'utilisateur "admin" au groupe sudo pour lui donner les droits d'administration
mkdir -p /var/www/html/images # Créer le répertoire "/var/www/html/images" s'il n'existe pas déjà
mkdir -p /var/www/html/private # Créer le répertoire "/var/www/html/private" s'il n'existe pas déjà
echo "Création des fichiers index.html et perdu.html"
bash -c 'echo "<h1>Bienvenue sur notre site !</h1>" > /var/www/html/index.html' # Écrire "<h1>Bienvenue sur notre site !</h1>" dans le fichier "/var/www/html/index.html"
bash -c 'echo "<h1>Traduction de Perdu.com</h1>" > /var/www/html/perdu.html' # Écrire "<h1>Traduction de Perdu.com</h1>" dans le fichier "/var/www/html/perdu.html"
bash -c 'echo "<h1>Erreur 404 personalise</h1>" > /var/www/html/erreur.html' # Écrire "<h1>Erreur 404 personalise</h1>" dans le fichier "/var/www/html/erreur.html"
cp /root/webServer/image.jpg /var/www/html/images/ # Copier l'image "/root/webServer/image.jpg" dans le répertoire "/var/www/html/images"
htpasswd -c /etc/apache2/.htpasswd admin # Créer un fichier "/etc/apache2/.htpasswd" avec le nom d'utilisateur "admin" et son mot de passe crypté
bash -c 'echo "AuthType Basic
AuthName "Accès restreint"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user" > /var/www/html/private/.htaccess' # Écrire les directives de sécurité pour le répertoire "/var/www/html/private" dans le fichier "/var/www/html/private/.htaccess"
echo "Autoriser l'utilisation des fichiers .htaccess et activer le module rewrite"
sed -i '/</VirtualHost>/i <Directory "/var/www/html/private">\n AllowOverride All\n</Directory> ErrorDocument 404 /erreur.html' /etc/apache2/sites-available/000-default.conf # Ajouter les directives de sécurité pour le répertoire "/var/www/html/private" dans le fichier de configuration Apache2 "/etc/apache2/sites-available/000-default.conf"
a2enmod rewrite # Activer le module rewrite d'Apache2 pour permettre la réécriture d'URLs
systemctl restart apache2 # Redémarrer le serveur web Apache2
systemctl status apache2 # Vérifier l'état du serveur web Apache2
