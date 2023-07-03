#!/bin/bash

read -p "Nombre de la base de datos: " db_name
read -p "Usuario de la base de datos: " db_user
read -s -p "Contraseña de la base de datos: " db_password
echo
read -p "Punto de conexión de la instancia de RDS: " db_host

# Reemplazar las variables en el Dockerfile
sed -i "s/WORDPRESS_DB_NAME=/WORDPRESS_DB_NAME=$db_name \/g" Dockerfile
sed -i "s/WORDPRESS_DB_USER=/WORDPRESS_DB_USER=$db_user \/g" Dockerfile
sed -i "s/WORDPRESS_DB_PASSWORD=/WORDPRESS_DB_PASSWORD=$db_password \/g" Dockerfile
sed -i "s/WORDPRESS_DB_HOST=/WORDPRESS_DB_HOST=$db_host \/g" Dockerfile

sed -i "s/define('DB_NAME', '');/define('DB_NAME', '$db_name');/g" wp-config.php
sed -i "s/define('DB_USER', '');/define('DB_USER', '$db_user');/g" wp-config.php
sed -i "s/define('DB_PASSWORD', '');/define('DB_PASSWORD', '$db_password');/g" wp-config.php
sed -i "s/define('DB_HOST', '');/define('DB_HOST', '$db_host');/g" wp-config.php
sed -i "s/define('AUTH_KEY',         '');/define('AUTH_KEY',         '$db_password');/g" wp-config.php
sed -i "s/define('SECURE_AUTH_KEY',  '');/define('SECURE_AUTH_KEY',  '$db_password');/g" wp-config.php
sed -i "s/define('LOGGED_IN_KEY',    '');/define('LOGGED_IN_KEY',    '$db_password');/g" wp-config.php
sed -i "s/define('NONCE_KEY',        '');/define('NONCE_KEY',        '$db_password');/g" wp-config.php
sed -i "s/define('AUTH_SALT',        '');/define('AUTH_SALT',        '$db_password');/g" wp-config.php
sed -i "s/define('SECURE_AUTH_SALT', '');/define('SECURE_AUTH_SALT', '$db_password');/g" wp-config.php
sed -i "s/define('LOGGED_IN_SALT',   '');/define('LOGGED_IN_SALT',   '$db_password');/g" wp-config.php
sed -i "s/define('NONCE_SALT',       '');/define('NONCE_SALT',       '$db_password');/g" wp-config.php

echo
echo "Variables de entorno estan actualizadas"
