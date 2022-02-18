function [Small, Macro, Us, usr_mantidos] = Manter_Ligada(Us, Macro, Small, Id_usr, Ind)
    
    Us1 = Us(Id_usr);
    S1 = Small(Ind);
    
    index = Us1.EB;
    tipo = Us1.ES;
    if Us1.C == true
        if tipo == 1 % Tipo de SB. Small = 1
            for i=1:length(Small(index).VU)
                if Small(index).VU(i) == Id_usr
                    Small(index).VU(i) = [];
                    Small(index).U = Small(index).U - 1;
                    break;
                end
            end
        elseif tipo == 2 %Tipo de SB. Macro = 2
            for i=1:length(Macro(index).VU)
                if Macro(index).VU(i) == Id_usr
                    Macro(index).VU(i) = [];
                    Macro(index).U = Macro(index).U - 1;
                    break;
                end
            end     
        end
    end % Desconectar os usuários que foram trasnferidos para outras Smalls ou para a Macro
    
    
    S = length(S1);
    U = length (Us1);
    
    usr_nao_transferido = 0;
    usr_mantidos = 0;
    
    for i = 1:U
        for j = 1:S
                   [DR(i,j), CQI(i,j), SINR(i,j), I(j,i)] = CalculateChannel_copia(Us(Id_usr), Small(Ind), Small);  
        end
    end   % Calcula o SINR, CQI e DR (1 PRB) de cada usuário para cada Small

   
    for i = 1:U
        aux = 0;
        
      while  aux == 0
          [T] = max(DR(i,:)); 
          PR = ceil(Us(i).R_DR/T);
          
          if (Small(Ind).PRB_F >= PR)
                Us(Id_usr).DR = T * PR;
                Us(Id_usr).PRB = PR;
                Us(Id_usr).EB = Ind;
                Us(Id_usr).ES = 1;
                Us(Id_usr).CQI = CQI(i);
                Us(Id_usr).SINR = SINR(i);
                Us(Id_usr).C = true;
                aux = 1;
                Small(Ind).PRB_F = Small(Ind).PRB_F - PR;
                X = Small(Ind).U;
                if  isempty(X)
                    Small(Ind).VU(i) = Id_usr;
                    Small(Ind).U = 1;
                else
                    Small(Ind).U = X+1;
                    Small(Ind).VU(X+1) = Id_usr;                    
                end % Atualiza a quantidade de usr na Small

                usr_mantidos = usr_mantidos + 1;
       
          else
              DR(i) = 0;
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

