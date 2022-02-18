 function [Us, Small, Macro, TU] = StartScenario_copia(U, SC, MC)


% U ** Total de Usuarios = U*11 **
% SC Total de SmallCells
% M Total de MacroCells

% Eixos dos cenários.  (Área total = 4 Km²)
X(1,:) = [0 600]; % Eixo X minimo e máximo.
Y(1,:) = [0 600]; % Eixo Y minimo e máximo.


% Confirmar os parâmetros usados % ----------------------------------------
% -------------------------------------------------------------------------

[Us, TU] = StartUser_copia(U, X, Y); % Função para iniciar os usuários

[Small] = StartSmall_copia(SC, X, Y); % Função para iniciar as SmallCells 

[Macro] = StartMacro_copia(MC); % Função para iniciar as MacriCells


 
% %Geração dos Gráficos
% [Grafico] = Grafico_Cenario_Inicial(Us1, Small, Macro, X, Y, 1);
% nome = strcat('Graficos\Manhã.pdf');
% saveas(Grafico, nome);
% [Grafico] = Grafico_Cenario_Inicial(Us2, Small, Macro, X, Y, 2);
% nome = strcat('Graficos\Tarde.pdf');
% saveas(Grafico, nome);
% [Grafico] = Grafico_Cenario_Inicial(Us3, Small, Macro, X, Y, 3);
% nome = strcat('Graficos\Noite.pdf');
% saveas(Grafico, nome);















end

