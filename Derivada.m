%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Método: Derivada
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Posicion, Time] = Derivada (Parametros, Signal)

%% Parámetros
Accion          = Parametros.Accion;
Umbral          = Parametros.Umbral;
Show            = Parametros.Show;


%% Signal
ECG             = Signal.ECG;
Fs              = Signal.Fs;
Data            = Signal.Data;
Factor_Ajuste	= Signal.Factor_Ajuste;


%% Filtrado
    %% Arranco el contador
    tic;
    
    
    %% Método de la derivada
    Senal_Derivada = diff(ECG);
    Senal_Derivada = abs(Senal_Derivada);
    Posicion = Threshold (Senal_Derivada, Fs, Umbral.Threshold);
    
    
    %% Paro el contador
    Time = toc;
    
    
%% Muestro los resultados
if (Show ~= 0)
    Show_signal (Parametros, Signal, Posicion, Time);
end

end
