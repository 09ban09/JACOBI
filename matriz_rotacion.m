function [ R ] = matriz_rotacion( angulo )
% Devuelve una matriz de rotación de 2x2 

R = [cos(angulo) sin(angulo); -sin(angulo) cos(angulo)];

end

