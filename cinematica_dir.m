function [pos,v_l,a_l,ori,v_r,a_r] = cinematica_dir(robot,q,dq,ddq,t,secuencia)
% CINEMATICA_DIR Calcula la cinemática directa y diferencial del efector final.
%
%   Calcula la posición, orientación (ángulos de Euler), velocidad lineal,
%   velocidad angular, aceleración lineal y aceleración angular del
%   efector final del robot a lo largo de una trayectoria temporal.
%
%   Entradas:
%       robot      - Estructura del robot (con NGDL, etc., y funciones aux.)
%       q          - Matriz de posiciones articulares (NGDL x M)
%       dq         - Matriz de velocidades articulares (NGDL x M)
%       ddq        - Matriz de aceleraciones articulares (NGDL x M)
%       t          - Vector de tiempo (1 x M)
%       secuencia  - String con la secuencia de ángulos de Euler (ej. 'ZYX')
%
%   Salidas:
%       pos        - Posición cartesiana (3 x M)
%       v_l        - Velocidad lineal (3 x M)
%       a_l        - Aceleración lineal (3 x M)
%       ori        - Orientación en ángulos de Euler (3 x M)
%       v_r        - Velocidad angular (3 x M)
%       a_r        - Aceleración angular (3 x M)