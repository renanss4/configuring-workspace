#!/bin/bash

# Instala o MySQL
sudo apt update
sudo apt install -y mysql-server

# Inicia o MySQL
sudo systemctl start mysql

# Verifica se o MySQL está em execução
sudo systemctl status mysql

# Configura a senha do usuário root para '123456'
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';"

# Reinicia o MySQL para aplicar as alterações
sudo systemctl restart mysql

echo "MySQL instalado e configurado com sucesso. O usuário root@localhost foi configurado com a senha '123456'."
