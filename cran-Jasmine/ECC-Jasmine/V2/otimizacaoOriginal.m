clear all; clc;
global ht hr f modelo data;

%%Defina o Modelo de Propaga??o a ser Ajustado(UFPA, SUI, ECC, ABG)
modelo1='SUI';
modelo2='ECC';
modelo3='UFPA';
modelo4='ABG';

for i=1:1:4
    if i==1
    modelo=modelo1;
    elseif i==2
        modelo=modelo2;
    else
        if i==3
        modelo=modelo3;
        else
        modelo=modelo4;
        end
    end

%------Carregamento do Arquivo Utilizado, e defini??o de Parametros-----%
%[FileName,PathName] = uigetfile('*.txt','Selecione o arquivo de medi??o.', '..\..\dados\dados_processados\');%Selecionar o arquivo a ser trabalhado.
FileName = '40_1.60_2.6e9_BLMS05.txt';
PathName = '/Users/andrepacheco/Documents/MATLAB/dados/EletronicLetters_Processados/';
%PathName = '/Users/Jasmine/Documents/andre/nova_otimizacao/';
%Altura da Antena Transmissora(metros),ler do titulo do arquivo e transforma em um tipo de variavel double.
[ht, remain] = strtok(FileName, '_'); 
ht = str2double(ht);

%Altura da Antena Recep??o(metros),ler do titulo do arquivo e transforma em um tipo de variavel double.
[hr, remain] = strtok(remain, '_'); 
hr = str2double(hr);

%Frequencia(GHz),ler do titulo do arquivo e transforma em um tipo de variavel double.
[f, remain] = strtok(remain, '_'); 
f = str2double(f);

%Carrega o Arquivo Selecionado em uma matriz.
data = load(horzcat(PathName, FileName)); 

switch modelo %Alterna entre os modelos, modificando a variavel modelos(na terceira linha).
    case 'SUI'
        x0 = [4 0.0065 17.1]; %valores de start do modelo
    case 'ECC'
        x0 = [13.958 5.8 0.759 1.862]; %valores de start do modelo
    case 'UFPA'
        %x0 = [16.5155 14.1878 42.49 7.68 0.1];%50]; %??? valores de start do modelo
        x0 = [16.5 14.2 42.5 7.6];
    case 'ABG'
         x0 = [3 5]; %valores de start do modelo
end
%%
%-------------------Parametros do AG-----------------------%
desvio = 10;        % Desvio m?ximo em rela??o a base, em porcentagem
Nger = 1000;        % N?mero m?ximo de gera??es
Nsp  = 0.01*Nger;    % N?mero de gera??es sem progresso
pop  = 100;         % Tamanho da popula??o

%lim_min = (1-desvio/100) .* x0;%Limite minimo dos membros da popula??o inicial.
%lim_max = (1+desvio/100) .* x0;%Limite maximo dos membros da popula??o inicial.

switch modelo
    case 'SUI'
        lim_min = [1 0 1];
        lim_max = [10 50 50];
    case 'ECC'
        lim_min = [1 0.1 0.1 0.1];
        lim_max = [50 10 10 10];
    case 'UFPA'
        lim_min = [1 1 1 1];
        lim_max = [50 50 100 50];
    case 'ABG'
        lim_min = [1 -5 ];
        lim_max = [5 100];
end

addpath(strcat(pwd, '/otimizacao/modelos'))
% Fun??o do Matlab para Create genetic algorithm options structure. Documenta??o da Fun??o pode ser encontrada em http://www.mathworks.com/help/gads/gaoptimset.html
opcoes = gaoptimset('Generations', Nger, 'StallGenLimit', Nsp, ...
                    'PopulationSize', pop, 'PopInitRange', [lim_min;lim_max],...
                    'StallTimeLimit', inf, 'TolFun', 1e-12);
%ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,ConstraintFunction)
%[xAG, erroAG] = ga(@(xAG) func(xAG, [ht, hr, f], data, modelo), length(x0), opcoes);
[xAG, erroAG] = ga(@(xAG) func(xAG, [ht, hr, f], data, modelo),length(x0),[],[],[],[],lim_min,lim_max);
[xCuckoo,erroCuckoo]=cuckoo_search(ht, hr, f, data, modelo, lim_min, lim_max);
[xBat,erroBat]=bat_algorithm(length(x0),ht, hr, f, data, modelo, lim_min, lim_max);
[xFpa,erroFpa]=fpa(length(x0),ht, hr, f, data, modelo, lim_min, lim_max);
%saida da fun??o seria o erro entre as perdas de propaga??o do modelo ajustado e os dados medidos.

