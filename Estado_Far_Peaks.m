%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Far Peaks
% Se verifica si hay picos faltantes (Distancia RR >> Promedio)
% 
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Far_Peaks( ECG, InterSignal, Posicion, Picos, Delta_Picos, Umbral, MaxDelta, Ventana )

e1xe2 = InterSignal.e1xe2;
nECG = numel(ECG);
nPicos = numel(Picos);

%% Me fijo si falta algún pico
for i = 1 : nPicos - 1
    if Delta_Picos(i) > MaxDelta
        
        This = Picos(i) + 1;
        Next = Picos(i+1) - 1;
        Posicion (This : Next) = 0;
        AuxIndex = e1xe2(This : Next) > Umbral.Check_Threshold;
        Posicion(This : This + numel(AuxIndex) - 1) = AuxIndex;
        j = This;
        while (j < Next)
            if Posicion(j)
                Posicion(j : j + Ventana) = 0;
                Posicion(j + 20) = 1;
                j = j + Ventana;
            else
                j = j + 1;
            end
        end
        
        This = This - Umbral.Deriva.Izquierda; if (This < 1) This = 1; end
        Next = Next + Umbral.Deriva.Derecha; if (Next > nECG) Next = nECG; end
        
        Umbral.Deriva.Izquierda = Umbral.Deriva.Izquierda + 10;
        Umbral.Deriva.Derecha = Umbral.Deriva.Derecha +10;
        
        Posicion (This : Next) = Estado_Find_Peaks ( ECG(This : Next), Posicion(This : Next), Umbral.Deriva);      
        
        Umbral.Deriva.Izquierda = Umbral.Deriva.Izquierda - 10;
        Umbral.Deriva.Derecha = Umbral.Deriva.Derecha - 10;
    end
end

end


