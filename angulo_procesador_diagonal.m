function [ PD ] = angulo_procesador_diagonal( PD )
% Funci�n que devuelve el �ngulo en radianes correspondiente a la rotaci�n
% del procesador diagonal (PD(i)).

PD.angulo = 0.5*atan((2*PD.M(1,2))/(PD.M(2,2)-PD.M(1,1)));

end

