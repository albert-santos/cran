classdef  StationBase
    
    properties
        ID; % Identidade
        X; % Posi��o no eixo X
        Y; % Posi��o no eixo Y
        RP; % Pot�ncia de transmiss�o
        Fr; % Frequ�ncia
        B; % Banda Total
        U; % Total de Usu�rios
        VU; % Usuarios Conectados
        D; % Esta��o base conectada?
        PRB; % Total de PRBs
        PRB_F; % Total de PRBs disponiveis 
        F = false; % "FAPS"? -----------------------
        C; % Check? ----------------------------
        I; % Implanta��o?; ----------------------------
        Cob; % �rea de cobertura
        H; % Atura
        Int;
        UB;%Usu�rios bloqueados pela micro
        
    end
    
    methods
    end
    
end

