%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Método: Filtrado clásico
% Filtrado pasa banda y derivada
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Posicion, Time] = FPB (Parametros, Signal)

%% Parámetros
Accion          = Parametros.Accion;
Show            = Parametros.Show;
Debug           = Parametros.Debug;


%% Signal
ECG             = Signal.ECG;
Fs              = Signal.Fs;
Data            = Signal.Data;
Factor_Ajuste	= Signal.Factor_Ajuste;


%% Filtrado
    %% Arranco el contador
    tic;


    %% Filtro Pasa Bajos
    % Órden del filtro
    Orden = 21;
    Delay = Orden - 1;

    % Filtro pasa bajos sin retardo de grupo
    Coefs_Bajos = firls ( Orden - 1, [0 0.055 0.055 1], [1 1 0 0]) .* kaiser(Orden, 5)';

    % Agrego muestras
    ECG_Filtro = myExtend(ECG, Delay);

    % Convoluciono
    ECG_Filtro = conv(ECG_Filtro, Coefs_Bajos);

    % Limites
    Lim_Inf = floor (Delay + 7);
    Lim_Sup = ceil (Delay + (Delay/2) - 7 );

    % Saco el retardo
    % Ojo, cambia el length
    ECG_Pasa_Bajos = ECG_Filtro ( Lim_Inf + 1 : end - Lim_Sup ); 


    %% Filtro Pasa Altos
    % Demora de 16 muestras
    % Coeficientes robados de por ahi... retardo de grupo cte...
    Coef_Altos = zeros(1, 32);
    Coef_Altos(1) = 1;
    Coef_Altos(32) = -1;
    Coef_1 = [1 -1]; 

    % Aplico el filtro
    ECG_Pasa_Altos = filter (Coef_Altos, Coef_1, ECG_Pasa_Bajos);

    Coef_2 = zeros(1,16);
    Coef_2(16) = 1;

    ECG_Aux = filter (Coef_2, 1, ECG_Pasa_Bajos);

    ECG_Pasa_Banda = ECG_Aux - (ECG_Pasa_Altos./32);

    ECG_Pasa_Banda(1:31) = ECG_Pasa_Banda(32);


    %% Derivada
    % QRS ~ 17HZ
    Coef_Derivada = [2 1 0 -1 -2];
    Delay = 4;
    clear ECG_Aux;

    % Agrego muestras
    ECG_Aux = myExtend ( ECG_Pasa_Banda, Delay );

    % Convoluciono
    ECG_Filtro = conv (ECG_Aux, Coef_Derivada, 'valid');

    % Limites
    Lim_Inf = floor (Delay/2);
    Lim_Sup = ceil (Delay/2);

    % Saco el retardo
    % Ojo, cambia el length
    Picos_Derivada = ECG_Filtro ( Lim_Inf + 1 : end - Lim_Sup );


    %% Elevo al cuadrado
    % Perdemos la linealidad
    Picos_Al_Cuadrado = Picos_Derivada.^2;


    %% Aplico Threshold y hago una correción de 13 muestras
    Posicion2 = Threshold (Picos_Al_Cuadrado, Fs, 0.2);
    Posicion = Posicion2(1+13:end);


    %% Muestro los resultados
    if(Debug == 1)   
         figure();
         subplot(611), plot(ECG), title('ECG');
         subplot(612), plot(ECG_Pasa_Bajos), title('Pasa Bajos');
         subplot(613), plot(ECG_Pasa_Banda), title('Pasa Banda');
         subplot(614), plot(Picos_Derivada), title('Derivada');
         subplot(615), plot(Picos_Al_Cuadrado), title('Ecg al cuadrado');
         subplot(616), plot(Posicion), title('Picos QRS');
    end


    %% Paro el contador
    Time = toc;


%% Muestro los resultados
if (Show ~= 0)
    Show_signal (Parametros, Signal, Posicion, Time);
end

end
