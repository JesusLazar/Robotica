<- Para instalar ROS, regresa a [Instalación de ROS y Gazebo](Instalacion-Ros.md)
- [Instalación de Move It 2](#instalación-de-move-it-2)
- [Instalación](#instalación)
- [Crea un Workspace de Colcon y descarga los tutoriales](#crea-un-workspace-de-colcon-y-descarga-los-tutoriales)
- [Compila (build) tu Workspace de Colcon](#compila-build-tu-workspace-de-colcon)
- [Configurar el Workspace de Colcon](#configurar-el-workspace-de-colcon)

-> Para exportar el robot de SolidWorks a URDF, ve a [SolidWorks2URDF](sw2urdf.md).

# Instalación de Move It 2
MoveIt es una plataforma que permite configurar de forma más sencilla los robots para la planificación del movimiento, manipulación, percepción 3D, cinemática, control y navegación.
Lo mostrado aquí se puede encontrar en el [Tutorial de MoveIt](https://moveit.picknik.ai/main/doc/tutorials/getting_started/getting_started.html).\
Es la versión 2 porque usa ROS 2 para funcionar. La última versión de ROS 1, Noetic Ninjemys, dejará de recibir actualizaciones en mayo del 2025 y actualmente se usará ROS 2 porque se corrigieron varios problemas y a la vez lo vuelve incompatible a menos que se usen varios recursos.

# Instalación
1. Actualiza los paquetes:
    ```bash
    sudo rosdep init
    rosdep update
    sudo apt update
    sudo apt dist-upgrade
    ```
2. Instala Colcon, que es la herramienta de compilación de paquetes.
    ```bash
    sudo apt install python3-colcon-common-extensions
    sudo apt install python3-colcon-mixin
    colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml
    colcon mixin update default
    ```
# Crea un Workspace de Colcon y descarga los tutoriales
1. Crea un directorio del Workspace y entra en él.
    ```bash
    mkdir -p ~/ws_moveit/src
    cd ~/ws_moveit/src
    ```
2. Clona el repositorio de GitHub para la versión de ROS que tienes instalada.
    ```bash
    git clone -b $ROS_DISTRO https://github.com/moveit/moveit2_tutorials
    ```
   * Si la versión es muy nueva, te saldrá un mensaje de error porque aun no crean el repositorio, así que usa el repositorio main para la última versión:
    ```bash
    git clone -b main https://github.com/moveit/moveit2_tutorials
    ```
# Compila (build) tu Workspace de Colcon
1. Si tenías instalado moveit antes, desintálalo
    ```bash
    sudo apt remove ros-$ROS_DISTRO-moveit*
    ```
2. Lo siguiente instalará desde Debian cualquier dependencia de paquete que no esté ya en su área de trabajo. Este es el paso que instalará MoveIt y todas sus dependencias:
    ```bash
    sudo apt update && rosdep install -r --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y
    ```
 3. El siguiente comando configurará el espacio de trabajo Colcon. **ADVERTENCIA**: Este comando de compilación tardará probablemente mucho tiempo (más de 20 minutos) dependiendo de la velocidad de tu ordenador y de la cantidad de RAM disponible. Si tienes 16 o más GB de RAM, ejecuta
    ```bash
    cd ~/ws_moveit
    colcon build --mixin release
    ```
   * Si tienes una papa de computadora, usa el siguiente, aunque será bastante más tardado:
    ```bash
    cd ~/ws_moveit
    MAKEFLAGS="-j4 -l1" colcon build --executor sequential
    ```
# Configurar el Workspace de Colcon
```bash
echo 'source ~/ws_moveit/install/setup.bash' >> ~/.bashrc
sb
```
Esto permitirá usar ese Workspace de forma predeterminada. Puedes editar el archivo `.bashrc` y cambiar `ws_moveit` para usar otro Workspace (anteriormente configurado con Colcon).