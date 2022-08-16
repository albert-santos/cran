function [DR, CQI, SINR, I] = CalculateChannel(U, S, Small)

% teste
D = (((U.X - S.X)^2) + ((U.Y - S.Y)^2))^0.5;  %Distancia de Euclides

if (D <= S.Cob && S.D)

    WN = 7.4e-13; % Ru�do Branco (CORRIGIR)
    I = 0; % Interferencia gerada por outras c�lulas    
    
    
    D0 = 100; % Dist�ncia Refer�ncia
    Sv = 9.4; % 8.2 to 10.6 dB ==> 
    V = 3e8; % Velocidade da luz (m/s) no vacuo
    L = V / S.Fr; % Lambda
    Hr = 1.2; % Altura de recep��o
    Hb = S.H; % Altura da Esta��oBase,
    E = 16; % Equalizado
    
    
    % ---------------Jasmine Model --------------------------
    
    % Frequ�ncia em GHz
    frequency_GHz = 2.6;
    % Dist�ncia (km) entre a antena receptora e a antena transmissora
    distance_km = D * 1e-3;
    
    Afs = 92.4 + 20*log10(distance_km) + 20*log10(frequency_GHz);
    Abm = 23.11 + 10*log10(distance_km) + 1.810*log10(frequency_GHz) + 8.50*(log10(frequency_GHz) * log10(frequency_GHz));
    Gb = log10(Hb/200) * (13.958 + 5.8*(log10(frequency_GHz) * log10(frequency_GHz)));
    Gr = (42.57 + 13.7*log10(frequency_GHz) ) * (log10(Hr) - 0.585);

    Lost = Afs + Abm - Gb - Gr;
    
    
    
    
%     % Par�metros Cen�rio SUI
%     a = 3.6;
%     b = 0.005;
%     c = 20;
% 
% 
%     A = 20 * log10( 4*pi*D0/L ); 
%     Y = ( a- ( b*Hb )) + ( c/Hb );
% 
%     Lost = A + 10*Y*log10( D/D0 )+ Sv - E; % Perda no Canal


    Pw = 10^((S.RP - Lost)/10)/1000;
    for i = 1:length(Small) % calculate intercell interference

        if(Small(i).D && Small(i).ID ~= S.ID)
            antennas_distance = 1e-3 * ( (((Small(i).X - U.X)^2) + ((Small(i).Y - U.Y)^2))^0.5);
            Antennas_Afs = 92.4 + 20*log10(antennas_distance) + 20*log10(frequency_GHz);
            Antennas_Abm = 23.11 + 10*log10(antennas_distance) + 1.810*log10(frequency_GHz) + 8.50*(log10(frequency_GHz) * log10(frequency_GHz));
            
            Antenna_Lost = Small(i).RP - (Antennas_Afs + Antennas_Abm - Gb - Gr);
            I = I + (10^(Antenna_Lost/10))/1000;
        end

    end
    
    %I = 0; % Considerar apenas ru�do branco
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

