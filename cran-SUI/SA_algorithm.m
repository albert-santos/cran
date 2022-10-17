function [saida, numero_SC, S1, small_cell_status] = SA_algorithm (V21, Us1, Small, Macro)
%% SA algorithm 

%% Initial parameters of ACO 
T0=1000;       % Initial Temp.
T=T0;

alphaa=0.99;     % Cooling factor
maxIteration = 1000;


%% Main loop of SA 
Total_US = size(Us1, 2);
menor_valor= inf;
fitness_hist = 0;
A.cost = inf;

TS = length(Small);
A.position = V21;

for i=0:2:TS
%      for t = 1 : maxIteration
% 
%         fitness_hist(t) = A.cost;
% 
%         B.position=createNeighbour(A.position);
%         B.cost = funcao_de_selecao (B.position, i, Total_US);
% 
%         Delta = B.cost - A.cost;
% 
%         if Delta < 0  % uphill move (good move)
%             A.position = B.position;
%             A.cost = B.cost;
%             
%         else % downhill move (bad move)
%             P=exp(-Delta/T);
%             if rand<=P
%                 A.position = B.position;
%                 A.cost = B.cost;
%             end
%         end
% 
%         % Update Temp.
%         T=alphaa*T;
% 
%      end
     
%      melhor_selecao = A.position;
     melhor_selecao = sortrows(V21, -3);
%      menor_valor = A.cost;
     
     [saida, S1, small_cell_status] = SelecionaB(i, Us1, melhor_selecao, Macro, Small);
     
     if saida(1,2) < (Total_US*0.001) || (i == TS) % Condições de parada do loop. 
         %Nº de usuários ser menor que 0,1% do total de usuários daquele
         %período ou o Nº de micros atingir 90% do total
         numero_SC = i; 
                                                       
         break;
     end
     
end


   
saida(1,9)

end
