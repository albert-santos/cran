 clear all; clc; close all;
global ht hr f modelo data;
tStart = tic;  
n = 10;
T = zeros(1,n);
zeratoc = 0;

modelo1='ECC';
modelo2='SUI';
modelo3='UFPA';
modelo4='ABG';

for j=1:1:4
    if j==1
        FileName = '40_1.60_2.6e9_BLMS05.txt'; %dentro ufpa
        PathName = ''; 
    elseif j==2
        FileName = '50_1.60_1.8e9_BLMS07.txt'; %bras
        PathName = '/Users/andrepacheco/Documents/MATLAB/dados/Tese/'; 
    else
        if j==3
            FileName = '40_1.60_2.6e9_BLMS051.txt'; %fora ufpa
            PathName = '/Users/andrepacheco/Documents/MATLAB/dados/Tese/'; 
        else
            FileName = '40_1.60_1.8e9_BLMN16.txt'; %Joao Paulo
            PathName = '/Users/andrepacheco/Documents/MATLAB/dados/Tese/'; 
        end
    end
    

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


[ht, remain] = strtok(FileName, '_'); 
ht = str2double(ht);

[hr, remain] = strtok(remain, '_'); 
hr = str2double(hr);

[f, remain] = strtok(remain, '_'); 
f = str2double(f);

data = load(horzcat(PathName, FileName)); 

switch modelo 
    case 'SUI'
        x0 = [4 0.0065 17.1 6]; %valores de start do modelo
    case 'ECC'
        x0 = [20.41 9.83 7.894 9.56]; %x0 = [13.958 5.8 0.759 1.862]; %valores de start do modelo
    case 'UFPA'
        x0 = [16.5 14.2 42.5 7.6];
    case 'ABG'
          x0 = [3.3 17.6];%x0 = [5 100]; %valores de start do modelo
end

desvio = 10;        % Desvio m?ximo em rela??o a base, em porcentagem
Nger = 8000;        % N?mero m?ximo de gera??es
Nsp  = 0.01*Nger;    % N?mero de gera??es sem progresso
pop  = 100;         % Tamanho da popula??o

switch modelo
    case 'SUI'
        lim_min = [1 0 1 1];
        lim_max = [10 50 50 10];
    case 'ECC'
        lim_min = [1 0.1 0.1 0.1];
        lim_max = [50 10 10 10];
    case 'UFPA'
        lim_min = [1 1 1 1];
        lim_max = [50 50 100 50];
    case 'ABG'
        lim_min = [1 1];
        lim_max = [100 100]; %lim_max = [5 40];
end

addpath(strcat(pwd, '/otimizacao/modelos'))
opcoes = gaoptimset('Generations', Nger, 'StallGenLimit', Nsp, ...
                    'PopulationSize', pop, 'PopInitRange', [lim_min;lim_max],...
                    'StallTimeLimit', inf, 'TolFun', 1e-50, 'PlotFcns',@gaplotbestf); %codigo para plotar fitness

                
L = ECC(x0, ht, hr, f, data(:, 1));%Modelos ECC com ajuste

tic; 
%[xAG, erroAG, exitflag, output, pop, scores] = ga(@(xAG) func(xAG, [ht, hr, f], data, modelo),length(x0),[],[],[],[],lim_min,lim_max,[],opcoes);
[xAG, erroAG] = ga(@(xAG) func(xAG, [ht, hr, f], data, modelo),length(x0),[],[],[],[],lim_min,lim_max,[],opcoes);
disp('Rota AG');disp(toc); tic;
[xCuckoo,erroCuckoo,fitCS]=cuckoo_search(ht, hr, f, data, modelo, lim_min, lim_max);
disp('Rota CS');disp(toc); tic; 
[xBat,erroBat,fitBAT]=bat_algorithm(length(x0),ht, hr, f, data, modelo, lim_min, lim_max);
disp('Rota BAT');disp(toc); tic; 
[xFpa,erroFpa,fitFPA]=fpa(length(x0),ht, hr, f, data, modelo, lim_min, lim_max);
disp('Rota FPA');disp(toc);

