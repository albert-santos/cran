
clearvars

rng(42);
   

optimization_model = 'SA'; % SA ou HDSO

Sim = 1;    % Total de Execuções
U = 100;     % Total de Usuários
S = 10;      % Smalls
M = 1;       % Total de Macro
number_of_BBUs = 6; % Número de BBUs

if strcmpi(optimization_model,'SA')
    
    % Caminho para salvar posições dos usuário
    UserPositionPath = 'SA_positions/UserPosition_with_SAModel.xls';
    % Caminho para salvar posições das Base Stations
    EnbsPositionPath = 'SA_positions/SmallPosition_with_SAModel.xls';
    % Caminho para salvar a tabela principal 
    Saida = 'SA_positions/SaidaSA.xls';
    
    % Caminho o percentual de usuários bloqueados em cada cenário
    ProbBloqueio = 'SA_Results/Prob_bloqueio_SA.mat';
    % Caminho para salvar a quantidade de usuários por micro (Small Cell)
    UsuariosPorMicro = 'SA_Results/usr_por_micro.mat';
    % Caminho para salvar a tabela principal em uma variável do Matlab
    Results = 'SA_Results/SA.mat';
    
    % Caminho para salvar a quantidade de usuários por setor de BBU
    UsersBySector = 'SA_positions/user_by_sector_with_SAModel.xls';
    % Caminho para salvar o mapeamento entre RHH e BUU
    MappingRrhBbuSectors = 'SA_positions/mapping_rrh_bbu_sectors_with_SAModel.xls';
    % Caminho para o status (ligada ou desligado) de cada RRH
    RrhStatus = 'SA_positions/rrhs_status_with_SAModel.xls';
      
end

if strcmpi(optimization_model,'HDSO')
    
    % Caminho para salvar posições dos usuário
    UserPositionPath = 'HDSO_positions/UserPosition_with_HDSOModel.xls';
    % Caminho para salvar posições das Base Stations
    EnbsPositionPath = 'HDSO_positions/SmallPosition_with_HDSOModel.xls';
    % Caminho para salvar a tabela principal 
    Saida = 'HDSO_positions/SaidaHDSO.xls';
    
    % Caminho o percentual de usuários bloqueados em cada cenário
    ProbBloqueio = 'HDSO_Results/Prob_bloqueio_HDSO.mat';
    % Caminho para salvar a quantidade de usuários por micro (Small Cell)
    UsuariosPorMicro = 'HDSO_Results/usr_por_micro.mat';
    % Caminho para salvar a tabela principal em uma variável do Matlab
    Results = 'HDSO_Results/HDSO.mat';
    
    % Caminho para salvar a quantidade de usuários por setor de BBU
    UsersBySector = 'HDSO_positions/user_by_sector_with_HDSOModel.xls';
    % Caminho para salvar o mapeamento entre RHH e BUU
    MappingRrhBbuSectors = 'HDSO_positions/mapping_rrh_bbu_sectors_with_HDSOModel.xls';
    % Caminho para o status (ligada ou desligado) de cada RRH
    RrhStatus = 'HDSO_positions/rrhs_status_with_HDSOModel.xls'; 
end

fprintf('Implementando cenário com #%d usuários\n ', U)

%tic

for i = 1:Sim
  
% Otimização usando SA   
if strcmpi(optimization_model,'SA')
    [saida(:,:,i), tempo_execucao_1(:,i), Micros(:,:,i), UE(i,:), small_cell_status(:,:,i)] = root(U,S,M,optimization_model);
end

% Otimização usando HDSO
if strcmpi(optimization_model,'HDSO')
    [saida(:,:,i), tempo_execucao_1(:,i), Micros(:,:,i), UE(i,:), small_cell_status(:,:,i)] = root(U,S,M,optimization_model);
end

fprintf('Fim da Iteração #%d\n', i);
end
%Micros(horas:total de micros: nº de iterações do código)

[UserPosition] = Users_position(UE, Sim); % Posicao dos usuários para cada hora
[EnbsPosition] = Smalls_position(Micros, Sim); % Posição das SmallCells selecionadas para cada hora

