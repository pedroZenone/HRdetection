function [c l] = myWavedec(x,n,Lo_D,Hi_D)
% Realiza la descomposicion de los n detalles
%   [c l] = myWavedec(x,n,Lo_D,Hi_D)
%   param:  x : se�al a descomponer
%           n: detalle a restrear%           
%          Lo_D: filtro pasa bajos
%          Hi_D: filtro pasa altos
%
%          c: el vector con todos los datellaes cargados en forma
%          secuencial
%          l: coordenadas de los detalles
%          

%% poner limitador de n%%
%% 

l = zeros(1,n+2);
c = [];
a = x;

for k = 1:n
    [a,d] = myDwt2(a,Lo_D,Hi_D); % decomposition
    c     = [d c];            % store detail
    l(n+2-k) = length(d);     % store length
end

% Last approximation.
c = [a c];
l(1) = length(a);
l(n+2) = length(x);


end

