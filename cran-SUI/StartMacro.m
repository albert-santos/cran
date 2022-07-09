function [MC] = StartMacro(M)



Px = [250];
Py = [250];

Cont = 1;
for i = 1:M
    for j = 1:M
        
        MC(Cont) = StationBase;
        MC(Cont).ID = Cont;
        MC(Cont).X = Px(i);
        MC(Cont).Y = Py(j);
        MC(Cont).RP = 43; % dBm
        MC(Cont).Fr = 3.5e9; % 3.5 GHz
        MC(Cont).D = true;
        MC(Cont).PRB = 10;
        MC(Cont).PRB_F = 10;
        MC(Cont).B = 18e6; % 18MHz
        MC(Cont).C = 0;
        MC(Cont).Cob = 1000; % Metros (Euclidiana)
        MC(Cont).H = 20;
        
        Cont = Cont + 1;
    end
end





end

