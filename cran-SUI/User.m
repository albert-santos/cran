classdef User
    
    properties
        ID; % Identidade
        X; % Posi��o no eixo X 
        Y; % Posi��o no eixo Y 
        DR = 0; % Taxa de dados 
        R_DR; % Taxa de dados requerida
        EB = 0; % Esta��o base 
        PRB = 0; % Total de PRBs 
        CQI = 0; % Indicador de Qualidade do Canal 
        SINR = 0; % Rela��o Sinal/Ruido
        C = false; %  Usuario conectado?
        V; % Velocidade
        M; % Momento.
        ES = 0; % 1 = Micro || 2 == Macro
        EBC; %Smalls Candidatas para conex�o
        Int; %Interfer�ncia
    end
    
    methods
    end
    
end

