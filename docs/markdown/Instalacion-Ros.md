<h1>Instalación de ROS y Gazebo</h1>

Para configurar ROS, puedes seguir los pasos que aparecen en la [página ofical de ROS](https://wiki.ros.org/noetic/Installation/Ubuntu), pero aquí lo explicaré para los fines de la clase. Recuerda que todo se hace en la **terminal de Ubuntu** y observa bien si aparece un error.

También existe otro [tutorial enfocado en robots móviles](https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start) (recuerden poner la versión Noetic), pero no será necesario para este proyecto.

<h2>Índice</h2>

<- Para instalar Ubuntu, regresa a la [Instalación de Ubuntu](Instalacion-Ubuntu-WSL.md).
- [Actualiza los paquetes actuales](#actualiza-los-paquetes-actuales)
- [Ejecuta el comando de una línea](#ejecuta-el-comando-de-una-línea)
- [Paquetes extras de ROS y Gazebo](#paquetes-extras-de-ros-y-gazebo)
- [Configura el entorno de ROS 2](#configura-el-entorno-de-ros-2)
- [Terminado](#terminado)

-> El siguiente paso es [Exportar SolidWorks a URDF](sw2urdf.md).

## Actualiza los paquetes actuales

1. Busca paquetes nuevos. El comando `sudo` significa *super user do*, lo que le da permisos de super usuario para realizar acciones que pueden comprometer al equipo, por lo que no uses ese comando descuidadamente. Te pedirá la contraseña la primera vez que ejecutes `sudo` en terminal, así que cuano copies muchas lineas, tómalo en cuenta o saldrán varios errores.

    ```bash
    sudo apt update
    ```
2. Actualiza los paquetes (puede tardar varios minutos)
   
    ```bash
    sudo apt upgrade
    ```
## Ejecuta el comando de una línea

Este comando instala todo lo necesario para usar ROS y Gazebo. Si te preguntra qué versión de ROS usar, pon la opción de `ros-noetic-desktop-full` que es la más completa. Tardarán bastante en instalarse, así que hazlo en un lugar donde tengas tiempo y buen internet.

```bash
wget -c https://raw.githubusercontent.com/qboticslabs/ros_install_noetic/master/ros_install_noetic.sh && chmod +x ./ros_install_noetic.sh && ./ros_install_noetic.sh
```

## Paquetes extras de ROS y Gazebo
Otros paquetes recomendados son los siguientes
```bash
sudo apt-get install ros-noetic-joy \
ros-noetic-teleop-twist-joy \
ros-noetic-teleop-twist-keyboard \
ros-noetic-laser-proc \
ros-noetic-rgbd-launch \
ros-noetic-rosserial-arduino \
ros-noetic-rosserial-python \
ros-noetic-rosserial-client \
ros-noetic-rosserial-msgs \
ros-noetic-amcl \
ros-noetic-map-server \
ros-noetic-move-base \
ros-noetic-urdf \
ros-noetic-xacro \
ros-noetic-compressed-image-transport \
ros-noetic-rqt* \
ros-noetic-rviz \
ros-noetic-gmapping \
ros-noetic-navigation \
ros-noetic-interactive-markers \
ros-noetic-moveit-setup-assistant \
sudo apt install python3-catkin-tools \
gedit
```

## Configura el entorno de ROS 2
Normalmente se tiene que escribir `source /opt/ros/noetic/setup.bash` cada vez que se quiera configurar el entorno de ROS, pero puedes añadir lo siguiente para que siempre se inicie.
```bash
echo "alias sb='source ~/.bashrc'       #macro para actualizar terminal" >> ~/.bashrc
echo "source /opt/ros/noetic/setup.bash #usar comandos de ROS Noetic" >> ~/.bashrc
echo "export LIBGL_ALWAYS_SOFTWARE=1    #Renderizar gráficos por software" >> ~/.bashrc
echo "export LIBGL_ALWAYS_INDIRECT=0" >> ~/.bashrc
source ~/.bashrc
```
Si escribes `sb`, se actualizará la terminal, por lo que se recomienda usarlo si se cambia el archivo `.bashrc`, que es la configuración de la terminal.

## Terminado
Para probar que se instalaron los paquetes, ejecuta 
```bash
gazebo
```
Y debe abrirse la interfaz de gazebo. 
