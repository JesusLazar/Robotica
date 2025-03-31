function g = crear_grafica_robot()
% NCGR_GRAPHIC Crea la estructura gráfica para la visualización del robot.
%
%   g = ncgr_graphic() inicializa la estructura 'g' que se usará para almacenar
%   los handles de los objetos gráficos (línea de conexión y flechas de los ejes)
%   que se actualizarán durante la animación.
%
%   Salida:
%       g - estructura gráfica con los campos:
%            .h         : handle de la línea que conecta los orígenes.
%            .quiver_x  : handle para la flecha del eje X.
%            .quiver_y  : handle para la flecha del eje Y.
%            .quiver_z  : handle para la flecha del eje Z.
%            .htxt      : vector de handles para las etiquetas de cada marco.

    g.h = -1;
    g.quiver_x = -1;
    g.quiver_y = -1;
    g.quiver_z = -1;
    % El vector de textos (g.htxt) se crea en ncgr_plot.
end
