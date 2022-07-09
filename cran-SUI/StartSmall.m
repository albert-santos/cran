function [SC] = StartSmall(S, X, Y)


Px = linspace(X(1,1), X(1,2), S); % Contria um vetor de 10 posições com valores entre Xmin e Xmax
Py = linspace(Y(1,1), Y(1,2), S); % Contria um vetor de 10 posições com valores entre Ymin e Ymax



Cont = 1; %Contontador para preencher as Small
for i = 1:S
    for j = 1:S
        
        SC(Cont) = StationBase;
        SC(Cont).ID = Cont;
        SC(Cont).X = Px(i);
        SC(Cont).Y = Py(j);
        SC(Cont).RP = 33; % dBm 
        SC(Cont).Fr = 2.4e9; % 2.4 GHz
        SC(Cont).D = true;
        SC(Cont).PRB = 50;
        SC(Cont).PRB_F = 50;
        SC(Cont).B = 18e6; % 18 MHz 
        SC(Cont).C = 0;
        SC(Cont).Cob = 150; % Metros (Euclidiana)
        SC(Cont).H = 16;
        SC(Cont).UB = 0; % Usuários bloqueados
        SC(Cont).Int = 0; % Interferencia
        
        Cont = Cont + 1;
        
    end
end


end

