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

[Macro] = StartMacro(MC, X, Y); % Função para iniciar as MacriCells

small_positions_X= zeros(1,size(Small,2));
small_positions_Y= zeros(1,size(Small,2));
for i=1:size(Small,2)
    small_positions_X(i) = Small(i).X;
    small_positions_Y(i) = Small(i).Y;
end

% users_positions_X = zeros(1,size(Us,2));
% users_positions_Y = zeros(1,size(Us,2));
for i=1:size(Us,2)
    if Us(i).M == 1
        users_positions_X(i) = Us(i).X;
        users_positions_Y(i) = Us(i).Y;
    end
end

x_Smalls=(small_positions_X);
x_Macro = Macro(1).X;
x_Users = (users_positions_X);

y_Smalls=small_positions_Y;
y_Macro = Macro(1).Y;
y_Users=users_positions_Y;

figure1 = figure('Name', 'Cenário Inicial','Color',[1 1 1]);
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(x_Smalls,y_Smalls, 'o', 'color', 'blue');
hold on
plot(x_Macro,y_Macro, '^', 'MarkerSize', 8);
hold on
plot(x_Users,y_Users, '*', 'color','red');
hold on
legend1 = legend('PRRH', 'MRRH', 'Users');
set(legend1,'Location','northeastoutside');

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

