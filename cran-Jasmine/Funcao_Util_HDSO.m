function [V21] = Funcao_Util_HDSO(Small, V21)
    T = length(Small);
    TS = length(V21);
    
    E = 0.3;
    B = 0.6;
    G = 0.1;
    
    for i=1:T
        Interferencias(i) = Small(i).Int;
        
        N_served = Small(i).U;
        N_blocked = Small(i).UB;
        if N_served ~= 0
            W_aux = N_served^(0.01 - (N_blocked/(N_served + N_blocked)));
            W(i) = W_aux;
        else
            W(i)= 0;
        end
    end
    
    
    [DR_Maximo] = max(V21(:,4));
    [Int_Maxima] = max(Interferencias);
    [W_Max] = max(W);
    
    for i=1:T
        traffic_load = (Small(i).PRB - Small(i).PRB_F);
        traffic_load_max = Small(i).PRB;
        
        DR = V21(i,4);
        I = Small(i).Int;
        Y = (E*(DR/DR_Maximo) + B*(traffic_load/traffic_load_max));
        X = (I/Int_Maxima);
        
        if (I/Int_Maxima)~= 0
            V21(i,5) = (E*(DR/DR_Maximo) + B*(traffic_load/traffic_load_max) + G*(W(i)/W_Max)) / (I/Int_Maxima);
        else
            V21(i,5) = 0;
        end
    end
  
end

