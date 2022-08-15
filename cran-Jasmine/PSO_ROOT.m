function [users_by_sector, mapping_rrh_bbu_sectors] = PSO_ROOT(users_by_micros, number_of_BBUs, number_of_RRHs)


format 'long';

hours = 24;


for i = 1:hours

    [Result, GBest, BBUL, RRHs_by_BBU] = PSO_main (users_by_micros(i,:), number_of_BBUs, number_of_RRHs);   
    
    %time_PSO(i) = tg;
    SA_OF(i,:) = Result(1,:);
    % A qual BBU cada RRH está alocada
    mapping_rrh_bbu_sectors(i,:) = GBest(1,:);
    % Quantidade de usuários em cada BBU
    users_by_sector(i,:)= BBUL(1,:);
    rrhs_by_sectors(i,:) = RRHs_by_BBU(1,:);


end 

%timeM = sum(time_PSO)/sim;
SA_OFM = sum(SA_OF)/hours;

