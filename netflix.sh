#!/bin/bash

# Primeiro vamos atualizar o firmware do raspberry, é importante que você apenas utilize esse passo se e apenas se você não tem nada rodando que possa causar incompatibilidade
sudo rpi-update

# Depois de atualizar o firmware reinicie o raspberry
reboot

# Bacaninha, agora vamos remover o chromium para que não haja incompatibilidade de libs
sudo apt-get remove chromium-browser

# Perfeito, agora vamos atualizar o raspbian
sudo apt-get update

# Vamos instar o kpartx para montar uma imagem do chrome os
sudo apt-get install kpartx

# Estes diretórios importantes servem para montar o chrome OS e nossos diretórios de instalação
mkdir /home/pi/NetflixPack
mkdir /tmp/chromeos

# Navegamos até o nosso diretório para baixar o novo chromium (melhor dizendo o velho chromium)
cd /home/pi/NetflixPack

# Pacote de localização padrão
wget https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/9739240/+files/chromium-codecs-ffmpeg-extra_50.0.2661.102-0ubuntu0.14.04.1.1117_armhf.deb https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/9739240/+files/chromium-browser_50.0.2661.102-0ubuntu0.14.04.1.1117_armhf.deb http://launchpadlibrarian.net/259414466/chromium-browser-l10n_50.0.2661.102-0ubuntu0.14.04.1.1117_all.deb https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/8993250/+files/libgcrypt11_1.5.3-2ubuntu4.3_armhf.deb

# Instalação dos pacotes
sudo dpkg -i libgcrypt11_1.5.3-2ubuntu4.3_armhf.deb
sudo dpkg -i chromium-codecs-ffmpeg-extra_50.0.2661.102-0ubuntu0.14.04.1.1117_armhf.deb
sudo dpkg -i chromium-browser_50.0.2661.102-0ubuntu0.14.04.1.1117_armhf.deb
sudo dpkg -i chromium-browser-l10n_50.0.2661.102-0ubuntu0.14.04.1.1117_all.deb

# Aqui marcamos para que não seja feita nenhuma atualização do chromium
sudo apt-mark hold chromium-codecs-ffmpeg-extra chromium-browser chromium-browser-l10n

# Obtemos uma versão estável do chrome OS
wget https://dl.google.com/dl/edgedl/chromeos/recovery/chromeos_7834.60.0_daisy_recovery_stable-channel_snow-mp-v3.bin.zip

# Aplicamos o unzip para obter o arquivo.bin
unzip chromeos_7834.60.0_daisy_recovery_stable-channel_snow-mp-v3.bin.zip

# criamos a partição com o kpartx em um loop
sudo kpartx -av chromeos_7834.60.0_daisy_recovery_stable-channel_snow-mp-v3.bin

# Agora vamos montar as partições loop no diretório tmp que criamos anteriormente
sudo mount -o loop,ro /dev/mapper/loop0p3 /tmp/chromeos/

# Se quiser conferir o loop digita lsblk

# Vamos navegar até as libs do chrome os
cd /tmp/chromeos/opt/google/chrome/

# Vamos copiar as libs para dentro do chromium
sudo cp libwidevinecdm* /usr/lib/chromium-browser/

# Agora, apesar de contraditório, vamos desbloquear as atualizações do chromium e atualizá-lo
sudo apt-mark unhold chromium-codecs-ffmpeg-extra chromium-browser chromium-browser-l10n

# Agora vamos fazer um upgrade no raspberry
sudo apt-get upgrade

#Script de execução minimo para funcionamento do chromium, você ainda pode usar os parâmetros full screen e url para se divertir um pouco mais
chromium-browser --user-agent="Mozilla/5.0 (X11; CrOS armv7l 6946.86.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" --disable-gpu-memory-buffer-video-frames


