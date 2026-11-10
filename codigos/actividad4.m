% Actividad 4 del segundo trabajo grupal
% Codigo guia de la sesion 11, repetido para los cuatro archivos de datos.
% Para cada archivo: distribucion de la muestra, codificacion de la funcion
% con superfuncion, distribucion de la funcion codificada y qqplot.

archivos = {'BCpAug89.TL','BCpOct89.TL','BCOct89Ext.TL','BCOct89Ext4.TL'};
nombres  = {'agostornd','octubrernd','octubreextrnd','octubreext4rnd'};
minimos  = [-0.001, -0.0005, -0.05, -0.03]; % intervalo de observacion, en segundos:
maximos  = [ 0.006,  0.005,   0.5,   0.3];  % la CDF debe llegar cerca de 1
generados = 1000000;                        % numeros generados con cada funcion
resumen = zeros(numel(archivos),7); % una fila por archivo

for j = 1:numel(archivos)
    % Distribucion de la muestra
    datos = load(archivos{j});
    muestra = diff(datos(:,1)');            % vector tea

    % Codificacion de la funcion
    superfuncion(muestra,nombres{j});
    rehash;                                 % para que MATLAB vea el archivo nuevo
    generador = str2func(nombres{j});
    muestragenerada = generador(1,generados);

    % Distribucion de la funcion codificada, superpuesta a la de la muestra
    figure(2*j-1);
    pdfcdfcontinua(muestra,minimos(j),maximos(j));
    subplot(2,1,1); hold on;
    subplot(2,1,2); hold on;
    pdfcdfcontinua(muestragenerada,minimos(j),maximos(j));
    subplot(2,1,1); hold off;
    legend({'Muestra','Función codificada'});
    subplot(2,1,2); hold off;
    legend({'Muestra','Función codificada'},'Location','southeast');
    exportgraphics(gcf,['actividad4_pdfcdf_',nombres{j},'.png'],'Resolution',300);

    % QQplot de la funcion codificada
    figure(2*j);
    qqplot(muestragenerada,muestra);
    exportgraphics(gcf,['actividad4_qq_',nombres{j},'.png'],'Resolution',300);

    % Comparacion numerica: media, mediana, desviacion estandar y mayor
    % diferencia entre las dos CDF estimadas en el intervalo de observacion
    x = linspace(minimos(j),maximos(j),1000);
    F1 = cumsum(histc(muestra,x))/numel(muestra);
    F2 = cumsum(histc(muestragenerada,x))/numel(muestragenerada);
    resumen(j,:) = [mean(muestra), mean(muestragenerada), ...
        median(muestra), median(muestragenerada), ...
        std(muestra), std(muestragenerada), max(abs(F1-F2))];
end

resumen
