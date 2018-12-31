function d = myDetcoef( c,l,n)
%   ENTREGA EL DETALLE SELECCIONADO. 
%   d = myDetcoef( c,l,n)
%   param: c: el vector con todos los datellaes cargados
%          l: coordenadas de los detalles
%          n: detalle a restrear

ll= length(l);  % size de l

z= l(1);    %me aseguro que tome el valor del ultimo detalle, si no entra en el for es porque el length de l = 3, osea solo un detalle

for i = 2:ll-n-1
    z = z +l(i);
end
z = z+1;

d = c(z:z+l(ll-n)-1);

end

