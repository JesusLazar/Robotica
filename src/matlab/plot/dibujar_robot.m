function g = dibujar_robot(g, r, view_vector, escala_ejes, rango_x, rango_y, rango_z)
% NCGR_PLOT Grafica el robot y actualiza la estructura gráfica.
%
%   g = ncgr_plot(g, r, view_vector, escala_ejes, rango_x, rango_y, rango_z)
%   dibuja el robot usando la estructura 'r' y actualiza la gráfica con:
%       - El vector de vista (1x3) [opcional].
%       - La escala para las flechas de los ejes (opcional).
%       - Los límites de los ejes X, Y y Z (opcional).
%
%   Entradas:
%       g           - Estructura gráfica (creada con ncgr_graphic).
%       r           - Estructura del robot, con campos:
%                       .base : [3x1] vector que define la posición base.
%                       .T    : [4x4xNGDL] matriz de transformación homogénea de cada junta.
%                       .NGDL : Número de eslabones/juntas (por ejemplo, 4).
%                       .d, .a: parámetros para calcular el alcance.
%       view_vector - Vector de vista (1x3), por ejemplo, [1 1 1] (opcional).
%       escala_ejes - Escala para las flechas de los ejes (opcional, por defecto 0.5).
%       rango_x     - Límites del eje X (1x2), por ejemplo, [xmin xmax] (opcional).
%       rango_y     - Límites del eje Y (1x2) (opcional).
%       rango_z     - Límites del eje Z (1x2) (opcional).
%
%   Salida:
%       g - Estructura gráfica actualizada.
%
%   La función configura la figura (si es la primera vez) y actualiza:
%       - La línea que conecta la base con el origen de cada junta.
%       - Las flechas que representan los ejes X, Y y Z de cada marco.
%       - Las etiquetas de cada marco.

% Se usa el número de juntas definido en r.NGDL
N_DOFS = r.NGDL;

% Definir un alcance máximo para ajustar los límites de la gráfica.
% Se utiliza la suma de los valores absolutos de r.d y r.a para estimar el alcance.
max_reach = 1.1 * max(sum(abs(r.d)), sum(abs(r.a)));
base = r.A0(1:3,4);

if (g.h == -1)  % Solo se configura la figura una vez
    figure;
    hold on;
    grid on;
    axis equal;
    
    % Si no se proporcionan argumentos opcionales, se usan los valores por defecto.
    if nargin < 3 || isempty(view_vector)
        view_vector = [1 1 1];
    end
    if nargin < 4 || isempty(escala_ejes)
        escala_ejes = 0.5;
    end
    if nargin < 5 || isempty(rango_x)
        rango_x = [base(1)-max_reach, base(1)+max_reach];
    end
    if nargin < 6 || isempty(rango_y)
        rango_y = [base(2)-max_reach, base(2)+max_reach];
    end
    if nargin < 7 || isempty(rango_z)
        rango_z = [base(3)-max_reach, base(3)+max_reach];
    end
    
    % Establecer límites de la gráfica
    xlim(rango_x);
    ylim(rango_y);
    zlim(rango_z);
    
    % Configurar la vista
    view(view_vector);
    
    % Dibujar la línea principal (inicialmente vacía) que conectará los orígenes
    g.h = plot3(0, 0, 0, '-m*', 'LineWidth', 4);
    
    % Crear los objetos gráficos para las flechas de los ejes
    g.quiver_x = quiver3(0, 0, 0, 0, 0, 0, escala_ejes, 'r');
    g.quiver_y = quiver3(0, 0, 0, 0, 0, 0, escala_ejes, 'g');
    g.quiver_z = quiver3(0, 0, 0, 0, 0, 0, escala_ejes, 'b');
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    % Crear etiquetas para la base y cada junta (de 0 a N_DOFS)
    for i = 0 : N_DOFS
        g.htxt(i+1) = text(0, 0, 0, num2str(i), 'FontWeight', 'bold');
    end
    
    % Posicionar la etiqueta de la base en base
    set(g.htxt(1), 'Position', base);
end

% Inicializar matrices para almacenar los orígenes y direcciones de los ejes en cada junta
vx = zeros(3, N_DOFS);
vy = zeros(3, N_DOFS);
vz = zeros(3, N_DOFS);
x  = zeros(3, N_DOFS);

% Para cada junta, extraer la posición y orientación a partir de r.T
for i = 1 : N_DOFS
    % vx, vy, vz: direcciones de los ejes X, Y y Z del marco i
    vx(:, i) = r.T(1:3, 1:3, i) * [1; 0; 0];
    vy(:, i) = r.T(1:3, 1:3, i) * [0; 1; 0];
    vz(:, i) = r.T(1:3, 1:3, i) * [0; 0; 1];
    
    % x: origen del marco i (extraído de la columna 4)
    x(:, i)  = r.T(1:3, 4, i);
    
    % Posicionar la etiqueta del marco i (se desplaza ligeramente en Z para claridad)
    set(g.htxt(i+1), 'Position', x(:, i) + [0; 0; 0.2]);
end

% Actualizar la línea principal: conectar la base (base) con los orígenes de cada junta.
set(g.h, 'XData', [base(1) x(1, :)], 'YData', [base(2) x(2, :)], 'ZData', [base(3) x(3, :)]);

% Actualizar las flechas para cada eje en cada marco:
set(g.quiver_x, 'XData', x(1, :), 'YData', x(2, :), 'ZData', x(3, :), ...
    'UData', vx(1, :), 'VData', vx(2, :), 'WData', vx(3, :));
set(g.quiver_y, 'XData', x(1, :), 'YData', x(2, :), 'ZData', x(3, :), ...
    'UData', vy(1, :), 'VData', vy(2, :), 'WData', vy(3, :));
set(g.quiver_z, 'XData', x(1, :), 'YData', x(2, :), 'ZData', x(3, :), ...
    'UData', vz(1, :), 'VData', vz(2, :), 'WData', vz(3, :));

drawnow;

end
