function d = myWrcoef( Hi_R,Lo_R,c,l,N)
% expande los coficietnes para que haya una realcion tiempo-muestra
%
%   d = myWrec(Hi_R,Lo_R,c,l,N)
%   param: c: el vector con todos los datellaes cargados
%          l: coordenadas de los detalles
%          Lo_R: filtro pasa bajos
%          Hi_R: filtro pasa altos
%          N:   nivel de detalle a expandir
ll = length(l);
kmin = ll-N;

x = myDetcoef(c,l,N);

d  = myUpconv(x,Hi_R,l(kmin+1));  %realizo la primer reconstruccion

for k = 2:N
    d  = myUpconv(d,Lo_R,l(kmin+k)); % paso por un pasabajos 
end

end

