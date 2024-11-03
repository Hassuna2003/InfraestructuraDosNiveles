# InfraestructuraDosNiveles

# Práctica de Infraestructura de Dos Niveles

## Introducción
En esta práctica, hemos montado una infraestructura de dos niveles utilizando Apache y MySQL. El objetivo es configurar un entorno web donde Apache sirve como servidor web y MySQL como servidor de base de datos.

## Configuración del Entorno Apache
1. **Descarga del Repositorio**:
   - Se descargó un repositorio de GitHub que contiene los archivos necesarios para la aplicación web.
   - El archivo `src` descargado del repositorio se ubicó en el directorio `/var/www/html` para que la página sea accesible desde el navegador.

2. **Estructura de Archivos**:
   - El directorio `src` contiene los siguientes archivos:
     - `add.html`: Formulario para añadir datos.
     - `add.php`: Script para procesar la adición de datos.
     - `config.php`: Archivo de configuración para la conexión a la base de datos.
     - `delete.php`: Script para eliminar datos.
     - `edit.php`: Script para editar datos.
     - `index.php`: Página principal de la aplicación.

## Configuración del Entorno MySQL
  **Eliminación de Usuarios Previos**:
   - Se descargó el repositorio de GitHub para usar el directorio `db`. El directorio `db` contiene el archivo `database.sql`, que incluye las instrucciones para crear y poblar la base de datos.
   - Se eliminaron los usuarios previos de MySQL para asegurar un entorno limpio y seguro.
   - Se creó un nuevo usuario con los permisos necesarios para interactuar con la base de datos.

## Edición del Archivo config.php
- Se editó el archivo `config.php` para incluir las credenciales del nuevo usuario de MySQL y otros parámetros de configuración necesarios para la conexión a la base de datos.

## Creación de Ficheros de Aprovisionamiento
- Se crearon ficheros de aprovisionamiento para automatizar la configuración del entorno. Estos ficheros incluyen scripts para instalar dependencias, configurar servicios y desplegar la aplicación.

## Fichero de Aprovisionamiento Apache

```bash
# Actualizamos la lista de paquetes disponibles para asegurarnos de que todo esté actualizado.
sudo apt-get update -y

# Instalamos Apache (servidor web), Git (herramienta para gestionar código) y OpenSSH Client (para conexiones seguras).
sudo apt-get install -y apache2 git openssh-client -y

# Instalamos PHP y los módulos necesarios para que Apache pueda trabajar con PHP y conectarse a MySQL.
sudo apt install -y php libapache2-mod-php php-mysql

# Instalamos el cliente de MySQL para poder gestionar bases de datos.
sudo apt install -y default-mysql-client

# Permitimos el tráfico a través del firewall para que Apache pueda ser accedido desde fuera.
sudo ufw allow 'Apache'

# Iniciamos el servidor Apache.
sudo systemctl start apache2

# Configuramos Apache para que se inicie automáticamente al encender el servidor.
sudo systemctl enable apache2

# Borramos el archivo index.html por defecto de Apache porque vamos a poner nuestro propio contenido.
sudo rm /var/www/html/index.html

# Clonamos un repositorio de Git que contiene el código de nuestra aplicación.
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /home/vagrant/gestion-usuarios

# Copiamos los archivos de la carpeta src a la carpeta donde Apache busca los archivos para mostrar.
sudo cp -r /home/vagrant/gestion-usuarios/src/* /var/www/html/

# Modificamos el archivo config.php para establecer la configuración de la base de datos.
sudo sed -i "s/'localhost'/'192.168.10.11'/" /var/www/html/config.php
sudo sed -i "s/'database_name_here'/'lamp_db'/" /var/www/html/config.php
sudo sed -i "s/'username_here'/'DB_USER'/" /var/www/html/config.php
sudo sed -i "s/'password_here'/'ubuntu'/" /var/www/html/config.php

# Copiamos la configuración por defecto de Apache a un nuevo archivo de configuración.
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/InfraDosNiveles.conf

# Activamos el nuevo archivo de configuración del sitio.
sudo a2ensite InfraDosNiveles.conf

# Recargamos la configuración de Apache para que los cambios surtan efecto.
sudo systemctl reload apache2

# Desactivamos la configuración por defecto de Apache.
sudo a2dissite 000-default.conf

# Recargamos nuevamente Apache para aplicar los cambios.
sudo systemctl reload apache2

# Cambiamos la propiedad de los archivos en la carpeta src a www-data, que es el usuario de Apache.
sudo chown -R www-data:www-data /var/www/html/

# Reiniciamos Apache para asegurarnos de que todo funcione correctamente con la nueva configuración.
sudo systemctl restart apache2
```


## Fichero de Aprovisionamiento MySQL

```bash
# Actualizamos la lista de paquetes disponibles para asegurarnos de que todo esté actualizado.
sudo apt-get update -y

# Instalamos MySQL (servidor de bases de datos), OpenSSH Server (para conexiones seguras), net-tools (herramientas de red) y Git.
sudo apt-get install -y mysql-server openssh-server net-tools git

# Iniciamos el servicio de MySQL para que comience a funcionar.
sudo systemctl start mysql

# Configuramos MySQL para que se inicie automáticamente al encender el servidor.
sudo systemctl enable mysql

# Iniciamos el servicio SSH para permitir conexiones remotas seguras.
sudo service ssh start

# Clonamos un repositorio de Git que contiene el código de nuestra aplicación.
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /home/vagrant/gestion-usuarios

# Modificamos la configuración de MySQL para que escuche conexiones en la dirección IP específica.
sudo sed -i 's/^bind-address\s*=.*/bind-address        = 192.168.10.11/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos MySQL para aplicar los cambios de configuración.
sudo systemctl restart mysql

# Damos permiso de ejecución al archivo database.sql para que se pueda ejecutar como un script.
sudo chmod +x /home/vagrant/gestion-usuarios/db/database.sql

# Cargamos la base de datos ejecutando los comandos desde el archivo database.sql en MySQL como usuario root.
sudo mysql -u root < /home/vagrant/gestion-usuarios/db/database.sql

# Accedemos a MySQL para crear un nuevo usuario y darle permisos.
sudo mysql -u root <<EOF
DROP USER IF EXISTS '$DB_USER'@'$DB_HOST';  # Eliminamos el usuario si ya existe.
CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';  # Creamos un nuevo usuario con su contraseña.
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$DB_HOST';  # Damos todos los permisos a ese usuario.
FLUSH PRIVILEGES;  # Aplicamos los cambios de privilegios.
EOF

# Desactivamos el acceso a Internet eliminando la puerta de enlace predeterminada.
sudo ip route del default
```
## Imagen de los Servidores funcionando junto a la página Web
![image](https://github.com/user-attachments/assets/b3cb170a-2efc-4264-bbe2-ebbc19b2194f)

## Conclusión
Esta práctica nos permitió entender cómo configurar una infraestructura de dos niveles utilizando Apache y MySQL. Aprendimos a gestionar usuarios de MySQL, importar bases de datos y configurar un servidor web para servir una aplicación dinámica.

