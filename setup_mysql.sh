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

# Definimos variables
DB_USER='DB_USER'
DB_HOST='192.168.10.11'
DB_PASSWORD='ubuntu'

# Accedemos a MySQL para crear un nuevo usuario y darle permisos.
sudo mysql -u root <<EOF
DROP USER IF EXISTS '$DB_USER'@'$DB_HOST'; 
CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$DB_HOST';
FLUSH PRIVILEGES;
EOF

# Desactivamos el acceso a Internet eliminando la puerta de enlace predeterminada.
sudo ip route del default


