# Tutorial: Control de **Turtlesim** con Tópicos en ROS Noetic

En esta práctica aprenderás a:

1. Lanzar el simulador **turtlesim**.  
2. Explorar los tópicos disponibles.  
3. Escribir un nodo **publisher** en Python para enviar velocidades (`geometry_msgs/Twist`) a la tortuga.  
4. Escribir un nodo **subscriber** en Python para leer la posición de la tortuga.  
5. Combinar ambos para controlar la tortuga desde tu código.

## 1. Lanzar el simulador

En un terminal, abre el nodo de ROS MASTER:

```bash
source /opt/ros/noetic/setup.bash
roscore
```

y en otro terminal ejecuta el nodo de turtlesim:

```bash
source /opt/ros/noetic/setup.bash
rosrun turtlesim turtlesim_node
```

Verás una ventana con la tortuga.

## 3. Explorar los tópicos

Con otro terminal ejecuta uno por uno los siguientes comandos y analiza lo que aparece:

```bash
# muestra la lista de nodos activos
rosnode list
```
```bash
# muestra los topics disponibles
rostopic list
```
Deberías ver, entre otros:

* `/turtle1/cmd_vel` — para **publicar** velocidades (tipo `geometry_msgs/Twist`).
* `/turtle1/pose`    — para **suscribirse** a la posición (tipo `turtlesim/Pose`).

Para inspeccionar los mensaje en vivo, primero tienes que ver el type del topic, o el tipo de mensaje que usan. Por ejemplo, si escribes

```bash
rostopic type /turtle1/pose
```

verás que el type es `turtlesim/Pose` y si ahora usas

```bash
rosmsg show turtlesim/Pose
```

Se mostrará el mensaje (digamos la variable enviada) y el tipo de dato que se encía, como `float32`.

Si queremos ver ahora el mensaje que envía en tiempo real, podemos ejecutar

```bash
rostopic echo /turtle1/pose
```

Y para que deje de ejecutarse, presionamos `ctrl` + `c`.

## 4. Publicar comandos de velocidad desde la línea

Prueba a mover la tortuga sin escribir código:

```bash
rostopic pub /turtle1/cmd_vel geometry_msgs/Twist \
  "{linear: {x: 2.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 1.8}}"
```

> La tortuga avanzará hacia adelante y girará.

## 5. Nodo **publisher** en Python

Crea un paquete (si no lo tienes):

```bash
cd ~/Robotica/src
catkin_create_pkg turtle_control rospy geometry_msgs
cd ~/Robotica
catkin build
sb
```

Dentro de `~/Robotica/src/turtle_control/scripts/`, crea `move_turtle.py`:

```python
#!/usr/bin/env python
import rospy
from geometry_msgs.msg import Twist

def mover_tortuga():
    rospy.init_node('mover_tortuga', anonymous=True)
    pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)
    rate = rospy.Rate(2)  # 2 Hz

    cmd = Twist()
    cmd.linear.x = 1.0    # velocidad hacia adelante
    cmd.angular.z = 0.5   # velocidad de giro

    while not rospy.is_shutdown():
        pub.publish(cmd)
        rate.sleep()

if __name__ == '__main__':
    try:
        mover_tortuga()
    except rospy.ROSInterruptException:
        pass
```

Hazlo ejecutable y lánzalo:

```bash
chmod +x ~/Robotica/src/turtle_control/scripts/move_turtle.py
rosrun turtle_control move_turtle.py
```

---

## 6. Nodo **subscriber** en Python

En el mismo paquete, crea `read_pose.py`:

```python
#!/usr/bin/env python
import rospy
from turtlesim.msg import Pose

def callback(pose):
    rospy.loginfo("Tortuga en x=%.2f, y=%.2f, θ=%.2f", pose.x, pose.y, pose.theta)

def leer_pose():
    rospy.init_node('leer_pose', anonymous=True)
    rospy.Subscriber('/turtle1/pose', Pose, callback)
    rospy.spin()

if __name__ == '__main__':
    leer_pose()
```

Hazlo ejecutable y pruébalo en paralelo con `turtlesim_node`.

---

## 7. Ejercicio integrado (documenta el proceso con capturas de pantalla y un documento)

1. Modifica `move_turtle.py` para que durante 2 s la tortuga avance y luego gire.
2. Publica velocidades variables (usa `rospy.get_time()` para controlar fases).
3. Observa la salida de `read_pose.py` para verificar que la tortuga se mueve donde esperas.
4. Lee los servicios activos con `rosservice list` e invoca otra tortuga usando `rosservice call /spawn` y el tabulador. Recuerda cambiar el nombre de la tortuga y su posición inicial.
5. Haz que se muevan en bucle
6. Haz que las dos tortugas se muevan y graba un video de 10 segundos.