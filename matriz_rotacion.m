function [ R ] = matriz_rotacion( angulo )
% Devuelve una matriz de rotaci�n de 2x2 

R = [cos(angulo) sin(angulo); -sin(angulo) cos(angulo)];

end

