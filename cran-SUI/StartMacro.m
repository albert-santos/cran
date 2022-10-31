function [MC] = StartMacro(M, X, Y)



Px = X(1,2) / 2;
Py = Y(1,2) / 2;

Cont = 1;
for i = 1:M
    for j = 1:M
        
        MC(Cont) = StationBase;
        MC(Cont).ID = Cont;
        MC(Cont).X = Px(i);
        MC(Cont).Y = Py(j);
        MC(Cont).RP = 49; % dBm
        MC(Cont).Fr = 1.8e9; % Frequência em GHz
        MC(Cont).D = true;
        MC(Cont).PRB = 100;
        MC(Cont).PRB_F = 100;
        MC(Cont).B = 20e6; % 18MHz
        MC(Cont).C = 0;
        MC(Cont).Cob = 1000; % Metros (Euclidiana)
        MC(Cont).H = 40;
        
        Cont = Cont + 1;
    end
end





end

