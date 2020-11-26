function [y_cal,pi_fisher] = PIB_encadenado(X)
%--------------------------------------------------------------------------
% Proposito:  Esta funcion calcula el PIB y deflactor del PIB por la suma
%             del valor de los bienes, a precios encadenados del periodo
%             anterior
%--------------------------------------------------------------------------
% Inputs   :  X : Nx2T Matriz con los datos, en las filas estan los
%                      bienes, en las ccolumnas estan de forma consecutiva
%                      las cantidades y precios para cada periodo de tiempo
%--------------------------------------------------------------------------
% Output   :  y_cal     : Tx1   El PIB a precios encadenados.
%             pi_fisher : T-1x1 Inflacion con base en el deflactor (Indice de Fisher)
%--------------------------------------------------------------------------

% Numero de bienes 
N = size(X,1);

% Matrices con Cantidades y Precios 
q = X(:,1:2:end)
p = X(:,2:2:end)

% periodos de  tiempo
T = size(p,2);

%% PIB a precios encadenados.

PIB = NaN(T,T);
for i=1:T
    [Y, PIB(:,i) ] = Cuentas_Nacionales(X,i);
end


% calculo de tasas de crecimiento con promedio geometrico 
lambda      = NaN(T,1);
lambda(1,1) = 1;

for i=1:T-1
    lambda(i+1,1) = [( PIB(i+1,i)/PIB(i,i) )*( PIB(i+1,i+1)/PIB(i,i+1) )]^(1/2)-1
end 

y_cal       = NaN(T,1);
y_cal(1,1)  = PIB(1,1);
for i=1:T-1
    y_cal(i+1,1) = (1+lambda(i+1) )* y_cal(i,1);
end 


%% Deflactor del PIB usando precios encadenados (Indice de fisher)

P = Y./y_cal;

pi_fisher = NaN(T-1,1);
for i=1:T-1
    pi_fisher(i,1) = ( (P(i+1,1)-P(i,1))/P(i,1)  )*100;
end 


