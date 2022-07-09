function [Us, Small] = ConexaoUsM(Us, Small)

    S = length(Small);
    U = length (Us);
   
    
    for i = 1:U
        for j = 1:S
                   [DR(i,j), CQI(i,j), SINR(i,j)] = CalculateChannel(Us(i), Small(j), Small);  
        end
    end   % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small

   
    for i = 1:U
        aux = 0;
     if (Us(i).C == false)
        
      while  aux == 0
          [T, Ind] = max(DR(i,:)); 
          PR = ceil(Us(i).R_DR/T);
          
          if (Small(Ind).PRB_F >= PR)
                Us(i).DR = T * PR;
                Us(i).PRB = PR;
                Us(i).EB = Ind;
                Us(i).ES = 2;
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
        if (Us(i).EB == j)
            Small(j).VU(cont) = i;
            cont = cont + 1;
        end 
     end
            
            Small(j).U = length(Small(j).VU);
   end





end

