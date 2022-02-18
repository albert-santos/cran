function [V2] = Media_M_copia (S, U)

TS = length(S);
TU = length(U);
A = 1; B = 1;


for i = 1:TS
    DM = 0;
    T = S(i).U;
    
    for j = 1:T
       
        V1(A,1) = i; % ID da Small
        X = S(i).VU(j);  
        V1(A,2) = U(X).DR; % Taxa de dada de cada usuário
        DM = DM + V1(A,2);
        A = A + 1;
    end
    
    if length(T) == 0
        T = 0;
    end
        
    V2(B,1) = i;
    V2(B,2) = S(i).ID;
    V2(B,3) = T; % Total de usuários conectados a Small.
    V2(B,4) = DM; % Total de Taxa que a Small serve.
    B = B + 1;    
end









end

