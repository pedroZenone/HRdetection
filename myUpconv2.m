function y = myUpconv( x,h,snext)
% funcion que convoluciona y recorta. Realiza filtrado y upsample
% y = myUpconv( x,h,snext)
%   param: x: se�al a recomponer
%          h: filtro a aplicar
%          sNext : size del largo de la se�al a la que debe ser igual una
%          vez realizada la reconstruccion de esa instancia

aux = conv(myDyadup2(x),h,'full');
y = myWkeep2(aux,snext);
end

