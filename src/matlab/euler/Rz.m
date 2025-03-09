function R = Rz(psi)
% Rz realiza una rotación en un ángulo theta en radianes con respecto al eje Z.
R = [cos(psi), -sin(psi), 0;
     sin(psi), cos(psi), 0;
     0, 0, 1];
end