%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Ruido
% Se analiza la presencia de ruido
% 
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ Posicion ] = Estado_Ruido( ECG, InterSignal, Posicion, Picos, Umbral, Fs, Recursividad )

d3 = InterSignal.d3;
Sin_d3 = InterSignal.Sin_d3;
nPicos = numel(Picos);
Ruido = Umbral.Ruido;


%% Ruido 'lento' (en detalle 3)
i = 2;
while i < nPicos - 1
     
     This = Picos(i-1);
     Next = Picos(i+1);
     
     Aux = d3( This : Next );
     Aux = abs(Aux);
     Pot_Aux  =  sum (sqrt( Aux) ) / (Next - This);
     
     if Pot_Aux > Ruido
          % Hemos detectado ruido. Vamos a procesar localmente esta parte
          % de la señal, pero sin el ruido
          
          if Recursividad == 1 || Pot_Aux > Ruido + 0.3
               % Muchísimo ruido
               warning('NICO: Señal excesivamente ruidosa. No se encontró información util.');
               Posicion(This:Next) = 0;
               
          else
               % Trataremos de salvar la situación
               Previos = Picos(i-1);
               Aux = Sin_d3(Previos:Next) ./ max( Sin_d3(Previos:Next) );
               Aux = abs (Aux);
               
               InterSignal_Aux.e1xe2 = Aux;
               InterSignal_Aux.d3 = Aux;
               InterSignal_Aux.d4 = Aux;
               InterSignal_Aux.Sin_d3 = Aux;
               
               Posicion(Previos:Next) = Maquina_Estados (ECG(Previos:Next), InterSignal_Aux, Umbral, Fs, Recursividad+1);
          end
     end
     
     i = i + 1;
end


%% Ruido 'rápido' (en detalle 4)
% i = 2;
% while i < nPicos - 2
%      
%      This = Picos(i-1);
%      Next = Picos(i+1);
%      
%      Aux = d4( This : Next );
%      Aux = abs(Aux);
%      Pot_Aux  =  sum (sqrt( Aux) ) / (Next - This);
%      
%      if Pot_Aux > Ruido
%           warning('NICO: Ruido rapido. %i', Picos(i));
%           Previos = Picos(i-1);
%           
% %           e1 = d5*1.5;
% % %           e2 = d3 .* d5;
% %           Detalle = abs ( e1 );
% %           
% %           Aux = Detalle(Previos:Next) ./ max(Detalle(Previos:Next));
% %           Aux = abs (Aux);
% %           Posicion(Previos:Next) = Proc_Alineal (ECG(Previos:Next), Aux, Aux, Aux, Umbral, Fs, Recur+1, d4, d5);       
%      end
%      i = i + 1;
% end

end


