#!/bin/bash

ENV_FILE="/var/www/laravel/.env"

MYSQL_CONFIG="DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel_user
DB_PASSWORD=secure_password"


sudo apt update -y
sudo apt install software-properties-common -y

install_apache() {
	if ! command -v apache2ctl &> /dev/null; then
		
		sudo apt install apache2 -y
	fi
}

install_git() {
	if ! command -v git &> /dev/null; then
	       sudo apt install git -y
	fi
}

install_ondrej_repo() {
	sudo add-apt-repository ppa:ondrej/php -y
	sudo apt update -y
}

install_php_dependencies() {
	if ! command -v php &> /dev/null; then

		sudo apt install php8.2 php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip -y
		sudo a2enmod rewrite
		sudo systemctl restart apache2
	fi
}

install_composer() {
	if ! command -v composer &> /dev/null; then
		
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
		php -r "if (hash_file('sha384', 'composer-setup.php') !== '$(curl -sS https://composer.github.io/installer.sig)') { unlink('composer-setup.php'); exit(1); }"
		php composer-setup.php --install-dir=/usr/local/bin --filename=composer ENV COMPOSER_ALLOW_SUPERUSER=1
		php -r "unlink('composer-setup.php');"

	fi
}

clone_laravel() {

	cd /var/www

	sudo git clone https://github.com/laravel/laravel
	sudo chown -R $USER:$USER laravel/
	cd laravel/
	sudo install composer autoloader --no-interaction
	sudo composer install --optimize-autoloader --no-dev --no-interaction
	sudo composer update --no-interaction

	sudo cp .env.example .env
	sudo chown -R www-data storage
	sudo chown -R www-data bootstrap/cache
}

setup_laravel_config() {
	cd /etc/apache2/sites-available/
	touch main.conf

	sudo echo '<VirtualHost *:80>
	    ServerName localhost
	    DocumentRoot /var/www/laravel/public
	    <Directory /var/www/laravel>
		AllowOverride All
	    </Directory>
	    ErrorLog ${APACHE_LOG_DIR}/laravel-error.log
	    CustomLog ${APACHE_LOG_DIR}/laravel-access.log combined
	    </VirtualHost>' | sudo tee /etc/apache2/sites-available/main.conf
	sudo a2ensite main.conf
	sudo a2dissite 000-default.conf
	sudo systemctl restart apache2
}

write_db_config() {
	if ! grep -q "DB_CONNECTION=mysql" "$ENV_FILE"; then
		    # If not found, append the MySQL configuration to the .env file
		        echo "$MYSQL_CONFIG" >> "$ENV_FILE"
	fi
}

install_mysql() {
	if ! dpkg -l mysql-server | grep -qw mysql-server; then
		sudo apt install mysql-server -y
		sudo mysql_secure_installation
		systemctl start mysql
	fi

	sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS laravel;"
	sudo mysql -u root -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'secure_password';"
	sudo mysql -u root -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laravel_user'@'localhost';"
	#sudo mysql -u root -e "FLUSH PRIVILEGES;"

	write_db_config	
}

run_php() {
	cd /var/www/laravel
	sudo php artisan key:generate
	sudo php artisan storage:link
	sudo php artisan migrate --force
	sudo php artisan db:seed
	sudo systemctl restart apache2
}


install_apache

install_git

install_ondrej_repo

install_php_dependencies

install_composer

clone_laravel

setup_laravel_config

install_mysql

run_php


