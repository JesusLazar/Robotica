function plotRobot(A, A0, offset, tipo, frame_scale, viewAngle)
% plotRobot Visualiza un robot a partir de matrices locales de transformación A,
% considerando una transformación base A0.
%
%   plotRobot(A, A0, offset, tipo) utiliza A, un array 4x4xn en el que cada A(:,:,i)
%   contiene una única variable simbólica correspondiente a la articulación i, y se espera:
%       - Si tipo(i)=='r', la variable simbólica se llame "theta_i"
%       - Si tipo(i)=='p', la variable se llame "d_i"
%   A0 es la matriz de transformación homogénea inicial (posición y orientación base).
%   offset es un vector (n×1) con el valor numérico que se sustituirá en la variable de A(:,:,i).
%   tipo es un vector (o array de char) de tamaño n con 'r' o 'p' según el tipo de junta.
%
%   plotRobot(..., frame_scale) permite especificar la escala de las flechas de los
%   ejes (por defecto frame_scale = 0.1).
%
%   plotRobot(..., viewAngle) permite ajustar la vista (por defecto viewAngle = 3, 
%   vista 3D). viewAngle puede ser un vector [az, el] o un escalar.
%
%   La función realiza lo siguiente:
%     1. Sustituye en cada A(:,:,i) la variable simbólica correspondiente (según tipo) por
%        el valor de offset(i).
%     2. Calcula la transformación global T recursivamente, iniciando en A0:
%            T(:,:,1) = A0 * A_sub(:,:,1)
%            T(:,:,i) = T(:,:,i-1) * A_sub(:,:,i)
%     3. Grafica el sistema base y cada sistema de referencia con sus ejes (X en rojo, Y en verde, Z en azul)
%        y etiqueta cada origen con el número del sistema de referencia.

    % Valores por defecto
    if nargin < 5 || isempty(frame_scale)
        frame_scale = 0.1;
    end
    if nargin < 6 || isempty(viewAngle)
        viewAngle = 3; % Vista 3D por defecto
    end

    % Verificar dimensiones: A es 4x4xn, offset y tipo deben tener n elementos.
    n = size(A, 3);
    if numel(offset) ~= n
        error('El tamaño de offset (%d) no coincide con el número de eslabones (%d).', numel(offset), n);
    end
    if numel(tipo) ~= n
        error('El tamaño de tipo (%d) no coincide con el número de eslabones (%d).', numel(tipo), n);
    end

    % Sustituir en cada A la variable simbólica correspondiente
    A_sub = zeros(4,4,n);
    for i = 1:n
        if isa(A(:,:,i), 'sym')
            if tipo(i) == 'r'
                expectedVar = sym(sprintf('theta_%d', i));
            elseif tipo(i) == 'p'
                expectedVar = sym(sprintf('d_%d', i));
            else
                error('Tipo no reconocido en el eslabón %d. Debe ser ''r'' o ''p''.', i);
            end
            A_sub(:,:,i) = subs(A(:,:,i), expectedVar, offset(i));
        else
            A_sub(:,:,i) = A(:,:,i);
        end
    end

    % Calcular la transformación global T a partir de A_sub iniciando en A0
    T = zeros(4,4,n);
    T(:,:,1) = double(A0 * A_sub(:,:,1));
    for i = 2:n
        T(:,:,i) = T(:,:,i-1) * double(A_sub(:,:,i));
    end

    % Configurar la figura
    figure;
    hold on;
    grid on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Visualización del Robot y sus Sistemas de Referencia (usando A y A0)');
    
    % Dibujar el sistema de referencia base usando A0
    X0 = A0;
    origin0 = X0(1:3,4);
    x_axis0 = X0(1:3,1);
    y_axis0 = X0(1:3,2);
    z_axis0 = X0(1:3,3);
    quiver3(origin0(1), origin0(2), origin0(3), frame_scale*x_axis0(1), frame_scale*x_axis0(2), frame_scale*x_axis0(3), 'r', 'LineWidth', 2);
    quiver3(origin0(1), origin0(2), origin0(3), frame_scale*y_axis0(1), frame_scale*y_axis0(2), frame_scale*y_axis0(3), 'g', 'LineWidth', 2);
    quiver3(origin0(1), origin0(2), origin0(3), frame_scale*z_axis0(1), frame_scale*z_axis0(2), frame_scale*z_axis0(3), 'b', 'LineWidth', 2);
    text(origin0(1), origin0(2), origin0(3), '0', 'FontSize', 12, 'Color', 'k', 'FontWeight', 'bold');
    
    origins = zeros(3, n);
    % Graficar cada sistema de referencia obtenido de T
    for i = 1:n
        X_i = T(:,:,i);
        origin = X_i(1:3, 4);
        origins(:, i) = origin;
        x_axis = X_i(1:3, 1);
        y_axis = X_i(1:3, 2);
        z_axis = X_i(1:3, 3);
        
        quiver3(origin(1), origin(2), origin(3), frame_scale*x_axis(1), frame_scale*x_axis(2), frame_scale*x_axis(3), 'r', 'LineWidth', 2);
        quiver3(origin(1), origin(2), origin(3), frame_scale*y_axis(1), frame_scale*y_axis(2), frame_scale*y_axis(3), 'g', 'LineWidth', 2);
        quiver3(origin(1), origin(2), origin(3), frame_scale*z_axis(1), frame_scale*z_axis(2), frame_scale*z_axis(3), 'b', 'LineWidth', 2);
        
        % Etiquetar cada sistema solo con su número
        label = sprintf('%d', i);
        text(origin(1), origin(2), origin(3), ['  ' label], 'FontSize', 12, 'Color', 'k', 'FontWeight', 'bold');
    end

    % Conectar la base y los orígenes de cada articulación
    base_origin = origin0; % La base es la transformación A0
    all_origins = [base_origin origins];
    plot3(all_origins(1,:), all_origins(2,:), all_origins(3,:), 'k-', 'LineWidth', 2);
    
    % Ajustar la vista
    view(viewAngle);
    hold off;
end