switch modelo
    %Calculos dos Modelos com e sem ajuste
    case 'SUI'
        L = SUI(x0, ht, hr, f, data(:, 1)); %Modelos SUI sem ajuste
        LCuckoo = SUI(xCuckoo, ht, hr, f, data(:, 1));%Modelos SUI com ajuste CUCKOO
        LAG = SUI(xAG, ht, hr, f, data(:, 1));%Modelos SUI com ajuste AG
        LBat = SUI(xBat, ht, hr, f, data(:, 1));%Modelos SUI com ajuste BAT
        LFpa = SUI(xFpa, ht, hr, f, data(:, 1));%Modelos SUI com ajuste FPA
              
    case 'ECC'
        L = ECC(x0, ht, hr, f, data(:, 1));%Modelos ECC com ajuste
        LCuckoo = ECC(xCuckoo, ht, hr, f, data(:, 1));%Modelos ECC com ajuste CUCKOO
        LAG = ECC(xAG, ht, hr, f, data(:, 1));%Modelos ECC com ajuste AG
        LBat = ECC(xBat, ht, hr, f, data(:, 1));%Modelos ECC com ajuste BAT
        LFpa = ECC(xFpa, ht, hr, f, data(:, 1));%Modelos ECC com ajuste FPA
        
    case 'UFPA'
        L = UFPA(x0, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste
        LCuckoo = UFPA(xCuckoo, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste CUCKOO
        LAG = UFPA(xAG, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste AG
        LBat = UFPA(xBat, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste Bat
        LFpa=UFPA(xFpa, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste Fpa
        
    case 'ABG'
        L = ABG(x0, ht, hr, f, data(:, 1));%Modelos ABG com ajuste
        LCuckoo = ABG(xCuckoo, ht, hr, f, data(:, 1));%Modelos ABG com ajuste CUCKOO
        LAG = ABG(xAG, ht, hr, f, data(:, 1));%Modelos ABG com ajuste AG
        LBat = ABG(xBat, ht, hr, f, data(:, 1));%Modelos ABG com ajuste Bat
        LFpa = ABG(xFpa, ht, hr, f, data(:, 1));%Modelos ABG com ajuste Fpa
end
%%
%--------------------Calculo do Erro--------------% Qual seria esse erro RMSE
erro0 = em2(L, data(:, 2));%calculo do erro entre a perda de propaga??o do modelo sem ajuste e os dados medidos.
erroAGRMS = em2(LAG, data(:, 2));
erroCUCKOORMS = em2(LCuckoo, data(:, 2));
erroBATRMS = em2(LBat, data(:, 2));
erroFPARMS = em2(LFpa, data(:, 2));



dp = desv_pad(L, data(:, 2));%calculo do desvio padrao do modelo de propaga??o sem ajuste
dpCuckoo = desv_pad(LCuckoo, data(:, 2));%calculo do desvio padrao do modelo de propaga??o com ajuste CUCKOO
dpAG = desv_pad(LAG, data(:, 2));%calculo do desvio padrao do modelo de propaga??o com ajuste AG
dpBat = desv_pad(LBat, data(:, 2));%calculo do desvio padrao do modelo de propaga??o com ajuste Bat
dpFpa = desv_pad(LFpa, data(:, 2));%calculo do desvio padrao do modelo de propaga??o com ajuste FPA


rmpath(strcat(pwd, '/otimizacao/modelos')) % rmpath (nome da pasta) remove a pasta especificada no caminho de pesquisa.

figure
semilogx(data(:, 1), data(:, 2), '*', 'LineWidth', 1)%plot dos dados medidos com a distancia.
hold all
%plot(data(:,1),data(:,2),'.',data(:, 1), L,data(:, 1),LCuckoo, data(:,1),LAG)%plot dos modelos SEM ajuste.
plot(data(:, 1), L, '-^' ,'LineWidth', 1)%plot dos modelos sem ajuste.
plot(data(:, 1), LAG, '-' ,'LineWidth', 1)%plot dos modelos com ajustes AG.
plot(data(:, 1), LCuckoo, '-o', 'LineWidth', 1)%plot dos modelos com ajuste CUCKOO.
plot(data(:, 1), LBat, '--x' ,'LineWidth', 1)%plot dos modelos com ajuste Bat.
plot(data(:, 1), LFpa, '--x' ,'LineWidth', 1)%plot dos modelos com ajuste Fpa.

%legend('Medi??es', strcat(modelo, ' sem ajuste'), strcat(modelo, ' com ajuste AG'), strcat(modelo, ' com ajuste CUCKOO'),strcat(modelo, ' com ajuste Bat'))
legend(' Measurements', strcat(modelo, ' no adjustments'), strcat(modelo, ' with AG settings'), strcat(modelo, ' with adjustments CS'),strcat(modelo, ' with BAT adjustments'),strcat(modelo, ' with FPA adjustments'))

xlabel('Distance (m)')
ylabel('Loss (dB)')

disp('-------------------------------------------------------------------')
disp('Setor:')
disp(remain(2:end-3))
disp(' ')
disp(['Modelo otimizado: ', modelo])

disp('#--------# Erro m?dio quadr?tico #--------#')
disp('    default     AG      Cuckoo    BAT    FPA');
resultado_erro = [erro0, erroAG, erroCuckoo, erroBat, erroFpa];
disp(resultado_erro)

resultado_desvio_padrao = [dp, dpAG, dpCuckoo, dpBat, dpFpa];
disp('#---------------# Desvio padr?o #---------------#')
disp('    default     AG      Cuckoo    BAT    FPA')
disp(resultado_desvio_padrao)

disp('#-----------------------# Par?metros #-----------------------#')
disp(['          Default = ', num2str(x0)]);
disp(['    Otimizados AG = ', num2str(xAG)]);
disp(['Otimizados Cuckoo = ', num2str(xCuckoo)]);
disp(['   Otimizados BAT = ', num2str(xBat)]);
disp(['   Otimizados FPA = ', num2str(xFpa)]);


disp('-------------------------------------------------------------------')
end