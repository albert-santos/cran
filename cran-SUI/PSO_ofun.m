function [OF] = PSO_ofun (population, User, number_of_BBUs)


  y = randperm (100,number_of_BBUs);
        
  
%  for i = 1:size(y,2)
%      
%       rrh_user(y(i)) =  (rrh_user(y(i)) * 0.1) + (rrh_user(y(i))); 
%      
%   end




Media = sum(User)/number_of_BBUs;

for i = 1:length(population)
    Setor = zeros([1 number_of_BBUs]);
    X = 0;
    for j = 1:size(population,2)
        aux = population(i,j);
        Setor(aux) = Setor(aux) + User(j);
    end
    for k = 1:number_of_BBUs
        X = X + abs(Setor(k)- Media);
        if Setor(k) > 200
           X = X + Setor(k) - 200; 
        end
    end
    OF(i) = X;
end
