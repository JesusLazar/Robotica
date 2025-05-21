function robot = crear_robot(dh,A0)
% CREAR_ROBOT Crea la estructura del robot a partir de la tabla DH y la transformación homogénea inicial A0.
% NO DEBEN MODIFICAR ESTE CÓDIGO
%
% Inputs:
%   dh  - Tabla de parámetros DH (con campos: theta, d, a, alpha, min, max, tipo)
%   A0  - Matriz 4x4 de transformación homogénea inicial (del sistema base)
%
% Output:
%   robot - Estructura del robot con los parámetros y campos necesarios.
%
% Ejemplo de uso:
%   dh = readtable('datos\tabla_DH\robot1.csv');
%   A0 = [eye(3)     zeros(3,1)
%         zeros(1,3) 1];
%   robot = crear_robot(dh, A0);

% Convertir las columnas numéricas a double
theta = deg2rad(dh.theta);
d     = dh.d;
a     = dh.a;
alpha = deg2rad(dh.alpha);

% Convertir la columna de tipo a char (se asume 'r' para revoluta y 'p' para prismática)
tipo = char(dh.tipo);

NGDL = size(dh,1);  % Número de eslabones/juntas

% Preasignar vectores para los límites de articulación
qMin = zeros(NGDL,1);
qMax = qMin;
dqMax = qMin;
ddqMax = qMin;
q = qMin;
for i = 1:NGDL
    switch tipo(i)
        case 'r'    % Para juntas revolutas: se convierten los valores a radianes
            qMin(i) = deg2rad(dh.min(i));
            qMax(i) = deg2rad(dh.max(i));
            dqMax(i) = deg2rad(dh.dqmax(i));
            ddqMax(i) = deg2rad(dh.ddqmax(i));
            q(i) = theta(i);
        case 'p'    % Para juntas prismáticas: se mantienen en unidades lineales
            qMin(i) = dh.min(i);
            qMax(i) = dh.max(i);
            dqMax(i) = dh.dqmax(i);
            ddqMax(i) = dh.ddqmax(i);
            q(i) = d(i);
        otherwise
            error("Debes usar 'r' para una articulación de revoluta" + ...
              " y 'p' para una articulación prismática.")
    end
end

robot = struct( ...
        'theta', theta, ...       (nx1) Rotaciones en Z
        'd', d, ...               (nx1) Traslaciones en Z
        'a', a, ...               (nx1) Traslaciones en X
        'alpha', alpha, ...       (nx1) Rotaciones en X
        'qMin', qMin, ...         (nx1) Límite inferior de articulación
        'qMax', qMax, ...         (nx1) Límite superior de articulación
        'dqMax', dqMax, ...       (nx1) Velocidad máxima de articulación
        'ddqMax', ddqMax, ...     (nx1) Aceleración máxima de articulación
        'NGDL', NGDL, ...         (1) Número de eslabones/juntas
        'tipo', tipo, ...         (nx1) Tipo de articulación, 'p' para prismátyica y 'r' para revoluta
        'A0', A0, ...             (4x4) Matriz de transformación homogenea inicial
        'T', zeros(4,4,NGDL), ...(4x4xn) Matriz de transformación homogenea de cada paso
        'q', q);
        
