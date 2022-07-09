function [Us, Small] = ConexaoUs(Us, Small)

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

                
    
    
    
    for i = 1:U
        aux = 0;
      
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
              if Small(Ind).D == 1
                Small(Ind).UB = Small(Ind).UB + 1;
              end % Cálculo dos usuários bloqueados por cada Small
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
    
  end  % Conecta os usuários 
    
    
   for j = 1:S
     cont = 1;  
     Small(j).VU = [];
     for i = 1:U
        if (Us(i).EB == j && Us(i).ES == 1)
            Small(j).VU(cont) = i;
            cont = cont + 1;
        end 
     end
            
            Small(j).U = length(Small(j).VU);
   end



end

