function [M] = Media_copia(U)

    T = length(U);
    
    DR = 0; % Media de DataRate
    SINR = 0; % Media de SINR
    D(1) = U(1).DR; % Maior DR
    D(2) = U(1).DR; % Menor DR
    
    
    for i = 1:T % Somatorio dos DR e SINR de todos usuários
        
        DR = DR + U(i).DR; % Recebe o DR de cada usuário
        SINR = SINR + U(i).SINR; % Recebe o SINR de cada usuário
        
        if (U(i).DR > D(1))
            D(1) = U(i).DR; % Guarda o maior DR
        end
        if (U(i).DR < D(2))
            D(2) = U(i).DR; % Guarda o menor DR
        end
        
    
    end

       DR = DR/T; % Media do DR dos Usuários
       SINR = SINR/T; % Media do SINR dos Usuários
       
       M = [DR SINR D(1) D(2)];


end

