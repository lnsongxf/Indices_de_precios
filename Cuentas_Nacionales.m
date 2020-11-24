function [Y,y,g,P,pi,alpha,IPC,pi_IPC] = Cuentas_Nacionales(X,b)
%--------------------------------------------------------------------------
% Proposito:  Esta funcion calcula el PIB y deflactor del PIB por la suma
%             del valor de los bienes. 
%--------------------------------------------------------------------------
% Inputs   :  X : Nx2T Matriz con los datos, en las filas estan los
%                      bienes, en las ccolumnas estan de forma consecutiva
%                      las cantidades y precios para cada periodo de tiempo
%             b : 1x1  periodo selecionado como base.
%--------------------------------------------------------------------------
% Output   :  y     : Tx1   El PIB real con periodo base b.
%             Y     : Tx1   El PIB nominal
%             P     : Tx1   El deflactor del PIB
%             g     : T-1x1 Tasa de crecimiento del PIB real
%             pi    : T-1x1 Inflacion medida por el deflactor del PIB
%             alpha : Nx1   Ponderadores usados en el IPC con base en b
%             IPC   : Tx1   Indice de Precios al Consumidos
%             pi_IPC: T-1x1 Inflacion con base en el IPC
%--------------------------------------------------------------------------

% Numero de bienes 
N = size(X,1);

% Matrices con Cantidades y Precios 
q = X(:,1:2:end)
p = X(:,2:2:end)

% periodos de  tiempo
T = size(p,2);

%% PIB Nominal 
Y = NaN(T,1);

for i=1:T
    Y(i,1) =  p(:,i)'*q(:,i);
end 

%% PIB real con año base b

y = NaN(T,1);
for i=1:T
    y(i,1) = p(:,b)'*q(:,i);
end 

%% Deflactor del PIB

P = Y./y;

%% Indice de Precios al Consumidor

alpha = NaN(N,1);

for i=1:N
    alpha(i,1) = (p(i,b)*q(i,b) )/( p(:,b)'*q(:,b)  );
end 


IPC = NaN(T,1);

for i=1:T
    IPC(i,1) = alpha'*( p(:,i)./p(:,b) );
end 


%% Tasas de crecimiento e infacion

g      = NaN(T-1,1);
pi     = NaN(T-1,1);
pi_IPC =  NaN(T-1,1);
for i=1:T-1
    g(i,1)      = ((y(i+1,1)-y(i,1))/y(i,1))*100;
    pi(i,1)     = ((P(i+1,1)-P(i,1))/P(i,1))*100;
    pi_IPC(i,1) = ((IPC(i+1,1)-IPC(i,1))/IPC(i,1))*100;
end 
    

end 


