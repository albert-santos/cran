classdef  StationBase
    
    properties
        ID; % Identidade
        X; % Posição no eixo X
        Y; % Posição no eixo Y
        RP; % Potência de transmissão
        Fr; % Frequência
        B; % Banda Total
        U; % Total de Usuários
        VU; % Usuarios Conectados
        D; % Estação base conectada?
        PRB; % Total de PRBs
        PRB_F; % Total de PRBs disponiveis 
        F = false; % "FAPS"? -----------------------
        C; % Check? ----------------------------
        I; % Implantação?; ----------------------------
        Cob; % Área de cobertura
        H; % Atura
        Int;
        UB;%Usuários bloqueados pela micro
        
    end
    
    methods
    end
    
end

