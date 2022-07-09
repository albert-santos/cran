function [Saida] = CalculoResults(Us1, S1)

U = size(Us1,2);

Saida = zeros(1,10);

DR1 = 0; 
MDR1 = 0; 

T1 = [inf -inf];


MT1 = [inf -inf];

for i = 1:U

    if (Us1(i).C == true)
        Saida(1) = Saida(1) + 1;
    else
        Saida(2) = Saida(2) + 1;
    end

    DR1 = DR1 + Us1(i).DR;

    if (Us1(i).ES == 1)
        MDR1 = MDR1 + Us1(i).DR;
    end

    if(Us1(i).DR < T1(1))
       T1(1) = Us1(i).DR;
    end  
    if(Us1(i).DR > T1(1))
       T1(2) = Us1(i).DR;
    end

    if(Us1(i).DR < MT1(1) && Us1(i).ES == 1)
       MT1(1) = Us1(i).DR;
    end
    
    if(Us1(i).DR > MT1(1) && Us1(i).ES == 1)
       MT1(2) = Us1(i).DR;
    end
      
end



Saida(3) = round(DR1/U);
Saida(4) = round(T1(1));
Saida(5) = round(T1(2));
Saida(6) = round(MDR1/U);
Saida(7) = round(MT1(1));
Saida(8) = round(MT1(2));



%  1 = Usuarios Cobertos
%  2 = Usuarios Não Cobertos 
%  3 = Media DR Usuários (Geral)
%  4 = DR minimo Usuários 
%  5 = DR maximo Usuários 
%  6 = Média DR Usários (Micro-Conectados)
%  7 = DR minimo Usuários (Micro)
%  8 = DR maximo Usuários (Micro)
%  9 = Micros ligadas 
% 10 = Usuários Conectados (Micro)

X = length(S1);


for i = 1:X
    if (S1(i).D == 1)
        Saida(9) = Saida(9) + 1;
    end
end


for i = 1:U

    if (Us1(i).C == true && Us1(i).ES == 1)
        Saida(10) = Saida(10) + 1;
    end    
end


end