fig = gcf;
dataObjs = findobj(fig, '-property', 'YData');
y1 = dataObjs(1).YData;
x1 = dataObjs(1).XData;
fitAG=y1;
if y1<=fitAG
    fitAG=y1;
end

switch modelo
    case 'SUI'
        L = SUI(x0, ht, hr, f, data(:, 1)); %Modelos SUI sem ajust
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
        LFpa = UFPA(xFpa, ht, hr, f, data(:, 1));%Modelos UFPA com ajuste Fpa
    case 'ABG'
        L = ABG(x0, ht, hr, f, data(:, 1));%Modelos ABG com ajuste
        LCuckoo = ABG(xCuckoo, ht, hr, f, data(:, 1));%Modelos ABG com ajuste CUCKOO
        LAG = ABG(xAG, ht, hr, f, data(:, 1));%Modelos ABG com ajuste AG
        LBat = ABG(xBat, ht, hr, f, data(:, 1));%Modelos ABG com ajuste Bat
        LFpa = ABG(xFpa, ht, hr, f, data(:, 1));%Modelos ABG com ajuste Fpa
end

       erro0 = em2(L, data(:, 2));%calculo do erro entre a perda de propaga??o do modelo sem ajuste e os dados medidos.
    erroAGRMS = em2(LAG, data(:, 2));
erroCUCKOORMS = em2(LCuckoo, data(:, 2));
   erroBATRMS = em2(LBat, data(:, 2));
   erroFPARMS = em2(LFpa, data(:, 2));


      dp = desv_pad(L, data(:, 2));%calculo do desvio padrao do modelo de propaga??o sem ajuste
dpCuckoo = desv_pad(LCuckoo, data(:, 2));
    dpAG = desv_pad(LAG, data(:, 2));
   dpBat = desv_pad(LBat, data(:, 2));
   dpFpa = desv_pad(LFpa, data(:, 2));

rmpath(strcat(pwd, '/otimizacao/modelos')) 

if i == 4
    modelo = 'FI';
end

if j == 1 %Rota1
    coluna1R1 = data(:, 1);
    coluna2R1 = data(:, 2);
    switch i
        case 1 %SUI
             fitAG_SUI1 = fitAG;   
            fitBAT_SUI1 = fitBAT; 
            fitFPA_SUI1 = fitFPA;
             fitCS_SUI1 = fitCS;
             
                LSUI1 = L;
             LAG_SUI1 = LAG;
            LBAT_SUI1 = LBat;
            LFPA_SUI1 = LFpa;
             LCS_SUI1 = LCuckoo;
            
        case 2 %ECC
             fitAG_ECC1 = fitAG;
            fitBAT_ECC1 = fitBAT;
            fitFPA_ECC1 = fitFPA;
             fitCS_ECC1 = fitCS;
            
                LECC1 = L;
             LAG_ECC1 = LAG;
            LBAT_ECC1 = LBat;
            LFPA_ECC1 = LFpa;
             LCS_ECC1 = LCuckoo;
            
        case 3 %UFPA
             fitAG_UFPA1 = fitAG;
            fitBAT_UFPA1 = fitBAT;
            fitFPA_UFPA1 = fitFPA;
             fitCS_UFPA1 = fitCS;
            
                LUFPA1 = L;
             LAG_UFPA1 = LAG;
            LBAT_UFPA1 = LBat;
            LFPA_UFPA1 = LFpa;
             LCS_UFPA1 = LCuckoo;
            
        case 4 %FI
             fitAG_FI1 = fitAG;
            fitBAT_FI1 = fitBAT;
            fitFPA_FI1 = fitFPA;
             fitCS_FI1 = fitCS;
            
                LFI1 = L;
             LAG_FI1 = LAG;
            LBAT_FI1 = LBat;
            LFPA_FI1 = LFpa;
             LCS_FI1 = LCuckoo;
    end
