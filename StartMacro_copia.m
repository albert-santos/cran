function [MC] = StartMacro_copia(M)



Px = [400];
Py = [400];

Cont = 1;
for i = 1:M
    for j = 1:M
        
        MC(Cont) = StationBase_copia;
        MC(Cont).ID = Cont;
        MC(Cont).X = Px(i);
        MC(Cont).Y = Py(j);
        MC(Cont).RP = 43; % dBm
        MC(Cont).Fr = 3.5e9; % 3.5 GHz
        MC(Cont).D = true;
        MC(Cont).PRB = 3;
        MC(Cont).PRB_F = 3;
        MC(Cont).B = 18e6; % 18MHz
        MC(Cont).C = 0;
        MC(Cont).Cob = 4000; % Metros (Euclidiana)
        MC(Cont).H = 20;
        
        Cont = Cont + 1;
    end
end





end

