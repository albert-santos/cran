function [DR, CQI, SINR, I] = CalculateChannel(U, S, Small)

   
D = (((U.X - S.X)^2) + ((U.Y - S.Y)^2))^0.5;  %Distancia de Euclides

if (D <= S.Cob && S.D)
    
    a = 4.0;
    b = 0.0065;
    c = 17.1;
    Hb = S.H;
    Hr = 1.6;
    d0 = 100;
    lambda = 3e8/S.Fr;
    frequency_Mhz = S.Fr*1e-6;
    
    
 
    A = 20 * log10( 4*pi*d0/lambda);
    Y = a - b*Hb + (c/Hb);
    Xf = 6*log10(frequency_Mhz/2000);
    Xh = -10.8*log(Hr/2);
    
    L_SUI = A + 10*Y*log10(D/d0) + Xf + Xh;
    
    WN = 7.4e-13; % Ru�do Branco (CORRIGIR)
    I = 0; % Interferencia gerada por outras c�lulas

    D0 = 100; % Dist�ncia Refer�ncia
    Sv = 9.4; % 8.2 to 10.6 dB ==> 
    V = 3e8; % Velocidade da luz (m/s) no vacuo
    L = V / S.Fr; % Lambda
    Hr = 1.6; % Altura de recep��o
    Hb = S.H; % Altura da Esta��oBase,
    E = 16; % Equalizado

    % Par�metros Cen�rio SUI tipo C
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

