%% Lo primero que necesitamos es una matriz diagonal y cuadrada,
% se va a realizar el cálculo para una matriz de 4x4 elementos luego
% tendremos M/2 procesadores siendo M = 4.
% Habrá dos procesadores diagonales y dos no diagonales.
clc;clear;
M = 4;
h = ceil(M*log(M));

% Matriz de inicio:

aux = magic(4);
Si = triu(aux) + triu(aux,1)';

PD(1).M = [Si(1,1) Si(1,2); Si(2,1) Si(2,2)];
PD(2).M = [Si(3,3) Si(3,4); Si(4,3) Si(4,4)];

PND(1).M = [Si(1,3) Si(1,4); Si(2,3) Si(2,4)];
PND(2).M = [Si(3,1) Si(3,2); Si(4,1) Si(4,2)];



for i = 1:h
    
%Ahora los procesadores diagonales tienen que calcular sus ángulos
PD(1).angulo = 0;PD(2).angulo = 0;

PD(1) = angulo_procesador_diagonal(PD(1));
PD(2) = angulo_procesador_diagonal(PD(2));


% El ángulo de cada procesador diagonal se propaga a los procesadores
% no diagonales que se encuentan en su misma fila y columna.

PND(1).angulo_fila = PD(1).angulo;
PND(1).angulo_columna = PD(2).angulo;

PND(2).angulo_fila = PD(2).angulo;
PND(2).angulo_columna = PD(1).angulo;

% Conocidos los dos ángulos, se calculan las matrices de rotación
% correspondientes a cada uno.

PD(1).R = matriz_rotacion(PD(1).angulo);
PD(2).R = matriz_rotacion(PD(2).angulo);

PND(1).Rii = matriz_rotacion(PND(1).angulo_fila);
PND(1).Rjj = matriz_rotacion(PND(1).angulo_columna);

PND(2).Rii = matriz_rotacion(PND(2).angulo_fila);
PND(2).Rjj = matriz_rotacion(PND(2).angulo_columna);

% Y calculadas las matrices de rotación, se realizan las dobles
% multiplicaciones.

PD(1).M = PD(1).R' * PD(1).M * PD(1).R;
PD(2).M = PD(2).R' * PD(2).M * PD(2).R;

PND(1).M = PND(1).Rii' * PND(1).M * PND(1).Rjj;
PND(2).M = PND(2).Rii' * PND(2).M * PND(2).Rjj;

aux = [PD(1).M PND(1).M; PND(2).M PD(2).M];

S(:,:,i) = [aux(1,1) aux(1,4) aux(1,2) aux(1,3);
            aux(4,1) aux(4,4) aux(4,2) aux(4,3);
            aux(2,1) aux(2,4) aux(2,2) aux(2,3);
            aux(3,1) aux(3,4) aux(3,2) aux(3,3)];
        
PD(1).M = [S(1,1,i) S(1,2,i); S(2,1,i) S(2,2,i)];
PD(2).M = [S(3,3,i) S(3,4,i); S(4,3,i) S(4,4,i)];

PND(1).M = [S(1,3,i) S(1,4,i); S(2,3,i) S(2,4,i)];
PND(2).M = [S(3,1,i) S(3,2,i); S(4,1,i) S(4,2,i)];
        
end


