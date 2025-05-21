#!/usr/bin/env bash
# 1) Detecta tu ROS 2 (asume /opt/ros/<distro>)
ROS_DISTRO=$(ls /opt/ros | head -n1)
echo "Usando ROS 2: $ROS_DISTRO"

# 2) Source de ROS 2 y de tu workspace
source /opt/ros/$ROS_DISTRO/setup.bash
source ~/Robotica/install/setup.bash

# 3) (Opcional) instala tus dependencias Python
#    Solo si has añadido librerías nuevas a requirements.txt
if [ -f "requirements.txt" ]; then
  echo "Instalando Python deps…"
  pip3 install --user -r requirements.txt
fi

echo "Entorno ROS 2 listo."
# 