function [Us, TU] = StartUser(U, X, Y)



D = [0.90 0.69 0.56 0.48 0.39 0.29 0.20 0.15 0.14 0.17 0.30 0.57...
    0.87 0.92 0.73 0.61 0.74 0.89 0.85 0.75 0.72 0.81 0.96 1]; % Distribuição dos usuários 





T = 400 * 1024; % Taxa Requerida --> 400 Kbps
a = 1;


for j = 1:24
    UN = U * D(j); % NY
    TU(j) = UN;
    for i = 1:UN % Criação de usuários.
        Us(a) = User;
%         Us(a).X = 150 + (X(1,2) - 300) * rand(1);
%         Us(a).Y = 150 + (Y(1,2) - 300) * rand(1);
        
        Us(a).X = rand(1) * X(1,2);
        Us(a).Y = rand(1) * Y(1,2);
        Us(a).R_DR = T;
        Us(a).M = j;
        a = a + 1;
    end
end




end

