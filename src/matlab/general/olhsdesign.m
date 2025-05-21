function X = olhsdesign(p,N)
% OLHSDESIGN_MEX Genera un diseño de hipercubo latino ortogonal.
%
%   X = olhsdesign_mex(N, p) genera una matriz X de tamaño (N x p), donde
%   cada fila es una muestra de un diseño de hipercubo latino ortogonal.
%
%   Se requiere que N sea un cuadrado perfecto, ya que se utiliza s = sqrt(N)
%   para dividir uniformemente el intervalo [0,1] en cada dimensión.
%
%   Ejemplo:
%       X = olhsdesign_mex(16, 3);
%   Esto genera 16 muestras en un espacio de 3 dimensiones, distribuidas de forma ortogonal.
%
%   Referencias:
%   Para más información sobre Orthogonal Latin Hypercube Designs, pueden consultar:
%       "Orthogonal Array-Based Latin Hypercube Sampling" en la literatura de diseño de experimentos.

s = sqrt(N);
if mod(s, 1) ~= 0
    error('N debe ser un cuadrado perfecto.');
end

% Inicializar la matriz de salida (p dimensiones, N muestras)
X = zeros(p, N);

% Para cada dimensión j:
for i = 1:p
    % Se dividen [0,1] en s intervalos. Los centros de estos intervalos son:
    centers = ((1:s) - 0.5) / s;
    % Replicar cada centro s veces (para obtener N = s*s valores)
    col = repmat(centers, 1, s);
    % Aplicar una permutación aleatoria a la columna
    X(i,:) = col(randperm(N));
end
end
