function [Us, Small] = NearbySmalls(Us, Small)

    S = length(Small);
    U = length (Us);
   
    
    for i = 1:U
        for j = 1:S
                   [DR(i,j), CQI(i,j), SINR(i,j), I(j,i)] = CalculateChannel(Us(i), Small(j), Small);  
        end
    end   % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small

    
    cont = 0;
    for j=1:S
        for i=1:U
           cont = cont + I(j,i); 
        end
       Small(j).Int = cont;
       cont = 0;   
    end
    
    A=1;
    for i=1:U
        a = 1;
        for j=1:S
                if DR(i,j) ~= 0
                    A(a, 1) = j;
                    A(a,2) = DR(i,j);
                    a = a + 1;
                end
        end
        if ~isempty(A)
            for k=1:size(A,1)
                Us(i).EBC(k)=A(k,1);
            end
        end
    end % Cálculo das Small Candidatas de cada usuário
    
    
end