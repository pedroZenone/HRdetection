%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Llama y compara todos los métodos
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Comparacion_Metodos (Parametros, Signal)

%% Parámetros
Show = Parametros.Show;


%% Filtrado
    Parametros.Show = 0;
    
    % Filtrado a Wavelet - Precisión Double
    Parametros.Accion = 1;
    [Posicion{1}, Time(1)] = Wavelet_Double (Parametros, Signal);

    % Filtrado a Wavelet - Precisión Punto Fijo
    Parametros.Accion = 2;
    [Posicion{2}, Time(2)] = Wavelet_Fixed (Parametros, Signal);

    % Filtrado por derivación
    Parametros.Accion = 3;
    [Posicion{3}, Time(3)] = Derivada (Parametros, Signal);

    % Filtro pasa banda
    Parametros.Accion = 4;
    [Posicion{4}, Time(4)] = FPB (Parametros, Signal);


%% Muestro los resultados
Parametros.Accion = 5;
Parametros.Show = Show;
Show_signal (Parametros, Signal, Posicion, Time);


end
