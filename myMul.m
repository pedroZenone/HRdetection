%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Multiplicación en Punto Fijo
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z = myMul( x,y )

F = fimath;
F.RoundMode = 'nearest';
F.OverFlowMode = 'saturate';
F.ProductMode = 'SpecifyPrecision';
F.ProductWordLength = 16;
F.ProductFractionLength = 15;
F.SumMode = 'SpecifyPrecision';
F.SumWordLength = 16+6;
F.SumFractionLength = 15;

% Relativizo para trabajar en q1.15
maxx = max(abs(x)); x = x./maxx;
maxy = max(abs(y)); y = y./maxy;

% Trunco el dato
x = fi(x,true,16,15); x.fimath = F;
y = fi(y,true,16,15); y.fimath = F;

% Opero
z_aux = x.*y;
z_aux = fi(z_aux,true,16,15);

% Desrelativizo, nadie se entero
z = double(z_aux).*(maxx*maxy);

end

