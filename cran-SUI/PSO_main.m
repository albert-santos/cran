function [Result ,GBest,BBUL, RRHs_by_BBU] = PSO_main (users_by_micros, number_of_BBUs, number_of_RRHs)


%rng('shuffle')

tic

% =========================================================================
%  Vari�veis de Entrada
% =========================================================================

% User = [0	23	0	15	19	19	16	20	0	0	17	35	43	31	30	28	35	31	25	0	0	32	24	21	26	35	19	24	41	0	14	34	33	30	29	26	26	34	35	17	17	24	35	34	31	31	43	45	30	23	0	24	28	33	33	26	35	22	17	20	0	35	29	33	43	30	28	25	36	16	0	31	46	35	22	30	33	35	34	20	21	27	31	28	25	34	31	19	23	15	0	22	21	16	17	20	15	15	18	0
% ]; % Usuários por RRH
m = number_of_RRHs; % Número de variáveis (Quantidade de RRH's)
n = 220; % Tamanho da População 
c1 = 1.8; % Fator de aceleração (Parâmetro pessoal)
c2 = 1.8; % Fator de aceleração (Parâmetro global)
max_int = 100; % Número máximo de interações


% =========================================================================
% Inicialização
% =========================================================================

population = randi([1 number_of_BBUs], n, m);
V = randi([1 (number_of_BBUs - 1)],n,m);

[OF_0] = PSO_ofun (population, users_by_micros, number_of_BBUs);

      
[F_0 Ind] = min(OF_0); % seleciona a solução que teve o menor custo
PBest = population;
GBest = population(Ind,:);

 
% =========================================================================
%  Início da busca
% =========================================================================
 
int = 1;
 
while int <= max_int 

%  int   
for k = 1:n  % Update da velocidade
    for i = 1:m
       V(k,i) = ceil(V(k,i) + c1 * randi([0 1]) * (PBest(k,i) - population(k,i))...
                + c2 * randi([0 1])*(GBest(1,i)- population(k,i))); 
    end
end

population = mod(population + V, number_of_BBUs);
     
for i = 1:n
for j = 1:m
   if population(i,j) == 0
      population(i,j) = number_of_BBUs;
   end
end
end
   
[OF] = PSO_ofun (population, users_by_micros, number_of_BBUs);

for i = 1:n % Update do Pbest
   if OF(i) < OF_0(i)
      PBest(i,:) = population(i,:);
      OF_0(i) = OF(i);
   end 
end
 
[F_min Indice] = min(OF);
if F_min < F_0
   GBest = population(Indice,:);
   F_0 = F_min;
end    
 

BBUL = zeros([1 number_of_BBUs]);
RRHs_by_BBU = zeros([1 number_of_BBUs]);;

for i = 1:length(BBUL)
    for j = 1:length(GBest)
        if GBest(j) == i
        BBUL(i) = BBUL(i)+ users_by_micros(j);
            if users_by_micros(j) ~= 0
            RRHs_by_BBU(i) = RRHs_by_BBU(i) + 1;
            end
        end
    end    
end


Result(int) = F_0;    
int = int + 1;   


%disp(sprintf('%8g %8g %8.4f',ite,index,fmin));

end
   

time = toc;
% 
% plot (Result, '.');
% xlabel('Iteration');
% ylabel('Fitness function value');
% title('PSO convergence characteristic')
% time1 = time;
end

