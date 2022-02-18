function [DR, CQI, SINR, I] = CalculateChannel_copia(U, S, Small)

   
D = (((U.X - S.X)^2) + ((U.Y - S.Y)^2))^0.5;  %Distancia de Euclides

if (D <= S.Cob && S.D)

    WN = 7.4e-13; % Ruído Branco (CORRIGIR)
    I = 0; % Interferencia gerada por outras células

    D0 = 100; % Distância Referência
    Sv = 9.4; % 8.2 to 10.6 dB ==> 
    V = 3e8; % Velocidade da luz (m/s) no vacuo
    L = V / S.Fr; % Lambda
    Hr = 1.2; % Altura de recepção
    Hb = S.H; % Altura da EstaçãoBase,
    E = 16; % Equalizado

    % Parâmetros Cenário SUI
    a = 3.6;
    b = 0.005;
    c = 20;


    A = 20 * log10( 4*pi*D0/L ); 
    Y = ( a- ( b*Hb )) + ( c/Hb );

    Lost = A + 10*Y*log10( D/D0 )+ Sv - E; % Perda no Canal


    Pw = 10^((S.RP - Lost)/10)/1000;

    for i = 1:length(Small) % calculate intercell interference

        if(Small(i).D && Small(i).ID ~= S.ID)
            Da = (((Small(i).X - U.X)^2) + ((Small(i).Y - U.Y)^2))^0.5;
            LostA = Small(i).RP - (A + 10*Y*log10 (Da/D0)+ Sv - E);
            I = I + (10^(LostA/10))/1000;
        end

    end
    
    %I = 0; % Considerar apenas ruído branco
    SINR = (Pw / (WN + I));

    C = S.B / S.PRB;
    DR = (C * log2(1+SINR)); % Datarate com apenas 1 PRB sendo usado.
    CQI = round(1 + ((7/13)*(SINR+6)));

else
    
    SINR = 0;
    DR = 0;
    CQI = 0;
    I= 0;


end


end

