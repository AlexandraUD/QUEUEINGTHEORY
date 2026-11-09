function [Pk] = mm1k(tea,tds,K,mostrar)
% MM1K Simula una cola M/M/1/K y estima la probabilidad de bloqueo.
%   Pk = mm1k(tea,tds,K,mostrar)
%   tea: vector con los tiempos entre arribos consecutivos.
%   tds: vector con los tiempos de servicio de cada usuario.
%   K: capacidad del sistema (servidor + linea de espera), entero positivo.
%   mostrar: si es 1 (valor por defecto) imprime los vectores de la simulacion.
%   Pk: fraccion de usuarios que llegan y encuentran el sistema lleno.
    switch nargin
        case 3
            mostrar = 1;
    end
    if numel(tea) ~= numel(tds)
        error('tea y tds deben tener el mismo numero de elementos.');
    end
    if ~isscalar(K) || K < 1 || K ~= fix(K)
        error('K debe ser un entero positivo.');
    end

    tea = tea(:)';
    tds = tds(:)';
    usuarios = numel(tea);
    reloj = cumsum(tea);
    inicio = NaN(1,usuarios);
    salida = NaN(1,usuarios);
    bloqueado = false(1,usuarios);
    admitidos = zeros(1,usuarios); % usuarios que entraron, en orden de llegada
    a = 0;                         % cantidad de usuarios admitidos

    for i = 1:usuarios
        % Sistema lleno: el K-esimo ultimo admitido aun no ha salido
        if a >= K && salida(admitidos(a-K+1)) > reloj(i)
            bloqueado(i) = true;
        else
            % Disciplina FIFO, igual que en la cola X/X/1 (funcion xx1)
            if a > 0 && salida(admitidos(a)) > reloj(i)
                inicio(i) = salida(admitidos(a));
            else
                inicio(i) = reloj(i);
            end
            salida(i) = inicio(i) + tds(i);
            a = a + 1;
            admitidos(a) = i;
        end
    end
    espera = inicio - reloj;

    Pk = sum(bloqueado)/usuarios;

    if mostrar == 1
        tea
        tds
        reloj
        inicio
        salida
        espera
        bloqueado
    end
end
