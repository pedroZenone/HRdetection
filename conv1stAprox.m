function z = conv1stAprox( x,y )
%   TIJERETEO LA CONVOLUCION, GENERA LA FUNCION CONV('VALID')
%   z = conv1stAprox( x,y )

%% NOTA: Por iteracion, con avivol:

% lconv = lx + ly -1;    % longitud de la convolucion full
% lconvalid = lx - ly + 1;  % longitud de la convolucion valid
% 
% agregado = lconv - lconvalid = lx + ly - 1 - lx + ly - 1 = 2*(ly -1);
% Osea que el agregado que se le saca a la convolucion en modo full siempre es par!!
% se le saca de cada lado la misma cantidad = ly - 1
%%

WordSum = 3;

F = fimath;
F.RoundMode = 'nearest';
F.OverFlowMode = 'saturate';
F.ProductMode = 'SpecifyPrecision';
F.ProductWordLength = 32;
F.ProductFractionLength = 30;
F.SumMode = 'SpecifyPrecision';
F.SumWordLength = F.ProductFractionLength + WordSum;
F.SumFractionLength = F.ProductFractionLength;
% relativizo para trabajar en q1.15
maxx = max(abs(x)); x = x./maxx;
maxy = max(abs(y)); y = y./maxy;
% trunco el dato
x = fi(x,true,16,15); x.fimath = F;
y = fi(y,true,16,15); y.fimath = F;
% opero
z_aux = conv(x,y,'full');
z_aux = fi(z_aux,true,16,15);   % ya filtre, ahora vuelvo a truncar
% desrelativizo, nadie se entero        
z_aux = double(z_aux).*(maxx*maxy);

lz_aux = length(z_aux);

lx = length(x);
ly = length(y);

lAdd = 0;

%% elijo cual es mayor, si son iguales siempre dara 1
if lx > ly
    lAdd = ly -1;

else
    lAdd = lx -1;
end

% z = z_aux(lAdd+1:lz_aux-lAdd);

for i = 1:lz_aux-(2*lAdd)
    z(i) = z_aux(lAdd+i);
end
end

