% Actividad 3 del segundo trabajo grupal - Cola M/M/1/K
% Codigo guia de la sesion 11, con los cambios indicados en los comentarios.

figure(1);
usuarios = 100000; % repetir con 1000000 y 10000000 (ley de los grandes numeros)
lambda = 1;
simulaciones = 20; % # de comparaciones
K = 2;             % capacidad del sistema M/M/1/K
Amax = 10*K;       % A sugerido en clase para la M/M/1/K (se probo con 20*K)

% Resultado Teorico: Pk
A = linspace(0.05,Amax,10000);
mu = lambda./A;
teorico = (1-A).*A.^K./(1-A.^(K+1)); % probabilidad de bloqueo de la M/M/1/K
teorico(abs(A-1)<1e-9) = 1/(K+1);    % caso A = 1
superplot(A,teorico);
hold on;

% Resultado de Simulacion: Pk estimada
A = linspace(0.05,Amax,simulaciones);
mu = lambda./A;

resultadosimulacion = zeros(1,simulaciones);
for n = 1:simulaciones
    tea = exprnd(1/lambda,1,usuarios);
    tds = exprnd(1/mu(n),1,usuarios);
    resultadosimulacion(n) = mm1k(tea,tds,K,0); % funcion de la Actividad 2
end

superstem(A,resultadosimulacion,'Probabilidad de Bloqueo',...
    '$\frac{\lambda}{\mu}$','$P_K,\:\hat{P}_K$');
xlim([0.05,Amax]);
hold off;

legend({'Teórico','Simulación'},'Location','northwest');

% Diferencia entre la simulacion y el valor teorico en los mismos valores de A
teoricosim = (1-A).*A.^K./(1-A.^(K+1));
teoricosim(abs(A-1)<1e-9) = 1/(K+1);
errormaximo = max(abs(resultadosimulacion-teoricosim))

% Guardar la grafica para el documento
exportgraphics(gcf,['actividad3_',num2str(usuarios),'.png'],'Resolution',300);