writematrix(UserPosition,UserPositionPath, 'WriteMode', 'overwritesheet');
writematrix(EnbsPosition,EnbsPositionPath, 'WriteMode', 'overwritesheet');
writematrix(saida(:,:,Sim),Saida, 'WriteMode', 'overwritesheet');

 
T1 = size(saida, 1);
T2 = size(saida, 2);
saida1 = zeros(T1,T2);

for i = 1:Sim
    for j=1 : T1
        for h=1 : T2
           saida1(j, h) = saida1 (j, h) + saida(j, h, i);
        end
    end
    
end

T1 = size(Micros, 1); %24 linhas que representam as 24h
T2 = size(Micros, 2);% colunas que representam o número total de micros na rede
usr_por_micro = zeros(T1,T2);

for i = 1:Sim %nº de iterações do código
    for j=1 : T1 %1→24
        for h=1 : T2 %1→total de micros
           usr_por_micro(j, h) = usr_por_micro(j, h) + Micros(j, h, i).U;
        end
    end
    
end
usr_por_micro(:,:) = round(usr_por_micro/Sim); 

% Média dos resultados considerando o número de repetições da simulação (Sim)
saidaOptimization(:,:) = round(saida1/Sim);
%z = toc;

% Cálcula a quantidade de usuários em cada Small
for i=1:24
    for j=1:size(Micros, 2)
        UsuariosPorMicroAuxiliar(i, j) = usr_por_micro(i,j);
    end
end

% Cálculo da probabilidade de bloqueio (Percentual de usuários que não obtiveram a taxa mínima requisitada)
for i=1:24
    Prob_bloqueio(i) = sum(saidaOptimization(i,2),1)./sum((saidaOptimization(i,1)+saidaOptimization(i,2)),1);
end

save(ProbBloqueio, 'Prob_bloqueio');


usr_por_micro_final = UsuariosPorMicroAuxiliar(:, :);
save(UsuariosPorMicro, 'usr_por_micro_final');
saidaOptimization = saidaOptimization(:, :);
save(Results, 'saidaOptimization');
total_usuarios_conectados = saidaOptimization(:,1) - saidaOptimization(:,2);
usuarios_conectados_nas_micros = saidaOptimization(:,10);

SA_usuarios_por_macro = total_usuarios_conectados - usuarios_conectados_nas_micros; 


% Número de Smalls. As Smalls estão em grid sendo que o total será S * S
number_of_RRHs = S * S; 
% Balanceamento por meio da alocação das Smalls nas BBUs
[users_by_sector, mapping_rrh_bbu_sectors] = PSO_ROOT(usr_por_micro_final, number_of_BBUs, number_of_RRHs);

writematrix(users_by_sector,UsersBySector, 'WriteMode', 'overwritesheet');
writematrix(mapping_rrh_bbu_sectors,MappingRrhBbuSectors, 'WriteMode', 'overwritesheet');
writematrix(small_cell_status,RrhStatus, 'WriteMode', 'overwritesheet');
%-----------------------------------------------------------------------------





% x=(1:24);
% y1 =saidaOptimization(:,9,1);
% y2 = saida_HDSO(:,9,1);
% y3 =saidaOptimization(:,9,2);
% y4 = saida_HDSO(:,9,2);
% y5 =saidaOptimization(:,9,3);
% y6 = saida_HDSO(:,9,3);
% figure1 = figure('Name', 'Número de Micros Selecionadas','Color',[1 1 1]);
% axes1 = axes('Parent',figure1);
% hold(axes1,'on');
% plot(x,y1, 's', 'LineStyle','-');
% hold on
% plot(x,y2, '^' ,'LineStyle','-');
% hold on
% plot(x,y3, 's', 'LineStyle','-');
% hold on
% plot(x,y4,'^', 'LineStyle','-');
% hold on
% plot(x,y5, 's', 'LineStyle','-');
% hold on
% plot(x,y6,'^', 'LineStyle','-');
% hold on
% xlabel('Períodos do dia (Hrs)')
% ylabel('Micros Ativas')
% set(axes1,'XTick',(1:24),'XTickLabel',(1:24));
% set(axes1,'YTick',(0:10:100),'YTickLabel',(0:10:100));
% legend1 = legend('SA-500', 'HDSO-500', 'SA-1000', 'HDSO-1000', 'SA-1500', 'HDSO-1500');
% set(legend1,'Location','southeast');


