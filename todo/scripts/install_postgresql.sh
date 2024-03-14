#!/bin/bash

# Instala o PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Inicia o PostgreSQL
sudo systemctl start postgresql

# Verifica se o PostgreSQL está em execução
sudo systemctl status postgresql

# Configura a senha do usuário 'postgres' para '123456'
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"

# Reinicia o PostgreSQL para aplicar as alterações
sudo systemctl restart postgresql

echo "PostgreSQL instalado e configurado com sucesso. O usuário postgres foi configurado com a senha '123456'."
