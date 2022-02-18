function [ usr_nao_transferido, usr_transferidos, Small, Us] = Tranferencia_de_Usr(Us, Small, Id_usr)
    
    
    S = length(Small);
    U = length(Us);
    
    usr_nao_transferido = 0;
    usr_transferidos = 0;
    
    for i = 1:1
        for j = 1:S
                   [DR(i,j), CQI(i,j), SINR(i,j), I(i,j)] = CalculateChannel_copia(Us(Id_usr), Small(j), Small);  
        end
    end   % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small
    
    
%     cont = 0;
%     for j=1:S
%         for i=1:U
%            cont = cont + I(i,j); 
%         end
%        Small(j).Int = cont;
%        cont = 0;   
%     end

   
    for i = 1:1
        aux = 0;
        
      while  aux == 0
          [T, Ind] = max(DR(i,:)); 
          PR = ceil(Us(Id_usr).R_DR/T);
          
          if (Small(Ind).PRB_F >= PR)
                Us(Id_usr).DR = T * PR;
                Us(Id_usr).PRB = PR;
                Us(Id_usr).EB = Ind;
                Us(Id_usr).ES = 1;
                Us(Id_usr).CQI = CQI(i,Ind);
                Us(Id_usr).SINR = SINR(i,Ind);
                Us(Id_usr).C = true;
                Us(Id_usr).Int = I(i,Ind);
                aux = 1;
                Small(Ind).PRB_F = Small(Ind).PRB_F - PR;
                Small(Ind).Int = Small(Ind).Int + Us(Id_usr).Int;
                X = Small(Ind).U;
                if  isempty(X)
                    Small(Ind).VU(i) = Id_usr;
                    Small(Ind).U = 1;
                else
                    Small(Ind).U = X+1;
                    Small(Ind).VU(X+1) = Id_usr;                    
                end

                usr_transferidos =  1;
       
          else
              DR(i,Ind) = 0;
              usr_nao_transferido = Id_usr;
          end
      
          if (T == 0)
                 
                Us(Id_usr).DR = 0;
                Us(Id_usr).PRB = 0;
                Us(Id_usr).EB = 0;
                Us(Id_usr).CQI = 0;
                Us(Id_usr).SINR = 0;
                Us(Id_usr).C = false;
                aux = 1;
                usr_nao_transferido = Id_usr;
          end
      
      end 
    end  % Conecta os usuários 

end

