function [Us, Small] = ConexaoUs_alt(Us, Small)

  S = length(Small);
  U = length (Us);
   
    
    for i = 1:U
        for j = 1:S
                   [DR(i,j), CQI(i,j), SINR(i,j)] = CalculateChannel(Us(i), Small(j), Small);  
        end
    end   % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small

    
    % Identificando a quantidade PRB requisitadas por cadas usuário
    % A prioridade de conexão será primeiro para os usuários que demandam
    % poucos PRB, ou seja, cujo sinal possue maior qualidade
    for  i=1:U
        
        [T, ~] = max(DR(i,:)); 
        PR = ceil(Us(i).R_DR/T);
        number_of_prbs_requested_by_users(i,1) = i;
        number_of_prbs_requested_by_users(i,2) = PR;
        
    end
    % Organizando em ordem crescente pela quantidade de PRB requisitados de cada usuário
    number_of_prbs_requested_by_users =  sortrows(number_of_prbs_requested_by_users, 2);
    
    
    
    for user_index = 1:U
        aux = 0;
        
        i = number_of_prbs_requested_by_users(user_index,1);
        
     if (Us(i).C == false)
        
      while  aux == 0
          [T, Ind] = max(DR(i,:)); 
          PR = ceil(Us(i).R_DR/T);
          
          if (Small(Ind).PRB_F >= PR)
                Us(i).DR = T * PR;
                Us(i).PRB = PR;
                Us(i).EB = Ind;
                Us(i).ES = 1;
                Us(i).CQI = CQI(i,Ind);
                Us(i).SINR = SINR(i,Ind);
                Us(i).C = true;
                aux = 1;
                Small(Ind).PRB_F = Small(Ind).PRB_F - PR;
          else
              DR(i,Ind) = 0;
          end
      
          if (T == 0)
                 
                Us(i).DR = 0;
                Us(i).PRB = 0;
                Us(i).EB = 0;
                Us(i).CQI = 0;
                Us(i).SINR = 0;
                Us(i).C = false;
                aux = 1;
          end
      
      end
     end
      
      
    end  % Conecta os usuários 
    
    
   for j = 1:S
     cont = 1;  
     Small(j).VU = [];
     for i = 1:U
        if (Us(i).EB == j && Us(i).ES==1)
            Small(j).VU(cont) = i;
            cont = cont + 1;
        end 
     end
            
            Small(j).U = length(Small(j).VU);
   end





end




% 
% 
% function [Us, Small] = ConexaoUs_alt(Us, Small)
% 
%     
%     U = length (Us); 
%     
%     for i = 1:U
%         S = length(Us(i).EBC);% Quantidade de Smalls Candidatas que o usuário pode se conectar
%         for j = 1:S
%             Id_Small = Us(i).EBC(j);
%             if  Id_Small ~= 0
%                    [DR(i,j), CQI(i,j), SINR(i,j), I(j,i)] = CalculateChannel(Us(i), Small(Id_Small), Small);
%                     % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small
%             else
%                 DR(i,j) = 0;
%             end
%         end
%         
%         
%         
%         aux = 0;
%         
%         if (Us(i).C == false) 
%             while  aux == 0
%               [T, Ind] = max(DR(i,:));
%               Id_Small = Us(i).EBC(Ind); %Indice da Small Candidata
%               PR = ceil(Us(i).R_DR/T);
% 
%               if (Small(Id_Small).PRB_F >= PR && PR)
%                     Us(i).DR = T * PR;
%                     Us(i).PRB = PR;
%                     Us(i).EB = Id_Small;
%                     Us(i).ES = 1;
%                     Us(i).CQI = CQI(i,Ind);
%                     Us(i).SINR = SINR(i,Ind);
%                     Us(i).C = true;
%                     aux = 1;
%                     Small(Id_Small).PRB_F = Small(Id_Small).PRB_F - PR;
%               else
%                   DR(i,Ind) = 0;
%                   if Small(Id_Small).D == 1
%                     Small(Id_Small).UB = Small(Id_Small).UB + 1;
%                   end
%               end
% 
%               if (T == 0)
% 
%                     Us(i).DR = 0;
%                     Us(i).PRB = 0;
%                     Us(i).EB = 0;
%                     Us(i).CQI = 0;
%                     Us(i).SINR = 0;
%                     Us(i).C = false;
%                     aux = 1;
%               end
% 
%             end
%         end
%         
%         
%     end % Conecta os usuários  
% 
%     
%     
%    for j = 1:length(Small)
%      cont = 1;  
%      Small(j).VU = [];
%      for i = 1:U
%         if (Us(i).EB == j && Us(i).ES == 1)
%             Small(j).VU(cont) = i;
%             cont = cont + 1;
%         end 
%      end
%             
%             Small(j).U = length(Small(j).VU);
%    end
% 
% 
% 
% end
% 
