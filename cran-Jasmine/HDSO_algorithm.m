function [ON, OFF] = HDSO_algorithm(Macro2, S2,Us2, V21) %HSI)
    S = length(S2);
    TS = length(S2);
    OFF = [];  % conjunto de micros que devem ser desligadas
    j = 1;
    ON=S; % Número de micros ligadas
   

   while S ~= 0
        UV = Funcao_Util_HDSO(S2, V21);
        UV = sortrows(UV, -5); % Ordenando pelo valor da função util de cada Small
        Ind = UV(S,1); %Índice da Small com menor valor da FU
        Total_Usuarios = S2(Ind).U;
        Id_usr = S2(Ind).VU; % Usuários da Small
        Int = S2(Ind).Int; 

        countM = 0; % Nº de usuários transferidos para a Macro
        count = 0; % Nº de usuários transferidos para as Smalls
        S2(Ind).D = 0; % Desligando a Small
        S2(Ind).VU = [];
        S2(Ind).U = 0;
        S2(Ind).PRB_F = S2(Ind).PRB;
        S2(Ind).UB = 0;
        

        if Total_Usuarios == 0
            OFF(j) = S2(Ind).ID; %Adiciona a Small no conjunto de small que devem ser desligadas
            j= j+1;
            ON = ON-1;
        else
            for i=1:Total_Usuarios %percorre os usuários da small
                [ usr_nao_transferido(i), usr_transferidosM, Macro2, Us2] = Tranferencia_de_UsrM(Us2, Macro2, Id_usr(i));
                countM = usr_transferidosM + countM; 
            end % Tentativa de transferir os usuários da Small para a Macro

            if countM ~= Total_Usuarios
                T = length(usr_nao_transferido);
                for i=1:T
                  UsrN = usr_nao_transferido(i);
                  if UsrN ~= 0
                    [~, usr_transferidos, S2, Us2] = Tranferencia_de_Usr(Us2, S2, UsrN);
                    count = usr_transferidos + count;
                  end % Tentativa de transferir os usuários da Small para outras Smalls
                end
            end

            if (count + countM) ~= Total_Usuarios %Se não foi possível tranferir todos usuarios da Small
                S2(Ind).D = 1; % Ligando a Small
                for i=1:Total_Usuarios
                   [S2, Macro2, Us2, usr_totais] = Manter_Ligada(Us2, Macro2, S2, Id_usr(i), Ind);
                end
                S2(Ind).Int = Int;
            else % Caso todos os usuários tenham sido transferidos:
                S2(Ind).Int = 0;
                OFF(j) = S2(Ind).ID; %Adiciona a Small no conjunto de small que devem ser desligadas
                j=j+1;
                ON = ON -1;
            end

        end

        S = S - 1;
        UV(:,:) = [];
        [V21] = Media_M(S2, Us2);

    end

 C = length(OFF);
 if C ~= TS
     for i=C:(TS -1)
        OFF(i+1)= 0;
     end 
 end % para que OFF tenha o mesmo comprimento para todas as horas
 
    
end