% 
% low_traffic_SA = 0;
% low_traffic_FU = 0;
% for i=3:11
%     low_traffic_SA = low_traffic_SA + saida1(i,9);
%     low_traffic_FU = low_traffic_FU + saida2(i,9);
% end
% 
% low_traffic_SA = low_traffic_SA / 9;
% low_traffic_FU = low_traffic_FU / 9;
% 
% peak_traffic_SA = 0;
% peak_traffic_FU = 0;
% for i=13:24
%     peak_traffic_SA = peak_traffic_SA + saida1(i,9);
%     peak_traffic_FU = peak_traffic_FU + saida2(i,9);
% end
% 
% peak_traffic_SA = peak_traffic_SA / 12;
% peak_traffic_FU = peak_traffic_FU / 12;
% 
% 
% daily_average_SA = 0;
% daily_average_FU = 0;
% for i=1:24
%     daily_average_SA = daily_average_SA + saida1(i,9);
%     daily_average_FU = daily_average_FU + saida2(i,9);
% end
% 
% daily_average_SA = daily_average_SA /24;
% daily_average_FU = daily_average_FU /24;
% 
% comparacao_Low = (1 - (low_traffic_SA / low_traffic_FU)) * 100;
% comparacao_DA = (1 - (daily_average_SA / daily_average_FU)) * 100;
% comparacao_Peak = (1 - (peak_traffic_SA / peak_traffic_FU)) * 100;
% 
% 
% graf = [low_traffic_SA low_traffic_FU; peak_traffic_SA peak_traffic_FU; daily_average_SA daily_average_FU];
% 
%     figure2 = figure('Name', 'Número de Micros Selecionadas','Color',[1 1 1]);
%     axes2 = axes('Parent',figure2);
%     hold(axes2,'on');
%     bar(graf)
%     %xlabel('')
%     ylabel('Micros Selecionadas')
%     set(axes2,'XTick',[1 2 3],'XTickLabel',{'Low traffic','Peak traffic','Daily average'});
%     legend2 = legend('Simulated annealing', 'HDSO');
%     set(legend2,'Location','northwest');
    
    
% for i=1:24
%     Prob_bloqueio_SA(i,1) = sum(saida1(i,2),1)./sum((saida1(i,1)+saida1(i,2)),1);    
%     Prob_bloqueio_FU(i,2) = sum(saida2(i,2),1)./sum((saida2(i,1)+saida2(i,2)),1);
% end
    
%     x(1:24);
%     figure3 = figure('Name', 'Probabilidade de Bloqueio','Color',[1 1 1]);
%     axes3 = axes('Parent',figure3);
%     hold(axes3,'on');
%     plot(x,Prob_bloqueio_SA(:,1),'s', 'LineStyle','-');
%     hold on
%     plot(x,Prob_bloqueio_FU(:,1), '^', 'LineStyle','-');
%     hold on
%     plot(x,Prob_bloqueio_SA(:,2), 's', 'LineStyle','-');
%     hold on
%     plot(x,Prob_bloqueio_FU(:,2), '^', 'LineStyle','-');
%     hold on
%     plot(x,Prob_bloqueio_SA(:,3), 's', 'LineStyle','-');
%     hold on
%     plot(x,Prob_bloqueio_FU(:,3), '^', 'LineStyle','-');
%     hold on
%     %xlabel('')
%     ylabel('Probabilidade de Bloqueio')
%     set(axes3,'XTick',(1:24),'XTickLabel',(1:24));
%     legend3 = legend('SA-500', 'HDSO-500', 'SA-1000', 'HDSO-1000', 'SA-1500', 'HDSO-1500');
%     set(legend3,'Location','northeast');
    
    
    
