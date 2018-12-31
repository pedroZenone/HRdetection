%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Ventaneo
% Examino el detall e1xe2 y le aplico hard thresholding (o no tan hard ...)
% 
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Ventaneo( ECG, e1xe2, Threshold, Ventana )

nECG = numel(ECG);

%% Aplico Hard-Thresholdin
Posicion = zeros (1, nECG);
Posicion(e1xe2 > Threshold) = 1;


%% Analizo el vector
i = 1;
while (i < nECG - Ventana)
    
    if Posicion(i)
            
        Pot = sum ( e1xe2(i : i + Ventana) .^2 );
        
        Suma = 0;
        j = 0;
        while Suma < Pot/2
             Suma = Suma + e1xe2 (i+j) .^2;
             j = j + 1;
        end
        Posicion(i : i + Ventana) = 0;
        Posicion(i + j) = 1;
        
        i = i + Ventana;
    else
        i = i+1;
    end
    
end


%% Analizo la ultima parte del vector
i = nECG - Ventana;
while (i < nECG - 20)
    
    if Posicion(i)
        
        Pot = sum ( e1xe2(i : end) .^2 );
        Suma = 0;
        j = 0;
        while Suma < Pot/2
             Suma = Suma + e1xe2 (i+j) .^2;
             j = j + 1;
        end
        Posicion(i : end) = 0;
        Posicion(i + j) = 1;
        
        break;
    else
        i = i + 1;
    end
    
end

end


