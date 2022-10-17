clear all; clc;
global ht hr f modelo data;

%%Defina o Modelo de Propaga??o a ser Ajustado(UFPA, SUI, ECC)
modelo1='ECC';
modelo2='SUI';
modelo3='UFPA';

for i=1:1:3
    if i==1
    modelo=modelo1;
    elseif i==2
        modelo=modelo2;
    else
        modelo=modelo3;
    end

%------Carregamento do Arquivo Utilizado, e defini??o de Parametros-----%
%[FileName,PathName] = uigetfile('*.txt','Selecione o arquivo de medi??o.', '..\..\dados\dados_processados\');%Selecionar o arquivo a ser trabalhado.
FileName = '40_1.60_1.8e9_BLMN16.txt';
% PathName = '/Users/andrepacheco/Documents/MATLAB/dados/tese/';

PathName = '';

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

switch modelo 
    case 'SUI'
        x0 = [4 0.0065 17.1]; 
    case 'ECC'
        x0 = [13.958 5.8 0.759 1.862]; 
    case 'UFPA'
        x0 = [16.5 14.2 42.5 7.6];
end
%-------------------Parametros do AG-----------------------%
desvio = 10;        % Desvio m?ximo em rela??o a base, em porcentagem
Nger = 1000;        % N?mero m?ximo de gera??es
Nsp  = 0.01*Nger;    % N?mero de gera??es sem progresso
pop  = 100;         % Tamanho da popula??o

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
end

addpath(strcat(pwd, '/otimizacao/modelos'))

L = ECC(x0, ht, hr, f, data(:, 1));%Modelos ECC com ajuste

[xCuckoo,erroCuckoo]=cuckoo_search(ht, hr, f, data, modelo, lim_min, lim_max);

switch modelo
    case 'SUI'
        L = SUI(x0, ht, hr, f, data(:, 1)); %Modelos SUI sem ajuste
        Lsui=L;
        LCuckoo = SUI(xCuckoo, ht, hr, f, data(:, 1));%Modelos SUI com ajuste CUCKOO             
    case 'ECC'
        L = ECC(x0, ht, hr, f, data(:, 1));%Modelos ECC com ajuste
        LCuckoo = ECC(xCuckoo, ht, hr, f, data(:, 1));%Modelos ECC com ajuste CUCKOO        
    case 'UFPA'
        L = UFPA(x0, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste
        LCuckoo = UFPA(xCuckoo, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste CUCKOO
        Lufpacomajuste=LCuckoo;
        Lufpa = L;
end

%--------------------Calculo do Erro--------------% Qual seria esse erro RMSE
erro0 = em2(L, data(:, 2));%calculo do erro entre a perda de propaga??o do modelo sem ajuste e os dados medidos.
erroCUCKOORMS = em2(LCuckoo, data(:, 2));

dp = desv_pad(L, data(:, 2));%calculo do desvio padrao do modelo de propaga??o sem ajuste
dpCuckoo = desv_pad(LCuckoo, data(:, 2));%calculo do desvio padrao do modelo de propaga??o com ajuste CUCKOO

rmpath(strcat(pwd, '/otimizacao/modelos')) % rmpath (nome da pasta) remove a pasta especificada no caminho de pesquisa.

figure
semilogx(data(:, 1), data(:, 2), '*', 'LineWidth', 1)%plot dos dados medidos com a distancia.
hold all
plot(data(:, 1), L, '--x' ,'LineWidth', 1)%plot dos modelos sem ajuste.
plot(data(:, 1), LCuckoo, '--o', 'LineWidth', 1)%plot dos modelos com ajuste CUCKOO.
grid on
set(gca,'FontSize',24)
title('ROUTE 2');
xlim([0 600]);
ylim([110 150]);
xlabel('Distance (m)');
ylabel('Path Loss (dB)');
legend(' Measurements', strcat(modelo, ' no adjustments'), strcat(modelo, ' with adjustments CS'))


disp('-------------------------------------------------------------------')
disp('Setor:')
disp(remain(2:end-3))
disp(' ')
disp(['Modelo otimizado: ', modelo])

disp('#--------# Erro m?dio quadr?tico #--------#')
disp('    default     Cuckoo');
resultado_erro = [erro0, erroCuckoo];
disp(resultado_erro)

resultado_desvio_padrao = [dp, dpCuckoo];
disp('#---------------# Desvio padr?o #---------------#')
disp('    default     Cuckoo')
disp(resultado_desvio_padrao)

disp('#-----------------------# Par?metros #-----------------------#')
disp(['          Default = ', num2str(x0)]);
disp(['Otimizados Cuckoo = ', num2str(xCuckoo)]);

disp('-------------------------------------------------------------------')
end

Ltotal = [data(:, 2) Lsui Lufpa Lufpacomajuste];
save('grgmapeversao1.txt','Ltotal','-ascii');