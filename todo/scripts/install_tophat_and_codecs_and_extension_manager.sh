#!/bin/bash

# Atualizar os repositórios
echo "Atualizando os repositórios..."
sudo apt update -y

# Instalar dependências essenciais para o TopHat
echo "Instalando dependências para o TopHat..."
sudo apt install -y \
  libgtop-2.0-11 \
  gobject-introspection \
  gir1.2-gtop-2.0 \
  gnome-shell-extension-top-hat

# Instalar o Extension Manager via Flatpak (Flathub)
echo "Instalando o Extension Manager via Flatpak..."
sudo apt install -y flatpak

# Adicionar Flathub como fonte
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar o Extension Manager
flatpak install flathub com.mattjakeman.ExtensionManager -y

# Instalar codecs multimídia (caso necessário)
echo "Instalando codecs multimídia..."
sudo apt install -y \
  ubuntu-restricted-extras \
  ffmpeg

# Informar que o script foi concluído com sucesso
echo "Instalação completa!"
echo "Agora, reinicie o GNOME Shell com 'Alt + F2' e digite 'r' para carregar as mudanças."
echo "O Extension Manager foi instalado via Flatpak e você pode gerenciar as extensões GNOME com facilidade."
