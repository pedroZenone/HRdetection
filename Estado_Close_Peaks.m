%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Close Peaks
% Se verifica si hay picos muy cercanos entre sí (Distancia RR << Promedio)
% 
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Close_Peaks( ECG, Posicion, Picos, Delta_Picos, MinDelta )

nPicos = numel(Picos);

i = 2;
while i < nPicos - 2
     
     if Delta_Picos(i) < MinDelta
          
          This = Picos(i);
          Next = Picos(i+1);
          MaxLocal = max(ECG(This:Next));
          if ECG(This) < 0.7*MaxLocal
               Posicion(This) = 0;
               Picos(i) = [];
               Delta_Picos(i-1) = [];
               Delta_Picos(i-1) =  Picos(i) - Picos(i-1);
               nPicos = nPicos - 1;
          else
          
               Posicion (Picos(i+1)) = 0;
               Picos(i+1) = [];
               Delta_Picos(i) = [];
               Delta_Picos(i) =  Picos(i+1) - Picos(i);
               nPicos = nPicos - 1;
          end
          
     end
     i = i + 1;
end


%% 5bis) Zwischen picos
% i = 1;
% Stand = 0.8*std (Delta_Picos);
% while i < nPicos - 2
%      
%      Delta = Picos(i+2) - Picos (i);
%      if ( Delta > Prom - Stand ) && ( Delta < Prom + Stand )
%           warning('ACCAA %i', Picos(i));
%           Posicion (Picos(i+1)) = 0;
%           Picos(i+1) = [];
%           Delta_Picos(i) = [];
%           Delta_Picos(i) =  Picos(i+1) - Picos(i);
%           nPicos = nPicos - 1;
%      end
%      i = i + 1;
% end


end


