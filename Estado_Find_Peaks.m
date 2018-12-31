%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Find Peaks
% Una vez detectado el pico, afino la puntería
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Find_Peaks ( ECG, Posicion, Deriva )

nECG = numel(ECG);
Deriva_Der = Deriva.Derecha;
Deriva_Izq = Deriva.Izquierda;


%% Caso general
x = Deriva_Izq + 2;
while ( x < nECG - Deriva_Der -2 )
    
    if Posicion(x)
        
        % Busco el valor de los máximos
        Pico_Izq = max( ECG( x-Deriva_Izq : x ) );
        Pico_Der = max( ECG( x : x+Deriva_Der ) );
        
        % Busco la posición de los máximos
        X_Izq = Deriva_Izq + 1 - find (ECG( x-Deriva_Izq : x ) == Pico_Izq, 1, 'last');
        X_Der = - 1 + find (ECG( x : x+Deriva_Der ) == Pico_Der, 1);
        
        % Busco el pico
        if ECG(x) == max([Pico_Izq Pico_Der])
            % Ya estoy en el máximo
            X0 = 0;
            
        elseif ( (ECG(x-X_Izq - 2) <= Pico_Izq) && (ECG(x+X_Der + 2) <= Pico_Der) )
            % Hay picos a izquierda y a derecha
            if Pico_Izq >= Pico_Der
                X0 = - X_Izq;
            else
                X0 = X_Der;
            end
            
        elseif ECG(x-X_Izq - 2) <= Pico_Izq
            % Encontre el pico a la izquierda
            X0 = - X_Izq;
            
        elseif ECG(x+X_Der + 2) <= Pico_Der
            % Encontre el pico a la derecha
            X0 = X_Der;
            
        else
            % Estamos en un valle insondable
            if Pico_Izq >= Pico_Der
                X0 = - X_Izq;
            else
                X0 = X_Der;
            end
            
        end
        
        Posicion(x) = 0;
        Posicion(X0 + x) = 1;
        
        x = x + 50;
        
    end
    
    x = x + 1;
    
end


%% Evaluo el caso de que haya un pico en las primeras muestras
for x = 1 : 2*Deriva_Izq
    
    if Posicion(x)
        Pico = max( ECG( 1 : 2*Deriva_Izq ) );
        
        for i = 1 : 2*Deriva_Izq
            if (ECG(i) == Pico)
                break;
            end
        end
        
        Posicion(x) = 0;
        Posicion(i) = 1;
        
    end
    
end


%% Evaluo el caso de que haya un pico en las ultimas muestras
for x = nECG - Deriva_Der*2 : nECG
    
    if Posicion(x)
        Pico = max( ECG( nECG - Deriva_Der*2 : nECG ) );
        
        for i = nECG - Deriva_Der*2 : nECG
            if (ECG(i) == Pico)
                break;
            end
        end
        
        Posicion(x) = 0;
        Posicion(i) = 1;
        
    end
    
end


%% Evito los picos planos (elijo el de la izquierda)
x = 2;
while ( x < nECG)
     
     if Posicion(x)
          if ECG(x) == ECG(x-1)
               Posicion(x) = 0;
               Posicion(x-1) = 1;
          end
     end
     x = x + 1;
end


end

