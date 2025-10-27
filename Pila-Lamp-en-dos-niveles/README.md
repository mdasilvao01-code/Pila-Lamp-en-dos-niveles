# Pila-Lamp-en-dos-niveles

# 🛠️ Infraestructura LAMP en Dos Niveles con Vagrant

Este proyecto implementa una infraestructura de dos niveles utilizando Vagrant y Debian 12. Se despliega una aplicación de gestión de usuarios descargada desde [IES Albarregas](https://informatica.iesalbarregas.com/mod/url/view.php?id=4382), separando los servicios web (Apache + PHP) y base de datos (MariaDB) en dos máquinas virtuales.

---

## 📦 Estructura del Proyecto



---

## 🧱 Arquitectura

- **MarioApache**: Servidor web con Apache, PHP y la aplicación.
  - Acceso a Internet vía NAT.
  - Reenvío de puertos: `localhost:8080 → VM:80`
- **MarioMysql**: Servidor de base de datos con MariaDB.
  - Sin acceso a Internet.
  - Comunicación interna por red privada (`192.168.33.11`)

---

## ⚙️ Vagrantfile

```ruby
Vagrant.configure("2") do |config|
  config.vm.define "MarioApache" do |apache|
    apache.vm.box = "debian/bookworm64"
    apache.vm.hostname = "MarioApache"
    apache.vm.network "forwarded_port", guest: 80, host: 8080
    apache.vm.network "private_network", ip: "192.168.33.10"
    apache.vm.provision "shell", path: "Apache.sh"
  end

  config.vm.define "MarioMysql" do |mysql|
    mysql.vm.box = "debian/bookworm64"
    mysql.vm.hostname = "MarioMysql"
    mysql.vm.network "private_network", ip: "192.168.33.11"
    mysql.vm.provision "shell", path: "Mysql.sh"
  end
end


#!/bin/bash
apt update
apt install -y apache2 php php-mysqli unzip wget

# Descargar y desplegar la aplicación
wget -O app.zip https://informatica.iesalbarregas.com/mod/url/view.php?id=4382
unzip app.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/
systemctl restart apache2



#!/bin/bash
apt update
apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb
sleep 5

mysql -u root 
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'mario'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'mario'@'%';
FLUSH PRIVILEGES;

---

```



## 🌐 Servidor Apache

El servidor web Apache se despliega en la máquina `MarioApache` y sirve la aplicación PHP a través del puerto 80 de la VM. Para facilitar el acceso desde el navegador del host, se ha configurado un reenvío de puertos:

- 🖥️ **Host (tu PC):** [http://localhost:8080](http://localhost:8080)
- 📦 **VM Apache:** `http://192.168.33.10:80`



### 🔧 Configuración de red
apache.vm.network "forwarded_port", guest: 80, host: 8080
apache.vm.network "private_network", ip: "192.168.33.10"



## 🖼️ Capturas de pantalla

A continuación se muestran evidencias del correcto funcionamiento de la infraestructura:

---

### 🔹 Apache funcionando

![Apache funcionando](screenshot/Apache.png)

> Acceso exitoso a la aplicación desde [http://localhost:8080](http://localhost:8080)

---

### 🔹 MariaDB funcionando

![MariaDB funcionando](screenshot/Mysql.png)

> Servicio activo y base de datos `gestion_usuarios` creada correctamente.

---




