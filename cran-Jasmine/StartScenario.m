 function [Us, Small, Macro, TU] = StartScenario(U, SC, MC)


% U ** Total de Usuarios = U*11 **
% SC Total de SmallCells
% M Total de MacroCells

% Eixos dos cenários.  (Área total = 4 Km²)
X(1,:) = [0 500]; % Eixo X minimo e máximo.
Y(1,:) = [0 500]; % Eixo Y minimo e máximo.


% Confirmar os parâmetros usados % ----------------------------------------
% -------------------------------------------------------------------------

[Us, TU] = StartUser(U, X, Y); % Função para iniciar os usuários

[Small] = StartSmall(SC, X, Y); % Função para iniciar as SmallCells 

[Macro] = StartMacro(MC); % Função para iniciar as MacriCells


 
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

