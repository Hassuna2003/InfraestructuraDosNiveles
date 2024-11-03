
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

# Permitimos conexiones entrantes por el puerto 80
sudo ufw allow 80/tcp

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
