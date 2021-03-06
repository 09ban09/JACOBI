%% Lo primero que necesitamos es una matriz diagonal y cuadrada,
% se va a realizar el c�lculo para una matriz de 4x4 elementos luego
% tendremos M/2 procesadores siendo M = 4.
% Habr� dos procesadores diagonales y dos no diagonales.
clc;clear;
M = 4;
h = ceil(M*log(M));

% Matriz de inicio, diagonal y real:

aux = rand(4);
Si = triu(aux) + triu(aux,1)';

PD(1).M = [Si(1,1) Si(1,2); Si(2,1) Si(2,2)];
PD(2).M = [Si(3,3) Si(3,4); Si(4,3) Si(4,4)];

PND(1).M = [Si(1,3) Si(1,4); Si(2,3) Si(2,4)];
PND(2).M = [Si(3,1) Si(3,2); Si(4,1) Si(4,2)];

for i = 1:h
    
%Ahora los procesadores diagonales tienen que calcular sus �ngulos
PD(1).angulo = 0;PD(2).angulo = 0;

PD(1) = angulo_procesador_diagonal(PD(1));
PD(2) = angulo_procesador_diagonal(PD(2));


% El �ngulo de cada procesador diagonal se propaga a los procesadores
% no diagonales que se encuentan en su misma fila y columna.

PND(1).angulo_fila = PD(1).angulo;
PND(1).angulo_columna = PD(2).angulo;

PND(2).angulo_fila = PD(2).angulo;
PND(2).angulo_columna = PD(1).angulo;

% Conocidos los dos �ngulos, se calculan las matrices de rotaci�n
% correspondientes a cada uno.

PD(1).R = matriz_rotacion(PD(1).angulo);
PD(2).R = matriz_rotacion(PD(2).angulo);

PND(1).Rii = matriz_rotacion(PND(1).angulo_fila);
PND(1).Rjj = matriz_rotacion(PND(1).angulo_columna);

PND(2).Rii = matriz_rotacion(PND(2).angulo_fila);
PND(2).Rjj = matriz_rotacion(PND(2).angulo_columna);

% Y calculadas las matrices de rotaci�n, se realizan las dobles
% multiplicaciones.

PD(1).M = PD(1).R' * PD(1).M * PD(1).R;
PD(2).M = PD(2).R' * PD(2).M * PD(2).R;

PND(1).M = PND(1).Rii' * PND(1).M * PND(1).Rjj;
PND(2).M = PND(2).Rii' * PND(2).M * PND(2).Rjj;

% Ahora hay que reordenar los t�rminos internamente (dentro de
% cada procesador), y externamente (intercambi�ndo datos entre
% procesadores), para preparar la siguiente iteraci�n.

% El procesador P(1,1) situado en la esquina superior izquierda
% no tiene que reordenar sus datos.

% El resto de procesadores de la primera fila (en este caso el P(1,2),
% tienen que intercambiar sus datos horizontalmente.

PND(1).M = reordenamiento_horizontal(PND(1).M);
       
% El resto de procesadores de la primera columna (en este caso el P(2,1),
% tienen que intercambiar sus datos horizontalmente.

PND(2).M = reordenamiento_vertical(PND(2).M);
       
% Los procesadores que quedan (en este caso el P(2,2) intercambian sus
% datos diagonalmente.

PD(2).M = reordenamiento_diagonal(PD(2).M);

% Una vez reordenados los datos internamente, hay que realizar un 
% intercambio de datos con los procesadores vecinos.


% Primero se actualiza la copia de los datos de cada procesador.


    PD(1).M_temp = PD(1).M;
    PD(2).M_temp = PD(2).M;
    PND(1).M_temp = PND(1).M;
    PND(2).M_temp = PND(2).M;


% El procesador de la esquina superior izquierda recibe los elementos (11)
% de sus vecinos.

PD(1).M = [PD(1).M_temp(1,1)  PND(1).M_temp(1,1);
           PND(2).M_temp(1,1) PD(2).M_temp(1,1)];
       
% El procesador de la esquina superior derecha recibe los elementos (12) de
% sus vecinos.

PND(1).M = [PD(1).M_temp(1,2)  PND(1).M_temp(1,2);
            PND(2).M_temp(1,2) PD(2).M_temp(1,2)];
        
      
% El procesador de la esquina inferior izquierda recibe los elementos (21)
% de sus vecinos.

PND(2).M = [PD(1).M_temp(2,1)  PND(1).M_temp(2,1);
            PND(2).M_temp(2,1) PD(2).M_temp(2,1)];
   
        
% El procesador de la esquina inferior derecha, recibe los elementos 22 de 
% sus vecinos.

PD(2).M = [PD(1).M_temp(2,2)  PND(1).M_temp(2,2);
           PND(2).M_temp(2,2) PD(2).M_temp(2,2)];
 
% Ahora el sistema est� listo para realizar la siguiente iteraci�n.

end

% Finalmente, se recompone la matriz.

D = [PD(1).M PND(1).M;
     PD(2).M PND(2).M];
 
 %autovalores_jacobi = diag(D)
 [~, D_real] = svd(Si)
 
 D_jacobi = [PD(1).M PND(1).M; PND(2).M PD(2).M]


