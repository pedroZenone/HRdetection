%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Método: Wavelet
% Precisión: Punto fijo (Fixed)
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Posicion, Time] = Wavelet_Fixed (Parametros, Signal)

%% Parámetros
Accion          = Parametros.Accion;
Umbral          = Parametros.Umbral;
Wavelet_Madre	= Parametros.Wavelet_Madre;
Nivel_Descomp	= Parametros.Nivel_Descomp;
Show            = Parametros.Show;


%% Signal
ECG             = Signal.ECG;
Fs              = Signal.Fs;
Data            = Signal.Data;
Factor_Ajuste	= Signal.Factor_Ajuste;


%% Filtrado
    %% Arranco el contador
    tic;


    %% Transformada Wavelet
    % Coeficientes de la Wavelet
    [LO_D,HI_D,Lo_R,Hi_R] = wfilters(Wavelet_Madre);

    [c, l] = myWavedec2(ECG, Nivel_Descomp, LO_D, HI_D);

    % cD3 =  myDetcoef2(c, l, 3);
    % cD4 =  myDetcoef2(c, l, 4);
    % cD5 =  myDetcoef2(c, l, 5);

    D3 = myWrcoef2(Hi_R, Lo_R, c, l, 3);
    D4 = myWrcoef2(Hi_R, Lo_R, c, l, 4);
    D5 = myWrcoef2(Hi_R, Lo_R, c, l, 5);

    % Asi seria con las funciones del Toolbox de Wavelet...
    % [C,L] = wavedec(ECG, Nivel_Descomp, Wavelet_madre); % Esto me entrega un vector C con los datalles 1,2,3 + la aproximacion
    % % Levanto los details y los expando
    % cD5 = detcoef(C,L,5);D5 = wrcoef('d',C,L,Wavelet_madre,5);
    % cD4 = detcoef(C,L,4);D4 = wrcoef('d',C,L,Wavelet_madre,4);
    % cD3 = detcoef(C,L,3);D3 = wrcoef('d',C,L,Wavelet_madre,3);


    %% Filtrado
    % ¡Aca esta la magia! Hago unas operaciones, y normalizo
    e1 = D3 + D4 + D5;
    e2 = myMul ( D4, (D3 + D5) );
    e1xe2 = abs ( myMul (e1,e2) );


    % Aplico hard tresholding
    Posicion = Threshold( e1xe2, Fs, Umbral.Threshold );
    Posicion = Check_Treshold( Posicion, e1xe2, Fs, 0.4 );


    %% Paro el contador
    Time = toc;


%% Muestro los resultados
if (Show ~= 0)
    Show_signal (Parametros, Signal, Posicion, Time);
end

end
