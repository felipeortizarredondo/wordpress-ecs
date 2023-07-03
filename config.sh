#!/bin/bash

echo
read -p "Nombre de la base de datos: " db_name
read -p "Usuario de la base de datos: " db_user
echo -n "Contraseña de la base de datos: "
stty -echo
read db_password
stty echo
echo
read -p "Punto de conexión de la instancia de RDS: " db_host

# Verificar si las variables ya están definidas en el Dockerfile
if grep -q "WORDPRESS_DB_NAME=$db_name" Dockerfile && grep -q "WORDPRESS_DB_USER=$db_user" Dockerfile && grep -q "WORDPRESS_DB_PASSWORD=$db_password" Dockerfile && grep -q "WORDPRESS_DB_HOST=$db_host" Dockerfile; then
  echo "Las variables de entorno ya están definidas en el Dockerfile. Saltando la actualización del Dockerfile."
else
  # Reemplazar las variables en el Dockerfile
  sed -i "s|WORDPRESS_DB_NAME=.*|WORDPRESS_DB_NAME=$db_name |g" Dockerfile
  sed -i "s|WORDPRESS_DB_USER=.*|WORDPRESS_DB_USER=$db_user |g" Dockerfile
  sed -i "s|WORDPRESS_DB_PASSWORD=.*|WORDPRESS_DB_PASSWORD=$db_password |g" Dockerfile
  sed -i "s|WORDPRESS_DB_HOST=.*|WORDPRESS_DB_HOST=$db_host |g" Dockerfile

  echo "Variables de entorno actualizadas en el Dockerfile."
fi

# Verificar si las variables ya están definidas en el wp-config.php
if grep -q "define('DB_NAME', '$db_name');" wp-config.php && grep -q "define('DB_USER', '$db_user');" wp-config.php && grep -q "define('DB_PASSWORD', '$db_password');" wp-config.php && grep -q "define('DB_HOST', '$db_host');" wp-config.php && grep -q "define('AUTH_KEY', '$db_password');" wp-config.php && grep -q "define('SECURE_AUTH_KEY', '$db_password');" wp-config.php && grep -q "define('LOGGED_IN_KEY', '$db_password');" wp-config.php && grep -q "define('NONCE_KEY', '$db_password');" wp-config.php && grep -q "define('AUTH_SALT', '$db_password');" wp-config.php && grep -q "define('SECURE_AUTH_SALT', '$db_password');" wp-config.php && grep -q "define('LOGGED_IN_SALT', '$db_password');" wp-config.php && grep -q "define('NONCE_SALT', '$db_password');" wp-config.php; then
  echo "Las variables de entorno ya están definidas en el wp-config.php. Saltando la actualización del wp-config.php."
else
  # Reemplazar las variables en el wp-config.php
  sed -i "s|define('DB_NAME', '.*');|define('DB_NAME', '$db_name');|g" wp-config.php
  sed -i "s|define('DB_USER', '.*');|define('DB_USER', '$db_user');|g" wp-config.php
  sed -i "s|define('DB_PASSWORD', '.*');|define('DB_PASSWORD', '$db_password');|g" wp-config.php
  sed -i "s|define('DB_HOST', '.*');|define('DB_HOST', '$db_host');|g" wp-config.php
  sed -i "s|define('AUTH_KEY', '.*');|define('AUTH_KEY', '$db_password');|g" wp-config.php
  sed -i "s|define('SECURE_AUTH_KEY', '.*');|define('SECURE_AUTH_KEY', '$db_password');|g" wp-config.php
  sed -i "s|define('LOGGED_IN_KEY', '.*');|define('LOGGED_IN_KEY', '$db_password');|g" wp-config.php
  sed -i "s|define('NONCE_KEY', '.*');|define('NONCE_KEY', '$db_password');|g" wp-config.php
  sed -i "s|define('AUTH_SALT', '.*');|define('AUTH_SALT', '$db_password');|g" wp-config.php
  sed -i "s|define('SECURE_AUTH_SALT', '.*');|define('SECURE_AUTH_SALT', '$db_password');|g" wp-config.php
  sed -i "s|define('LOGGED_IN_SALT', '.*');|define('LOGGED_IN_SALT', '$db_password');|g" wp-config.php
  sed -i "s|define('NONCE_SALT', '.*');|define('NONCE_SALT', '$db_password');|g" wp-config.php

  echo "Variables de entorno actualizadas en el wp-config.php."
fi

echo
echo
read -p "Ingresa la cuenta de usuario RDS: " db_user_rds
echo "Ingresa la contraseña creada para el RDS: "
stty -echo
read db_password_rds
stty echo
echo

# Verificar si la base de datos ya existe
mysql -h $db_host -P 3306 -u $db_user_rds -p$db_password_rds -e "USE $db_name" >/dev/null 2>&1
db_exists=$?

# Verificar si el usuario ya existe
mysql -h $db_host -P 3306 -u $db_user_rds -p$db_password_rds -e "SELECT User FROM mysql.user WHERE User = '$db_user'" >/dev/null 2>&1
user_exists=$?

if [ $db_exists -eq 0 ] && [ $user_exists -eq 0 ]; then
  echo "La base de datos '$db_name' y el usuario '$db_user' ya existen. Saltando la creación de la base de datos y el usuario."
elif [ $db_exists -eq 0 ]; then
  echo "La base de datos '$db_name' ya existe. Saltando la creación de la base de datos."
elif [ $user_exists -eq 0 ]; then
  echo "El usuario '$db_user' ya existe. Saltando la creación del usuario."
else

# Crear la base de datos y otorgar privilegios
mysql -h $db_host -P 3306 -u $db_user_rds -p$db_password_rds <<EOF
CREATE DATABASE $db_name;
CREATE USER '$db_user'@'%' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%';
FLUSH PRIVILEGES;
EOF

fi
