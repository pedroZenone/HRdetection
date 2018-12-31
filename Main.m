%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Archivo main
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Hago limpieza
clc;
clear;
close all;


%% Accion a realizar
% 1. Detección QRS utilizando onditas. Presición Double.
% 2. Detección QRS utilizando onditas. Presición fixed.
% 3. Detección QRS utilizando la derivada.
% 4. Detección QRS utilizando filtros pasa banda.
% 5. Comparación de métodos. 
% 6. Comparación de onditas madre
% 7. Peridiograma
Parametros.Accion = 7;


%% Elijo una señal ECG
% Registro < 0: Se baja de Phyisionet. The sampling frequency is 360 Hz
% with resolution 5 μV/bit.
% Registro > 0: Está en txt
% Registro = 0: Reservado. No usar
% Registro >= 20: Registros largos (10 min)
Parametros.Registro = -2;


%% Modo Debug
% 0. Off
% 1. On
Parametros.Debug = 0;


%% Save results to file
% 0. No
% 1. Si
Parametros.Save = 1;
Parametros.File_Name = datestr( now );


%% Mostrar los resultados
% 0. No muestra nada
% 1. Muestro los picos con líneas
% 2. Muestro los picos con puntos
Parametros.Show = 2;


%% Tiempo de inicio y fin de la señal
% Solo para señales de Physionet. Máximo 30 minutos
Parametros.Time_Begin = '00:00:00';
Parametros.Time_Stop = '00:05:00';


%% Umbrales
Umbral.Threshold = 0.06;           % Tomo un umbral de 6% (primera vuelta)
Umbral.Check_Threshold = 0.01;	% Tomo un umbral de 1% (segunda vuelta)
Umbral.Deriva.Derecha = 25;        % Semiancho izquierdo del Complejo QRS (en muestras)
Umbral.Deriva.Izquierda = 33;      % Semiancho derecho del Complejo QRS (en muestras)
Umbral.KNN = 3;                    % KNN. Cantidad de muestras de error que considera un TP
Umbral.Shifted = 25;               % Semiancho del complejo QRS para considerar un Shifted
Umbral.MuestrasPorPico = 190;      % Numero de muestras aprox entre pico y pico
Umbral.Ruido = 0.25;               % Potencia de ruido para considerar estado de ruido
Umbral.MinDesconexion = 190;       % Cantidad minima de muestras que deben ser iguales para considerar estado de desconexión de electrodo (igual a un periodo)
Parametros.Umbral = Umbral;


%% Parámetros Wavelet
Parametros.Nivel_Descomp = 5;
Parametros.Wavelet_Madre = 'sym11';


%% Cargo la señal
if Parametros.Accion == 6 || Parametros.Accion == 8
    Parametros.Registro = 0;
end
Signal = Cargar_Signal (Parametros);


%% Accion
switch (Parametros.Accion)
    case 1
        Wavelet_Double (Parametros, Signal);
    case 2
        Wavelet_Fixed (Parametros, Signal);
    case 3
        Derivada (Parametros, Signal);
    case 4
        FPB (Parametros, Signal);
    case 5
        Comparacion_Metodos (Parametros, Signal);
    case 6
        Parametros.CantRegistros = Signal.CantRegistros;
        Comparacion_Onditas_Madre (Parametros);
    case 7
        Peridiograma (Parametros, Signal);
    case 8
        Parametros.CantRegistros = Signal.CantRegistros;
        Recursivo (Parametros, Signal);
    otherwise
        fprintf ('\nError: Seleccionar \''Accion\'' del 1 al 8\n');
end


%% Autor
fprintf('\nPedro Zenone - pedro.zenone@gmail.com\n');
fprintf('Nicolás Linale - nicolaslinale@gmail.com\n');

