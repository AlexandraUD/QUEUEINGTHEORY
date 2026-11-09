function [] = pdfcdfcontinua(datos,minimo,maximo,particiones)
%% Función PDFCDFCONTINUA
% PDFCDFCONTINUA estima la función de densidad de probabilidad (pdf) y la
% función de distribución acumulativa (CDF) de la muestra aleatoria
% consignada en la matriz datos. Opcionalmente se pueden indicar los
% valores mínimo y máximo de observación, de la variable aleatoria, y la
% cantidad de particiones de la misma. Por defecto, la cantidad de
% particiones se estima con la raíz cuadrada del tamaño de la muestra.
%
% Ejemplo 1: Muestra uniformemente distribuída con parámetros 0 y 1
%
% muestra = rand(1,10000);
% PDFCDFCONTINUA(muestra);
%
% Ejemplo 2: Muestra normalmente distribuída con parámetros 4 y 2,
% visualizada en el intervalo [-4,14]
%
% muestra = normrnd(4,2,1,10000);
% PDFCDFCONTINUA(muestra,-4,14);
%
% Ejemplo 3: Muestra exponencialmente distribuída con parámetro 5, estimada
% con 200 particiones
%
% muestra = exprnd(1/5,1,10000);
% PDFCDFCONTINUA(muestra,-0.2,1.2,200);
%
% Ejemplo 4: Muestra exponencialmente distribuída con parámetro 5, estimada
% con la función fitdist de MATLAB (para usarla se debe indicar que la
% cantidad de particiones es igual a 0).
%
% muestra = exprnd(1/5,1,10000);
% PDFCDFCONTINUA(muestra,-0.2,1.2,0);
%
% Función PDFCDFCONTINUA, Versión 2.0, 10 de diciembre de 2020.
% - Se ha agregado el texto de ayuda.
% - Se ha incluido la variable particiones.
% - Se ha incluido la opción de emplear el ajuste propuesto por MATLAB.
%   Para habilitarlo, la variable particiones debe estar en 0.
% - Se ha incluido la función superplot como función local.
%
% Versión 1.0, 9 de octubre de 2015.
% Elaborada por: Hans López, hilopezc@udistrital.edu.co
% Grupo de investigación IDEAS.
    switch nargin
        case 1
            rango = max(datos(:)')-min(datos(:)');
            minimo = min(datos(:)')-0.2*rango;
            maximo = max(datos(:)')+0.2*rango;
            total = numel(datos);
            particiones = floor(sqrt(total));
        case 2
            particiones = minimo;
            rango = max(datos(:)')-min(datos(:)');
            minimo = min(datos(:)')-0.2*rango;
            maximo = max(datos(:)')+0.2*rango;
        case 3
            total = numel(datos);
            particiones = floor(sqrt(total));
    end            
    datos = datos(:)';
    total = numel(datos);
    
    if particiones ~= 0
        x = linspace(minimo,maximo,particiones);

        fr = histc(datos,x)/total;
        ycdf = cumsum(fr);
        ypdf = fr/(x(2)-x(1));
    else
        pd = fitdist(datos','Kernel','Kernel','normal');
        x = linspace(minimo,maximo,1000);
        ypdf = pdf(pd,x);
        ycdf = cdf(pd,x);
    end
    subplot(2,1,2);
    superplot(x,ycdf,...
        'Estimación de la Distribución Acumulativa',...
        '$x$','$F_X(x)$');
    subplot(2,1,1);
    superplot(x,ypdf,...
        'Estimación de la función de densidad',...
        '$x$','$f_X(x)$');        
end
function [] = superplot(x,y,titulo,ejex,ejey,grosor,colorlinea)
%   Utiliza la función plot para realizar la gráfica de f(x). SUPERPLOT
%   cambia el fondo de la figura a color blanco y el tamaño de las fuentes.
%   Adicionalmente ajusta de forma automática los límites de las gráficas.
%
%   La función permite agregar el título de la gráfica, y el nombre de los
%   ejes como parámetros de entrada.
%
%   Ejemplo:
%
%   x = linspace(-5,5,1000);
%   SUPERPLOT(x,sinc(x),'Función Seno Cardinal','$x$','sinc($x$)');
%
%   Función SUPERPLOT, Versión 6.0 9 de mayo de 2020
%   - Se corrigió el error que se presentaba al intentar ajustar de manera
%   automática los ejes cuando el vector "y" era constante.
%   Versión 5.0, 28 de agosto de 2019
%   - Se cambió de gráfica de puntos a línea contínua de grosor 2.
%   Versión 4.0, 23 de marzo de 2019
%   - Se agregó un séptimo parámetro para modificar el color de la línea.
%   Versión 3.0, 18 de mayo de 2017
%   - Se modificó el interprete de los ejes a LaTeX. El interprete del
%   título no se modificó.
%   Versión 2.0, 2 de diciembre de 2016:
%   - Se modificó el tamaño del punto a 10, para mejorar la visualización.
%   - El tamaño del punto se puede modificar indicándolo en el sexto
%   parámetro, como muestra el ejemplo.
%   Versión 1.0, 29 de septiembre de 2015
%   Elaborada por Hans López, hanslop@gmail.com
%    
switch nargin
    case 0
        disp('Faltan argumentos de entrada');
        return;
    case 1
        plot(x,'LineWidth',2);
        grid on;
        set(gca,'FontSize',14);
        set(gcf,'Color','white');
        if max(x) - mean(x) > 1e-6
            axis([1 length(x) min(x)-0.1*(max(x)-min(x)) max(x)+0.1*(max(x)-min(x))]);
        end
        return;
    case 2
        plot(x,y,'LineWidth',2);
    case 3
        plot(x,y,'LineWidth',2);
        title(titulo,'FontSize',16);
    case 4
        plot(x,y,'LineWidth',2);
        title(titulo,'FontSize',16);
        xlabel(ejex,'FontSize',16,'Interpreter','latex');
    case 5
        plot(x,y,'LineWidth',2);       
        title(titulo,'FontSize',16);
        xlabel(ejex,'FontSize',16,'Interpreter','latex');
        ylabel(ejey,'FontSize',16,'Interpreter','latex');
    case 6        
        plot(x,y,'LineWidth',grosor);       
        title(titulo,'FontSize',16);
        xlabel(ejex,'FontSize',16,'Interpreter','latex');
        ylabel(ejey,'FontSize',16,'Interpreter','latex');
    case 7        
        plot(x,y,'Color',colorlinea,'LineWidth',grosor);       
        title(titulo,'FontSize',16);
        xlabel(ejex,'FontSize',16,'Interpreter','latex');
        ylabel(ejey,'FontSize',16,'Interpreter','latex');
end
grid on;
set(gca,'FontSize',14);
set(gca,'TickLabelInterpreter','latex');
set(gcf,'Color','white');
if max(y) - mean(y) > 1e-6
    axis([min(x) max(x) min(y)-0.1*(max(y)-min(y)) max(y)+0.1*(max(y)-min(y))]);
end
end