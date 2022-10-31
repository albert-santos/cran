function [DR, CQI, SINR, I] = CalculateChannel(U, S, Small)

   
D = (((U.X - S.X)^2) + ((U.Y - S.Y)^2))^0.5;  %Distancia de Euclides

if (D <= S.Cob && S.D)

    WN = 7.4e-13; % Ru�do Branco (CORRIGIR)
    I = 0; % Interferencia gerada por outras c�lulas    
    
    
    Hr = 1.6; % Altura de recep��o
    Hb = S.H; % Altura da Esta��oBase,
    
    
    % ---------------Jasmine Model --------------------------
    
    % Frequ�ncia em GHz
    frequency_GHz = S.Fr / 1e9;
    % Dist�ncia (km) entre a antena receptora e a antena transmissora
    distance_km = D * 1e-3;
    
%     frequency_GHz = 1.8;
%     distance_km = 0.258891812574609;
%     Hb = 40;
    
    Afs = 92.4 + 20*log10(distance_km) + 20*log10(frequency_GHz);
    Abm = 28.33 + 1.27*log10(distance_km) + 6.910*log10(frequency_GHz) + 1.80*(log10(frequency_GHz)^2);
%     Abm = 20.41 + 9.83*log10(distance_km) + 7.894*log10(frequency_GHz) + 9.56*(log10(frequency_GHz)^2);
    Gb = 13 - (log10(Hb/200) * (13.958 + 5.8*(log10(distance_km)^2)));
    Gr = 0.759*Hr - 1.862;
    
%     Gb2 = log10(Hb/200) * (13.958 + (5.8*2*(log10(distance_km))));
%       Gr2 = 0.759*Hr - 1.862; 

    
%     fprintf('Gb1 =  %f \n ', Gb);
%     fprintf('Gb2 =  %f \n ', Gb2);
    
    
    Lost = Afs + Abm - Gb - Gr;

    Pw = 10^((S.RP - Lost)/10)/1000;
    for i = 1:length(Small) % calculate intercell interference

        if(Small(i).D && Small(i).ID ~= S.ID)
            antennas_distance = 1e-3 * ( (((Small(i).X - U.X)^2) + ((Small(i).Y - U.Y)^2))^0.5);
            Antennas_Afs = 92.4 + 20*log10(antennas_distance) + 20*log10(frequency_GHz);
            Antennas_Abm = 28.33 + 1.27*log10(distance_km) + 6.910*log10(frequency_GHz) + 1.80*(log10(frequency_GHz) * log10(frequency_GHz));
            
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

