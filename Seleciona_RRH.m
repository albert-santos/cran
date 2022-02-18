function [Saida, S1] = Seleciona_RRH (User, melhor_selecao, Macro,Small)

TS = size(Small,2);

for i = 1:TS
    Small(i).D = true;
end



  for j = 1:length(melhor_selecao)  
    if melhor_selecao(1,j) ~= 0
      a = melhor_selecao(1, j);
      Small(a).D = false;    
    end
      
  end
  %Desligando as Small que pertencem ao conjunto OFF (melhor_seleção)


[Us1, S1] = ConexaoUs_copia(User, Small);
[M1] = Media_copia(Us1);


[Us1, M1] = ConexaoUsM_copia(Us1, Macro);



[Saida] = CalculoResults_copia(Us1, S1);






end