elseif j == 2 %Rota2
    coluna1R2 = data(:, 1);
    coluna2R2 = data(:, 2);
    switch i
        case 1 %SUI
             fitAG_SUI2 = fitAG;   
            fitBAT_SUI2 = fitBAT; 
            fitFPA_SUI2 = fitFPA;
             fitCS_SUI2 = fitCS;
            
                LSUI2 = L;
             LAG_SUI2 = LAG;
            LBAT_SUI2 = LBat;
            LFPA_SUI2 = LFpa;
             LCS_SUI2 = LCuckoo;
            
        case 2 %ECC
             fitAG_ECC2 = fitAG;
            fitBAT_ECC2 = fitBAT;
            fitFPA_ECC2 = fitFPA;
             fitCS_ECC2 = fitCS;
            
                LECC2 = L;
             LAG_ECC2 = LAG;
            LBAT_ECC2 = LBat;
            LFPA_ECC2 = LFpa;
             LCS_ECC2 = LCuckoo;
            
        case 3 %UFPA
            fitAG_UFPA2 = fitAG;
            fitBAT_UFPA2 = fitBAT;
            fitFPA_UFPA2 = fitFPA;
            fitCS_UFPA2 = fitCS;
            
                LUFPA2 = L;
             LAG_UFPA2 = LAG;
            LBAT_UFPA2 = LBat;
            LFPA_UFPA2 = LFpa;
             LCS_UFPA2 = LCuckoo;
            
        case 4 %FI
             fitAG_FI2 = fitAG;
            fitBAT_FI2 = fitBAT;
            fitFPA_FI2 = fitFPA;
             fitCS_FI2 = fitCS;
            
                LFI2 = L;
             LAG_FI2 = LAG;
            LBAT_FI2 = LBat;
            LFPA_FI2 = LFpa;
             LCS_FI2 = LCuckoo;
    end
else
    if j == 3 %Rota3
        coluna1R3 = data(:, 1);
        coluna2R3 = data(:, 2);
        switch i
        case 1 %SUI
             fitAG_SUI3 = fitAG;   
            fitBAT_SUI3 = fitBAT; 
            fitFPA_SUI3 = fitFPA;
             fitCS_SUI3 = fitCS;
            
                LSUI3 = L;
             LAG_SUI3 = LAG;
            LBAT_SUI3 = LBat;
            LFPA_SUI3 = LFpa;
             LCS_SUI3 = LCuckoo;
            
        case 2 %ECC
             fitAG_ECC3 = fitAG;
            fitBAT_ECC3 = fitBAT;
            fitFPA_ECC3 = fitFPA;
             fitCS_ECC3 = fitCS;
            
                LECC3 = L;
             LAG_ECC3 = LAG;
            LBAT_ECC3 = LBat;
            LFPA_ECC3 = LFpa;
             LCS_ECC3 = LCuckoo;
            
        case 3 %UFPA
             fitAG_UFPA3 = fitAG;
            fitBAT_UFPA3 = fitBAT;
            fitFPA_UFPA3 = fitFPA;
             fitCS_UFPA3 = fitCS;
            
                LUFPA3 = L;
             LAG_UFPA3 = LAG;
            LBAT_UFPA3 = LBat;
            LFPA_UFPA3 = LFpa;
             LCS_UFPA3 = LCuckoo;
            
        case 4 %FI
             fitAG_FI3 = fitAG;
            fitBAT_FI3 = fitBAT;
            fitFPA_FI3 = fitFPA;
             fitCS_FI3 = fitCS;
            
                LFI3 = L;
             LAG_FI3 = LAG;
            LBAT_FI3 = LBat;
            LFPA_FI3 = LFpa;
             LCS_FI3 = LCuckoo;
    end
    
    else  %Route4
        coluna1R4 = data(:, 1);
        coluna2R4 = data(:, 2);
        switch i
        case 1 %SUI
             fitAG_SUI4 = fitAG;   
            fitBAT_SUI4 = fitBAT; 
            fitFPA_SUI4 = fitFPA;
             fitCS_SUI4 = fitCS;
            
                LSUI4 = L;
             LAG_SUI4 = LAG;
            LBAT_SUI4 = LBat;
            LFPA_SUI4 = LFpa;
             LCS_SUI4 = LCuckoo;
            
        case 2 %ECC
             fitAG_ECC4 = fitAG;
            fitBAT_ECC4 = fitBAT;
            fitFPA_ECC4 = fitFPA;
             fitCS_ECC4 = fitCS;
            
                LECC4 = L;
             LAG_ECC4 = LAG;
            LBAT_ECC4 = LBat;
            LFPA_ECC4 = LFpa;
             LCS_ECC4 = LCuckoo;
            
        case 3 %UFPA
             fitAG_UFPA4 = fitAG;
            fitBAT_UFPA4 = fitBAT;
            fitFPA_UFPA4 = fitFPA;
             fitCS_UFPA4 = fitCS;
            
                LUFPA4 = L;
             LAG_UFPA4 = LAG;
            LBAT_UFPA4 = LBat;
            LFPA_UFPA4 = LFpa;
             LCS_UFPA4 = LCuckoo;
            
        case 4 %FI
             fitAG_FI4 = fitAG;
            fitBAT_FI4 = fitBAT;
            fitFPA_FI4 = fitFPA;
             fitCS_FI4 = fitCS;
            
                LFI4 = L;
             LAG_FI4 = LAG;
            LBAT_FI4 = LBat;
            LFPA_FI4 = LFpa;
             LCS_FI4 = LCuckoo;
    end
    end
    end

