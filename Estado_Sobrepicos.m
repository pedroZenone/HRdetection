%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Máquina de estados
% Estado: Sobrepicos
% Verifico que no haya picos excesivamente altos que me arruinoen el umbral
% 
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ e1xe2 ] = Estado_Sobrepicos( nECG, e1xe2, MuestrasPorPico )

for i = 2:1:6
    Sobrepicos = find (e1xe2 > i/10);
    if numel(Sobrepicos) < nECG / MuestrasPorPico
        e1xe2(Sobrepicos) = e1xe2(Sobrepicos) *i/10;
        e1xe2 = e1xe2 / max(e1xe2);
        break
    end
end

end


