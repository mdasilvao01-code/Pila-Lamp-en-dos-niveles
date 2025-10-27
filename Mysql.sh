#!/bin/bash

# Actualizar repositorios e instalar MariaDB
sudo apt update
sudo apt install -y mariadb-server

# Habilitar y arrancar el servicio (puede llamarse mysql en algunas versiones)
sudo systemctl enable mariadb || systemctl enable mysql
sudo systemctl start mariadb || systemctl start mysql

# Crear base de datos y usuario
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'mario'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'mario'@'%';
FLUSH PRIVILEGES;
EOF