% temp = size(tempo_execucao_1, 1);
% tempo_execucao_SA = zeros(temp,1);
% tempo_execucao_FU = zeros(temp,1);
% for i=1:temp
%     for j=1:Sim
%         tempo_execucao_FU(i) = tempo_execucao_FU(i)+ tempo_execucao_2(i, j);
%         tempo_execucao_SA(i) = tempo_execucao_SA(i)+ tempo_execucao_1(i, j);
%     end
% end
% 
% tempo_execucao_SA = tempo_execucao_SA ./Sim;
% tempo_execucao_FU = tempo_execucao_FU./Sim;
% 
% tempo_execucao_SA = tempo_execucao_SA ./60;
% tempo_execucao_FU = tempo_execucao_FU./60;  


% x=(1:24);
% figure4 = figure('Name', 'Tempo de execução dos algoritmos','Color',[1 1 1]);
% axes4 = axes('Parent',figure4);
% hold(axes4,'on');
% plot(x,t_execucao_SA(:,1), 's', 'LineStyle','-');
% hold on
% plot(x,t_execucao_HDSO(:,1), '^', 'LineStyle','-');
% hold on
% plot(x,t_execucao_SA(:,2), 's', 'LineStyle','-');
% hold on
% plot(x,t_execucao_HDSO(:,2), '^', 'LineStyle','-');
% hold on
% plot(x,t_execucao_SA(:,3), 's', 'LineStyle','-');
% hold on
% plot(x,t_execucao_HDSO(:,3), '^', 'LineStyle','-');
% hold on
% xlabel('Períodos do dia (Hrs)')
% ylabel('Tempo por execução(min)')
% set(axes4,'YTick',(0:0.1:1.5),'YTickLabel',(0:0.1:1.5));
% set(axes4,'XTick',(1:24),'XTickLabel',(1:24));
% legend4 = legend('SA-500', 'HDSO-500', 'SA-1000', 'HDSO-1000', 'SA-1500', 'HDSO-1500');
% set(legend4,'Location','southeast');
% 
% 
% vazao_SA_500 = sum(saidaOptimization(:,3,1),1)/24;
% vazao_SA_1000 = sum(saidaOptimization(:,3,2),1)/24;
% vazao_SA_1500 = sum(saidaOptimization(:,3,3),1)/24;
% 
% save('SA_Results/Vazao_Media_SA_500.mat', 'vazao_SA_500');
% save('SA_Results/Vazao_Media_SA_1000.mat', 'vazao_SA_1000');
% save('SA_Results/Vazao_Media_SA_1500.mat', 'vazao_SA_1500');
% 
% vazao_HDSO_500 = sum(saida_HDSO(:,3,1), 1)/24;
% vazao_HDSO_1000 = sum(saida_HDSO(:,3,2), 1)/24;
% vazao_HDSO_1500 = sum(saida_HDSO(:,3,3), 1)/24;
% 
% graf = [vazao_SA_500 vazao_HDSO_500; vazao_SA_1000 vazao_HDSO_1000; vazao_SA_1500 vazao_HDSO_1500];
% 
%     figure5 = figure('Name', 'Vazão Média','Color',[1 1 1]);
%     axes5 = axes('Parent',figure5);
%     hold(axes5,'on');
%     bar(graf)
%     ylabel('Vazão Média')
%     xlabel('Quantidade de usuários')
%     set(axes5,'XTick',[1 2 3],'XTickLabel',{'500','1000','1500'});
%     legend5 = legend('SA', 'HDSO');
%     set(legend5,'Location','northwest');
    

% 
% tot1 = sum(tempo_execucao_SA,1);
% tot2 = sum(tempo_execucao_FU,1);
% tot = tot1 + tot2;
% tempo1_medio = tot1 /24;
% tempo2_medio = tot2 /24;
%     

%---------- Saidas de CalculoResults´----------
%  1 = Usuarios Cobertos
%  2 = Usuarios Não Cobertos 
%  3 = Media DR Usuários (Geral)
%  4 = DR minimo Usuários
%  5 = DR maximo Usuários 
%  6 = Média DR Usuários (Micro-Conectados)
%  7 = DR minimo Usuários (Micro)
%  8 = DR maximo Usuários (Micro)
%  9 = Micros ligadas 
% 10 = Usuários Conectados (Micro)



