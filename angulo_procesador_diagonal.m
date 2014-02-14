function [ PD ] = angulo_procesador_diagonal( PD )
% Función que devuelve el ángulo en radianes correspondiente a la rotación
% del procesador diagonal (PD(i)).

PD.angulo = 0.5*atan((2*PD.M(1,2))/(PD.M(2,2)-PD.M(1,1)));

end

