function [custo] = funcao_de_selecao (V21, SS, Total_US)

NSC = SS;
us_conectados = 0;

for i=1:NSC
   

    us_conectados = us_conectados + V21(i, 3);
    
end

custo = Total_US - us_conectados;

end
    