function [saida, tempo_execucao, Micros, U] = root(Usuarios, SmallCells, MacroCells)

% -------------------------------------------------------------------------
% Parte III --> Criação do Cenário para etapa de otimização
% -------------------------------------------------------------------------

[U, Small, Macro, ~] = StartScenario(Usuarios, SmallCells, MacroCells); % Usuários, SmallCells e MacroCells

b = length(U);
for j = 1:24
    tic
    a = 1;
    for k = 1:b
        if (U(k).M == j)
            User(a) = U(k);
            a = a + 1;
        end
    end    
    
    % Conexão Usuário/Small
    [Us1, S1] = ConexaoUs(User, Small); % Usuários e Small
    [M1] = Media(Us1); % M = [DataRate SINR > DR <DR UD]
    [V21] = Media_M(S1, Us1); %S1 - SmallCells com nº(S1.U) e indices(S1.VU) de usuarios conectados
    [saida(j,:), numero_SC(j, :), Micros(j, :)] = SA_algorithm (V21, Us1, Small, Macro);
    fprintf('Implementando SA para a hora #%d!\n', j);


    %Sn(24x4)
    
    clear User;
    tempo_execucao(j) = toc; % Tempo de execução para cada hora
end



% for j = 1:24
%     a = 1;
%         for k = 1:b
%             if (U(k).M == j)
%                 User(a) = U(k);
%                 a = a + 1;
%             end
%         end       
%    
%       
%       [saida(j,:)] = SelecionaB(numero_SC, User, melhor_selecao(j,:,:), Macro, Small);

   
%     clear User;
%     fprintf('Seleção para a hora #%d \n', j);
% end



end

