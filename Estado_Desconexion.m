%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Desconexión del electrodo
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Desconexion( ECG, Posicion, MinDesconexion )

nECG = numel(ECG);

i = 1;
while i < (nECG - MinDesconexion)
     if (ECG(i) == ECG(i+1) == ECG(i+2) == ECG(i+2))
          
          j = 0;
          while (ECG(i+j) == ECG(i))
               j = j + 1;
          end
          
          if j > MinDesconexion 
               % Asumo que hubo desconexión
               Posicion (i-30:i+j+30) = 0;
          end
          
          i = i + j;
     end
     i = i + 1;
end

end