disp('-------------------------------------------------------------------')
disp('ROTA')
disp(j)
disp('Setor:')
disp(remain(2:end-3))
disp(' ')
disp(['Modelo otimizado: ', modelo])
disp('#--------# Erro medio quadratico #--------#')
disp('    default     AG      BAT    FPA     CS');
resultado_erro = [erro0, erroAG, erroBat, erroFpa, erroCuckoo];
disp(resultado_erro)
resultado_desvio_padrao = [dp, dpAG, dpBat, dpFpa, dpCuckoo];
disp('#---------------# Desvio padrao #---------------#')
disp('    default     AG     BAT    FPA    CS')
disp(resultado_desvio_padrao)
disp('#-----------------------# Parametros #-----------------------#')
disp(['          Default = ', num2str(x0)]);
disp(['    Otimizados AG = ', num2str(xAG)]);
disp(['Otimizados Cuckoo = ', num2str(xCuckoo)]);
disp(['   Otimizados BAT = ', num2str(xBat)]);
disp(['   Otimizados FPA = ', num2str(xFpa)]);
disp('-------------------------------------------------------------------')
end
end

figure %Route1
box on
semilogx(coluna1R1, coluna2R1, '*', 'LineWidth', 2,'color',[0, 0.4470, 0.7410]);% dados medidos com a distancia.
hold all
plot(coluna1R1,     LSUI1,   '+' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R1,     LECC1,  '-.' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R1,      LFI1,  '--' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R1,   LUFPA1,  ':' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes

plot(coluna1R1,  LAG_SUI1,  '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R1, LBAT_SUI1, '--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R1, LFPA_SUI1, '--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R1,  LCS_SUI1, '--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot(coluna1R1,  LAG_ECC1,  '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R1, LBAT_ECC1, '--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R1, LFPA_ECC1, '--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R1,  LCS_ECC1, '--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(coluna1R1,   LAG_FI1,  '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R1,  LBAT_FI1, '--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R1,  LFPA_FI1, '--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R1,   LCS_FI1, '--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(coluna1R1, LAG_UFPA1,  '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R1,LBAT_UFPA1, '--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R1,LFPA_UFPA1, '--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R1, LCS_UFPA1, '--d' ,'LineWidth', 1, 'color',[0 0 0.9]); 

grid on
set(gca,'FontSize',22)
title('ROTA 1');
xlim([0 800]);
%leg = legend('Measured', 'SUI C', 'ECC C', 'FI C', 'SUI A', 'SUI B', 'SUI F', 'ECC A', 'ECC B', 'ECC F', 'FI A', 'FI B', 'FI F');
%leg.FontSize = 16;
xlabel('Distancia (m)');
ylabel('Path Loss (dB)');

load('/Users/andrepacheco/Documents/MATLAB/otimizacao/dadosnovos.mat');
d = 120:4:max(data(:,1));

figure %Route2
box on
a1 = semilogx(coluna1R2, coluna2R2, '*', 'LineWidth', 2,'color',[0, 0.4470, 0.7410]);% dados medidos com a distancia.
a2 = semilogx(d, CII, '*', 'LineWidth', 1,'color',[0, 0.4470, 0.7410]);
hold all
a3 = plot(coluna1R2,     LSUI2,   '+' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
a4 = plot(coluna1R2,     LECC2,  '-.' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
a5 = plot(coluna1R2,      LFI2,  '--' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
a6 = plot(coluna1R2,    LUFPA2,  ':'  ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes

 a7 = plot(coluna1R2,  LAG_SUI2,  '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
 a8 = plot(coluna1R2, LBAT_SUI2, '--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
 a9 = plot(coluna1R2, LFPA_SUI2, '--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
a10 = plot(coluna1R2,  LCS_SUI2, '--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

a11 = plot(coluna1R2,  LAG_ECC2,  '-^' ,'LineWidth', 1, 'color',[0 1 1]);
a12 = plot(coluna1R2, LBAT_ECC2, '--o' ,'LineWidth', 1, 'color',[0 1 1]);
a13 = plot(coluna1R2, LFPA_ECC2, '--x' ,'LineWidth', 1, 'color',[0 1 1]);
a14 = plot(coluna1R2,  LCS_ECC2, '--d' ,'LineWidth', 1, 'color',[0 1 1]);

a15 = plot(coluna1R2,   LAG_FI2,  '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
a16 = plot(coluna1R2,  LBAT_FI2, '--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
a17 = plot(coluna1R2,  LFPA_FI2, '--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
a18 = plot(coluna1R2,   LCS_FI2, '--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

a19 = plot(coluna1R2, LAG_UFPA2,  '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
a20 = plot(coluna1R2,LBAT_UFPA2, '--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
a21 = plot(coluna1R2,LFPA_UFPA2, '--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
a22 = plot(coluna1R2, LCS_UFPA2, '--d' ,'LineWidth', 1, 'color',[0 0 0.9]);
grid on
set(gca,'FontSize',22)
title('ROTA 2');
xlim([180 800]);
% axis([0 800]);
%leg = legend('Measured', 'SUI C', 'ECC C', 'FI C', 'SUI A', 'SUI B', 'SUI F', 'ECC A', 'ECC B', 'ECC F', 'FI A', 'FI B', 'FI F');
%leg.FontSize = 16;
xlabel('Distancia (m)');
ylabel('Path Loss (dB)');

figure %Route3
box on
semilogx(coluna1R3, coluna2R3, '*', 'LineWidth', 2,'color',[0, 0.4470, 0.7410]);% dados medidos com a distancia.
hold all
plot(coluna1R3,     LSUI3,   '+' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R3,     LECC3,  '-.' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R3,      LFI3,  '--' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R3,    LUFPA3,  ':' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes

plot(coluna1R3,  LAG_SUI3,  '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R3, LBAT_SUI3, '--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R3, LFPA_SUI3, '--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R3,  LCS_SUI3, '--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot(coluna1R3,  LAG_ECC3,  '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R3, LBAT_ECC3, '--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R3, LFPA_ECC3, '--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot(coluna1R3,  LCS_ECC3, '--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(coluna1R3,   LAG_FI3,  '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R3,  LBAT_FI3, '--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R3,  LFPA_FI3, '--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R3,   LCS_FI3, '--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(coluna1R3, LAG_UFPA3,  '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R3,LBAT_UFPA3, '--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R3,LFPA_UFPA3, '--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(coluna1R3, LCS_UFPA3, '--d' ,'LineWidth', 1, 'color',[0 0 0.9]); 
grid on
set(gca,'FontSize',22)
title('ROTA 3');
xlim([0 800]);
%leg = legend('Measured', 'SUI C', 'ECC C', 'FI C', 'SUI A', 'SUI B', 'SUI F', 'ECC A', 'ECC B', 'ECC F', 'FI A', 'FI B', 'FI F');
%leg.FontSize = 16;
xlabel('Distancia (m)');
ylabel('Path Loss (dB)');

figure %Route4
box on
semilogx(coluna1R4, coluna2R4, '*', 'LineWidth', 2,'color',[0, 0.4470, 0.7410]);% dados medidos com a distancia.
hold all
plot(coluna1R4,     LSUI4,   '+' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R4,     LECC4,  '-.' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R4,      LFI4,  '--' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes
plot(coluna1R4,    LUFPA4,  ':' ,'LineWidth', 1, 'color',[0.85 0 0]); % sem ajustes

plot(coluna1R4,  LAG_SUI4,  '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R4, LBAT_SUI4, '--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R4, LFPA_SUI4, '--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(coluna1R4,  LCS_SUI4, '--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot(coluna1R4,  LAG_ECC4,  '-^' ,'LineWidth', 1, 'color',[0 0.8 1]);
plot(coluna1R4, LBAT_ECC4, '--o' ,'LineWidth', 1, 'color',[0 0.8 1]);
plot(coluna1R4, LFPA_ECC4, '--x' ,'LineWidth', 1, 'color',[0 0.8 1]);
plot(coluna1R4,  LCS_ECC4, '--d' ,'LineWidth', 1, 'color',[0 0.8 1]);

plot(coluna1R4,   LAG_FI4,  '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R4,  LBAT_FI4, '--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R4,  LFPA_FI4, '--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(coluna1R4,   LCS_FI4, '--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(coluna1R4, LAG_UFPA4,  '-^' ,'LineWidth', 1, 'color',[0 0 0.8]);
plot(coluna1R4,LBAT_UFPA4, '--o' ,'LineWidth', 1, 'color',[0 0 0.8]);
plot(coluna1R4,LFPA_UFPA4, '--x' ,'LineWidth', 1, 'color',[0 0 0.8]);
plot(coluna1R4, LCS_UFPA4, '--d' ,'LineWidth', 1, 'color',[0 0 0.8]); 
grid on
set(gca,'FontSize',22)
title('ROTA 4');
xlim([0 800]);
leg = legend('Medidas', 'SUI Original', 'ECC Original', 'FI Original', 'UFPA Original', 'SUI AG', 'SUI BAT', 'SUI FPA', 'SUI CS', 'ECC AG', 'ECC BAT', 'ECC FPA','ECC CS', 'FI AG', 'FI BAT', 'FI FPA', 'FI CS', 'UFPA AG', 'UFPA BAT', 'UFPA FPA','UFPA CS');
%leg = legend('Measured', 'SUI C', 'ECC C', 'FI C', 'SUI A', 'SUI B', 'SUI F', 'ECC A', 'ECC B', 'ECC F', 'FI A', 'FI B', 'FI F');
leg.FontSize = 16;
xlabel('Distancia (m)');
ylabel('Path Loss (dB)');

figure %Route 1%
box on
hold all
plot( fitAG_SUI1, '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitBAT_SUI1,'--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitFPA_SUI1,'--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot( fitCS_SUI1,'--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot( fitAG_ECC1, '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitBAT_ECC1,'--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitFPA_ECC1,'--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot( fitCS_ECC1,'--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(  fitAG_FI1, '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitBAT_FI1,'--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitFPA_FI1,'--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(  fitCS_FI1,'--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(  fitAG_UFPA1, '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitBAT_UFPA1,'--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitFPA_UFPA1,'--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(  fitCS_UFPA1,'--d' ,'LineWidth', 1, 'color',[0 0 0.9]);
xlabel('iteracoes')
ylabel('RMSE')
grid on
set(gca,'FontSize',20)
%leg = legend(' AG-SUI',' BAT-SUI',' FPA-SUI', ' AG-ECC',' BAT-ECC',' FPA-ECC',' AG-FI',' BAT-FI',' FPA-FI');
 leg = legend('SUI AG', 'SUI BAT', 'SUI FPA', 'SUI CS','ECC AG', 'ECC BAT', 'ECC FPA', 'ECC CS', 'FI AG', 'FI BAT', 'FI FPA', 'FI CS', 'UFPA AG', 'UFPA BAT', 'UFPA FPA', 'UFPA CS');
% leg.FontSize = 16;
title('FITNESS ROTA 1');
xlim([0 60]);
ylim([0 30]);

figure %Route 2%
box on
hold all
plot( fitAG_SUI2, '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitBAT_SUI2,'--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitFPA_SUI2,'--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot( fitCS_SUI2,'--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot( fitAG_ECC2, '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitBAT_ECC2,'--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitFPA_ECC2,'--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot( fitCS_ECC2,'--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(  fitAG_FI2, '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitBAT_FI2,'--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitFPA_FI2,'--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(  fitCS_FI2,'--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(  fitAG_UFPA2, '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitBAT_UFPA2,'--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitFPA_UFPA2,'--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(  fitCS_UFPA2,'--d' ,'LineWidth', 1, 'color',[0 0 0.9]);
xlabel('iiteracoes')
ylabel('RMSE')
grid on
set(gca,'FontSize',20)
% leg = legend(' AG-SUI',' BAT-SUI',' FPA-SUI', ' AG-ECC',' BAT-ECC',' FPA-ECC',' AG-FI',' BAT-FI',' FPA-FI');
% leg = legend('SUI AG', 'SUI BAT', 'SUI FPA', 'ECC AG', 'ECC BAT', 'ECC FPA', 'FI AG', 'FI BAT', 'FI FPA');
% leg.FontSize = 16;
title('FITNESS ROTA 2');
xlim([0 60]);
ylim([0 30]);

figure %Route 3%
box on
hold all
plot( fitAG_SUI3, '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitBAT_SUI3,'--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitFPA_SUI3,'--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot( fitCS_SUI3,'--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot( fitAG_ECC3, '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitBAT_ECC3,'--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitFPA_ECC3,'--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot( fitCS_ECC3,'--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(  fitAG_FI3, '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitBAT_FI3,'--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitFPA_FI3,'--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(  fitCS_FI3,'--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(  fitAG_UFPA3, '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitBAT_UFPA3,'--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitFPA_UFPA3,'--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(  fitCS_UFPA3,'--d' ,'LineWidth', 1, 'color',[0 0 0.9]);
xlabel('iteracoes')
ylabel('RMSE')
grid on
set(gca,'FontSize',20)
% leg = legend(' AG-SUI',' BAT-SUI',' FPA-SUI', ' AG-ECC',' BAT-ECC',' FPA-ECC',' AG-FI',' BAT-FI',' FPA-FI');
% leg = legend('SUI AG', 'SUI BAT', 'SUI FPA', 'ECC AG', 'ECC BAT', 'ECC FPA', 'FI AG', 'FI BAT', 'FI FPA');
% leg.FontSize = 16;
title('FITNESS ROTA 3');
xlim([0 60]);
ylim([0 30]);

figure %Route 4%
hold all
box on
plot( fitAG_SUI4, '-^' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitBAT_SUI4,'--o' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot(fitFPA_SUI4,'--x' ,'LineWidth', 1, 'color',[0.9 0.8 0]);
plot( fitCS_SUI4,'--d' ,'LineWidth', 1, 'color',[0.9 0.8 0]);

plot( fitAG_ECC4, '-^' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitBAT_ECC4,'--o' ,'LineWidth', 1, 'color',[0 1 1]);
plot(fitFPA_ECC4,'--x' ,'LineWidth', 1, 'color',[0 1 1]);
plot( fitCS_ECC4,'--d' ,'LineWidth', 1, 'color',[0 1 1]);

plot(  fitAG_FI4, '-^' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitBAT_FI4,'--o' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot( fitFPA_FI4,'--x' ,'LineWidth', 1, 'color',[0 0.5 0]);
plot(  fitCS_FI4,'--d' ,'LineWidth', 1, 'color',[0 0.5 0]);

plot(  fitAG_UFPA4, '-^' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitBAT_UFPA4,'--o' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot( fitFPA_UFPA4,'--x' ,'LineWidth', 1, 'color',[0 0 0.9]);
plot(  fitCS_UFPA4,'--d' ,'LineWidth', 1, 'color',[0 0 0.9]);
xlabel('iteracoes')
ylabel('RMSE')
grid on
set(gca,'FontSize',20)
% leg = legend(' AG-SUI',' BAT-SUI',' FPA-SUI', ' AG-ECC',' BAT-ECC',' FPA-ECC',' AG-FI',' BAT-FI',' FPA-FI');
% leg = legend('SUI AG', 'SUI BAT', 'SUI FPA', 'ECC AG', 'ECC BAT', 'ECC FPA', 'FI AG', 'FI BAT', 'FI FPA');
% leg.FontSize = 16;
title('FITNESS ROTA 4');
xlim([0 60]);
ylim([0 30]);

