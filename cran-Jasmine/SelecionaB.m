function [Saida, S1, small_cell_status] = SelecionaB (SS, User, melhor_selecao, Macro,Small)

TS = size(Small,2);

small_cell_status = zeros(1,TS);

for i = 1:TS
    Small(i).D = false;
end



  for j = 1:SS  
    
      a = melhor_selecao(j,1);
      Small(a).D = true;
      small_cell_status(a) = 1;
      
  end
  %Conectando as smallcells (já organizadas por numero de usr ou por vazao)
  %de acordo com os percentuais e desligando as outras.
  
  
% 
[Us1, M1] = ConexaoUsM(User, Macro);
% 
[Us1, S1] = ConexaoUs_alt(Us1, Small);
% [Us1, S1] = ConexaoUs_alt(User, Small);
[M1] = Media(Us1);


% [Us1, M1] = ConexaoUsM(Us1, Macro);



[Saida] = CalculoResults(Us1, S1);




end


