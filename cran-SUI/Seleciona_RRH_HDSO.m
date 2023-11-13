function [Saida, S1, small_cell_status] = Seleciona_RRH_HDSO (User, melhor_selecao, Macro,Small)

TS = size(Small,2);

small_cell_status = zeros(1,TS);

for i = 1:TS
    Small(i).D = true;
    small_cell_status(i) = 1;
end



  for j = 1:length(melhor_selecao)  
    if melhor_selecao(1,j) ~= 0
      a = melhor_selecao(1, j);
      Small(a).D = false;    
    end
      
  end
  %Desligando as Small que pertencem ao conjunto OFF (melhor_seleção)


[Us1, S1] = ConexaoUs(User, Small);
[M1] = Media(Us1);


[Us1, M1] = ConexaoUsM(Us1, Macro);



[Saida] = CalculoResults(Us1, S1);






end


