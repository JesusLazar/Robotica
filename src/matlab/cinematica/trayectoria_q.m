function [q, dq, ddq] = trayectoria_q(robot, t, periodo)
%TRAYECTORIA_Q Calcula la trayectoria cíclica, velocidad y aceleración de las articulaciones.
%
%   [q, dq, ddq] = trayectoria_q(robot, t, periodo) genera una trayectoria por defecto
%   para cada articulación del robot, basada en una función cosenoidal.
%
%   Entradas:
%       robot   - Estructura del robot que contiene, entre otros, los siguientes campos:
%                 .NGDL  : Número de eslabones/juntas.
%                 .qMin  : Vector (nx1) con el límite inferior de cada articulación.
%                 .qMax  : Vector (nx1) con el límite superior de cada articulación.
%       t       - Vector de tiempo en el cual se evaluará la trayectoria.
%       periodo - Periodo del movimiento cíclico (en las mismas unidades que t).
%
%   Salidas:
%       q   - Matriz (n x length(t)) de posiciones articulares.
%       dq  - Matriz (n x length(t)) de velocidades articulares.
%       ddq - Matriz (n x length(t)) de aceleraciones articulares.
%
%   La trayectoria para cada articulación se define mediante:
%
%       q_i(t) = qMin(i) + amplitud_i/2 * (1 - cos(w*t))
%
%   donde:
%       amplitud_i = (qMax(i) - qMin(i)) / 2
%       w = 2*pi/periodo    (frecuencia angular)
%
%   De esta forma, la posición oscila entre:
%       q(0)   = qMin(i)  (pues cos(0) = 1)
%       q(T/2) = qMin(i) + 2*amplitud_i = qMax(i)
%
%   La velocidad y aceleración se obtienen derivando esta función:
%       dq/dt = amplitud_i * w * sin(w*t)
%       d²q/dt² = amplitud_i * w² * cos(w*t)
%
%   Nota: Esta es una trayectoria por defecto para la cinemática directa. En el
%         caso de la cinemática inversa, se considerarán perfiles más complejos,
%         donde la posición inicial (o offset) y condiciones de aceleración mínima
%         serán relevantes.
%

% Calcular la frecuencia angular a partir del periodo
w = 2*pi/periodo; % Frecuencia angular

% Inicializar las matrices para q, dq y ddq
q   = zeros(robot.NGDL, length(t));
dq  = zeros(robot.NGDL, length(t));
ddq = zeros(robot.NGDL, length(t));

% Para cada articulación, se calcula la trayectoria cíclica
for i = 1:robot.NGDL
    % Calcular la amplitud (la mitad del rango de movimiento)
    amplitud = robot.qMax(i) - robot.qMin(i);
    
    % Trayectoria cíclica:
    % Se utiliza la función (1 - cos(w*t)), la cual oscila entre 0 y 2.
    % De esta forma, en t=0: cos(0)=1 y se cumple q(i,0)=qMin(i).
    % En t = T/2: cos(pi)= -1, por lo que q(i, T/2)=qMin(i) + 2*amplitud = qMax(i).
    q(i,:) = robot.qMin(i) + amplitud/2 * (1 - cos(w * t));
    
    % Derivada temporal de q: velocidad articular
    % d/dt[1 - cos(w*t)] = w*sin(w*t)
    dq(i,:) = amplitud/2 * w * sin(w * t);
    
    % Derivada temporal de dq: aceleración articular
    % d/dt[w*sin(w*t)] = w^2*cos(w*t)
    ddq(i,:) = amplitud/2 * w^2 * cos(w * t);
end
end
