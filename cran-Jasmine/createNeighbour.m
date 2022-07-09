% Author: Seyedali Mirjalili
% www.alimirjalili.com
% https://scholar.google.com/citations?user=TJHmrREAAAAJ&hl=en

function [B] = createNeighbour(A)

    index=randsample(length(A),2);
    
    i=index(1);
    j=index(2);
    
    B = A;
    B(i,:) = A(j,:);
    B(j,:) = A(i,:); 
end