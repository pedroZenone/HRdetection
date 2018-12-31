function [a, d] = myDwt( x,Lo_D,Hi_D )
% realiza la descomposicion de una instancia.
%  [a d] = myDwt( x,Lo_D,Hi_D )
%   param: x: se�al a desconponer
%          Lo_D: filtro pasa bajos
%          Hi_D: filtro pasa altos
%     
%           a : coeficiente de la descomposicion unitaria
%           d : detalle de la descomposicion unitaria

lf = length(Lo_D)-1; %declaro el ancho a alargar de la wavelet
lx = length(x);
last = lf + lx;

y = myExtend(x,lf);
% d_aux = conv1stAprox(y,Hi_D);
d_aux = conv(y,Hi_D, 'valid');

d = d_aux(2:2:last);

% a_aux = conv1stAprox(y,Lo_D);
a_aux = conv(y,Lo_D, 'valid');

a = a_aux(2:2:last);

end

