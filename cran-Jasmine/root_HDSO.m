function [saida, tempo_execucao, Micros_HDSO, UE] = root_HDSO(Usuarios, SmallCells, MacroCells, UE)

% -------------------------------------------------------------------------
% Parte III --> Criação do Cenário para etapa de otimização
% -------------------------------------------------------------------------

[U, Small, Macro, ~] = StartScenario(Usuarios, SmallCells, MacroCells); % Usuários, SmallCells e MacroCells


b = length(U);
for j = 1:24
    tic
    a = 1;
    for k = 1:b
        if (UE(k).M == j)
            User(a) = UE(k);
            a = a + 1;
        end
    end
    
    % Conexão Usuário/Small
    [Us1, S1] = ConexaoUs(User, Small); % Usuários e Small
    [M1] = Media(Us1); % M = [DataRate SINR > DR <DR UD]
    [V21] = Media_M(S1, Us1); %S1 - SmallCells com nº(S1.U) e indices(S1.VU) de usuarios conectados
    [ON, OFF(j,:)] = HDSO_algorithm(Macro, S1,Us1,V21);
    SM(j) = ON; % Quantidade de micros que devem ser ligadas
    %OFF(j,:) - indica quais micros devem ser desligadas
    fprintf('Implementando FU para a hora #%d!\n', j);
    
    [saida(j,:), Micros_HDSO(j,:)] = Seleciona_RRH_HDSO(User, OFF(j,:), Macro, Small);
    
    
    
    %[Su(j,:), Sv(j,:)] = MaximoA(V21, SM);
    %SM(2X5)-Maximos de SCs conectadas(em determinada hora) por percentuais
    %                0.2     0.4     0.6     0.8     1
    %   | Usuario -
    %   | Vazao   -                                   |
    
    %Sn(24x4).5
    %Sn(hora, matriz com caracteristicas das smallcells).percentual
    clear User;
    tempo_execucao(j) = toc;  % Tempo de execução para cada hora
end


end

