%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Post-detección - Procesamiento No lineal
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Posicion = Maquina_Estados ( ECG, InterSignal, Umbral, Fs, Recursividad)


%% Defino algunas variables
e1xe2 = InterSignal.e1xe2;
nECG = numel (ECG);
Ventana = floor( Fs*100/360 );


%% 1) Verifico que no haya sobrepicos que ensucien el umbral
if Recursividad == 0
     e1xe2 = Estado_Sobrepicos( nECG, e1xe2, Umbral.MuestrasPorPico );
     InterSignal.e1xe2 = e1xe2;
end


%% 2) Ventaneo (Thresholding)
Posicion = Estado_Ventaneo( ECG, e1xe2, Umbral.Threshold, Ventana );


%% 3) Busco máximos locales
Posicion = Estado_Find_Peaks ( ECG, Posicion, Umbral.Deriva);


%% 4) Calculo algunas constantes
Picos = find (Posicion == 1);
nPicos = numel(Picos);
Delta_Picos = zeros(1, nPicos-1);
for i = 1 : nPicos - 1
    Delta_Picos(i) = Picos (i+1) - Picos(i);
end
Prom = mean (Delta_Picos);
MaxDelta = Prom * 1.5;
MinDelta = Prom * 0.4;


%% 5) Picos faltantes (Distancia RR >> Promedio)
Posicion = Estado_Far_Peaks( ECG, InterSignal, Posicion, Picos, Delta_Picos, Umbral, MaxDelta, Ventana );


%% 6) Picos muy cercanos (Distancia RR << Promedio)
Posicion = Estado_Close_Peaks( ECG, Posicion, Picos, Delta_Picos, MinDelta );


%% 7) Señal ruidosa
Posicion = Estado_Ruido( ECG, InterSignal, Posicion, Picos, Umbral, Fs, Recursividad );


%% 8) Desconexión (señal constante)
Posicion = Estado_Desconexion( ECG, Posicion, Umbral.MinDesconexion );


%% 9) Solo por problemas en la recursividad . . .
if numel(Posicion) > nECG
     Posicion (nECG + 1 : end) = [];
end


end


