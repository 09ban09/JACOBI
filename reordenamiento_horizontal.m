function [ M ] = reordenamiento_horizontal( M )
%

M_temp = M;

M = [M_temp(1,2) M_temp(1,1);
     M_temp(2,2) M_temp(2,1)];

end

