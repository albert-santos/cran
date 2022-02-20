classdef User
    
    properties
        ID; % Identidade
        X; % Posição no eixo X 
        Y; % Posição no eixo Y 
        DR = 0; % Taxa de dados 
        R_DR; % Taxa de dados requerida
        EB = 0; % Estação base 
        PRB = 0; % Total de PRBs 
        CQI = 0; % Indicador de Qualidade do Canal 
        SINR = 0; % Relação Sinal/Ruido
        C = false; %  Usuario conectado?
        V; % Velocidade
        M; % Momento.
        ES = 0; % 1 = Micro || 2 == Macro
        EBC; %Smalls Candidatas para conexão
        Int; %Interferência
    end
    
    methods
    end
    
end

